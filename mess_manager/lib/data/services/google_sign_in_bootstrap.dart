import 'package:google_sign_in/google_sign_in.dart';

/// The Web OAuth client (Google Cloud Console, Step 4) — required as
/// `serverClientId` so the ID token Android returns is issued for *this*
/// audience and can be verified by `google-auth-library` on the server
/// (which checks it against `GOOGLE_CLIENT_IDS`). Without it, native
/// sign-in can fail outright on Android before any UI even shows.
const _webClientId = '671805408245-ht6k75kjfkqt8oa0rtbden4esu84saks.apps.googleusercontent.com';

/// `GoogleSignIn.instance.initialize()` must be called exactly once app-wide
/// before any other GoogleSignIn method — but both [AuthService] (account
/// sign-in) and `DriveBackupService` (Drive appdata) need it. This guard
/// makes the call idempotent across every caller, regardless of how many
/// service instances exist.
Future<void>? _initFuture;

Future<void> ensureGoogleSignInInitialized() {
  return _initFuture ??= GoogleSignIn.instance.initialize(serverClientId: _webClientId);
}
