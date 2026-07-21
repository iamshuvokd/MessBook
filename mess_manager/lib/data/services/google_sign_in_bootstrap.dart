import 'package:google_sign_in/google_sign_in.dart';

/// The Web OAuth client (`client_type: 3` in google-services.json) —
/// required as `serverClientId` so the ID token Android returns is issued
/// for *this* audience and can be verified by `google-auth-library` on the
/// server (which checks it against `GOOGLE_CLIENT_IDS`). Without it, native
/// sign-in can fail outright on Android before any UI even shows. Must be
/// the Web client of the SAME Firebase project as google-services.json
/// (messbook-app / 24075557821) — an ID token from one project cannot be
/// verified against another project's client id.
const _webClientId = '24075557821-upefqtd72cgko8ai0c2ub883hgqsv8u9.apps.googleusercontent.com';

/// `GoogleSignIn.instance.initialize()` must be called exactly once app-wide
/// before any other GoogleSignIn method — but both [AuthService] (account
/// sign-in) and `DriveBackupService` (Drive appdata) need it. This guard
/// makes the call idempotent across every caller, regardless of how many
/// service instances exist.
Future<void>? _initFuture;

Future<void> ensureGoogleSignInInitialized() {
  return _initFuture ??= GoogleSignIn.instance.initialize(serverClientId: _webClientId);
}
