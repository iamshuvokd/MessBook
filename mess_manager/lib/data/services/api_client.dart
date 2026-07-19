import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// Thrown when a request fails after a refresh attempt (or refresh itself
/// fails) — callers should treat this as "signed out, please sign in again".
class ApiAuthException implements Exception {
  const ApiAuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ApiException implements Exception {
  const ApiException(this.statusCode, this.body);
  final int statusCode;
  final Map<String, dynamic> body;
  @override
  String toString() => 'ApiException($statusCode): ${body['error'] ?? body}';
}

/// Talks to the Mess Manager sync server. The app is offline-first — every
/// call here is opportunistic (used for accounts/sync/polls-online only);
/// nothing in the app blocks on this client being reachable.
class ApiClient {
  ApiClient(this._storage, {required String Function() baseUrlProvider}) : _baseUrlProvider = baseUrlProvider;

  final FlutterSecureStorage _storage;
  final String Function() _baseUrlProvider;

  static const _accessKey = 'auth_access_token';
  static const _refreshKey = 'auth_refresh_token';

  String get baseUrl => _baseUrlProvider();

  Future<String?> get accessToken => _storage.read(key: _accessKey);
  Future<String?> get refreshToken => _storage.read(key: _refreshKey);

  Future<void> saveSession({required String access, required String refresh}) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  Future<bool> get isSignedIn async => (await refreshToken) != null;

  Future<Map<String, dynamic>> get(String path) => _authedRequest('GET', path);
  Future<Map<String, dynamic>> post(String path, [Map<String, dynamic>? body]) => _authedRequest('POST', path, body);
  Future<Map<String, dynamic>> patch(String path, [Map<String, dynamic>? body]) => _authedRequest('PATCH', path, body);
  Future<Map<String, dynamic>> delete(String path) => _authedRequest('DELETE', path);

  /// For endpoints that don't require (or don't yet have) a session — e.g.
  /// `/auth/google` — so a non-2xx response surfaces as a plain
  /// [ApiException] instead of being misread as "access token expired".
  Future<Map<String, dynamic>> postPublic(String path, [Map<String, dynamic>? body]) async {
    final response = await _send('POST', path, body, null);
    return _decode(response);
  }

  Future<Map<String, dynamic>> _authedRequest(String method, String path, [Map<String, dynamic>? body, bool retried = false]) async {
    final access = await accessToken;
    final response = await _send(method, path, body, access);

    if (response.statusCode == 401 && !retried) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) return _authedRequest(method, path, body, true);
      throw const ApiAuthException('Session expired — please sign in again.');
    }

    return _decode(response);
  }

  Future<http.Response> _send(String method, String path, Map<String, dynamic>? body, String? access) {
    final uri = Uri.parse('$baseUrl$path');
    final headers = {
      'Content-Type': 'application/json',
      if (access != null) 'Authorization': 'Bearer $access',
    };
    final encoded = body == null ? null : jsonEncode(body);
    return switch (method) {
      'GET' => http.get(uri, headers: headers),
      'POST' => http.post(uri, headers: headers, body: encoded),
      'PATCH' => http.patch(uri, headers: headers, body: encoded),
      'DELETE' => http.delete(uri, headers: headers),
      _ => throw ArgumentError('Unsupported method $method'),
    };
  }

  Future<bool> _refreshAccessToken() async {
    final refresh = await refreshToken;
    if (refresh == null) return false;
    final response = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refresh}),
    );
    if (response.statusCode != 200) {
      await clearSession();
      return false;
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    await saveSession(access: json['access'] as String, refresh: json['refresh'] as String);
    return true;
  }

  Map<String, dynamic> _decode(http.Response response) {
    final json = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) return json;
    throw ApiException(response.statusCode, json);
  }
}
