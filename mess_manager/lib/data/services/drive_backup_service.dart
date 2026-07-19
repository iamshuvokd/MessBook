import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

import 'backup_service.dart';
import 'google_sign_in_bootstrap.dart';

const _driveScopes = ['https://www.googleapis.com/auth/drive.appdata'];
const _backupFileName = 'messbook_backup.json';

/// Google Drive appDataFolder backup (premium), per spec §6. Uses the
/// google_sign_in 7.x incremental-authorization API: a lightweight
/// (silent) attempt first, falling back to an interactive prompt only
/// when explicitly requested by the caller.
class DriveBackupService {
  DriveBackupService(this._backupService);

  final BackupService _backupService;
  GoogleSignInAccount? _account;

  /// Signs in silently if a prior session exists; otherwise (when
  /// [interactive] is true) prompts the user. Returns null if unavailable.
  Future<GoogleSignInAccount?> signIn({bool interactive = false}) async {
    await ensureGoogleSignInInitialized();
    _account ??= await GoogleSignIn.instance.attemptLightweightAuthentication();
    if (_account == null && interactive) {
      _account = await GoogleSignIn.instance.authenticate();
    }
    return _account;
  }

  Future<void> signOut() async {
    await ensureGoogleSignInInitialized();
    await GoogleSignIn.instance.signOut();
    _account = null;
  }

  Future<bool> isSignedIn() async => (await signIn()) != null;

  Future<drive.DriveApi?> _driveApi({bool interactive = false}) async {
    final account = await signIn(interactive: interactive);
    if (account == null) return null;
    final headers = await account.authorizationClient.authorizationHeaders(
      _driveScopes,
      promptIfNecessary: interactive,
    );
    if (headers == null) return null;
    return drive.DriveApi(_HeaderAuthClient(headers));
  }

  Future<drive.File?> _findBackupFile(drive.DriveApi api) async {
    final list = await api.files.list(spaces: 'appDataFolder', q: "name = '$_backupFileName'");
    final files = list.files;
    return (files == null || files.isEmpty) ? null : files.first;
  }

  /// Uploads the current DB state to the app's Drive appData folder,
  /// creating or replacing the single backup file. Requires an interactive
  /// sign-in on first use; silent afterward.
  Future<void> backupNow({bool interactive = false}) async {
    final api = await _driveApi(interactive: interactive);
    if (api == null) throw StateError('Not signed in to Google Drive');

    final json = await _backupService.exportJson();
    final bytes = utf8.encode(json);
    final media = drive.Media(Stream.value(bytes), bytes.length, contentType: 'application/json');

    final existing = await _findBackupFile(api);
    if (existing != null) {
      await api.files.update(drive.File(), existing.id!, uploadMedia: media);
    } else {
      final file = drive.File()
        ..name = _backupFileName
        ..parents = ['appDataFolder'];
      await api.files.create(file, uploadMedia: media);
    }
  }

  /// Downloads the backup JSON from Drive, or null if none exists yet.
  Future<String?> restoreLatest({bool interactive = false}) async {
    final api = await _driveApi(interactive: interactive);
    if (api == null) throw StateError('Not signed in to Google Drive');

    final existing = await _findBackupFile(api);
    if (existing == null) return null;

    final media = await api.files.get(existing.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
    final chunks = <int>[];
    await for (final chunk in media.stream) {
      chunks.addAll(chunk);
    }
    return utf8.decode(chunks);
  }
}

class _HeaderAuthClient extends http.BaseClient {
  _HeaderAuthClient(this._headers);

  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
