import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'api_client.dart';
import 'google_sign_in_bootstrap.dart';

class AuthUser {
  const AuthUser({required this.id, required this.email, this.name, this.photoUrl});

  final String id;
  final String email;
  final String? name;
  final String? photoUrl;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
        photoUrl: (json['photoUrl'] ?? json['photo_url']) as String?,
      );

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name, 'photoUrl': photoUrl};
}

/// Google sign-in + session bookkeeping. The app stays fully usable signed
/// out (offline-first) — this is purely opt-in, for bringing a mess online
/// or joining one that already is.
class AuthService {
  AuthService(this._api, this._storage);

  final ApiClient _api;
  final FlutterSecureStorage _storage;

  static const _userKey = 'auth_user';

  Future<AuthUser?> get currentUser async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null) return null;
    return AuthUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<bool> get isSignedIn => _api.isSignedIn;

  /// Signs in silently if a prior Google session exists; otherwise prompts
  /// the user interactively. Exchanges the Google ID token for an app
  /// session and caches the profile locally.
  Future<AuthUser> signIn() async {
    await ensureGoogleSignInInitialized();
    var account = await GoogleSignIn.instance.attemptLightweightAuthentication();
    // The lightweight/silent path can return a valid account without a
    // fresh ID token (only the full interactive flow reliably includes
    // one) — fall through to authenticate() whenever the token is missing,
    // not just when the account itself is null.
    if (account == null || account.authentication.idToken == null) {
      account = await GoogleSignIn.instance.authenticate();
    }

    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw StateError('Google sign-in did not return an ID token.');
    }

    final response = await _api.postPublic('/auth/google', {'idToken': idToken});
    await _api.saveSession(access: response['access'] as String, refresh: response['refresh'] as String);

    final user = AuthUser.fromJson(response['user'] as Map<String, dynamic>);
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
    return user;
  }

  Future<void> signOut() async {
    final refresh = await _api.refreshToken;
    if (refresh != null) {
      try {
        await _api.postPublic('/auth/logout', {'refreshToken': refresh});
      } catch (_) {
        // Best-effort revoke; local sign-out proceeds regardless.
      }
    }
    await _api.clearSession();
    await _storage.delete(key: _userKey);
    await ensureGoogleSignInInitialized();
    await GoogleSignIn.instance.signOut();
  }
}
