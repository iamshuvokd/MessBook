import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';

import '../repositories/app_settings_repository.dart';

const appLockEnabledSettingKey = 'appLockEnabled';
const appLockPinHashSettingKey = 'appLockPinHash';

class AppLockService {
  AppLockService(this._settings, [LocalAuthentication? auth]) : _auth = auth ?? LocalAuthentication();

  final AppSettingsRepository _settings;
  final LocalAuthentication _auth;

  String _hashPin(String pin) => sha256.convert(utf8.encode(pin)).toString();

  Future<bool> isEnabled() async => (await _settings.get(appLockEnabledSettingKey)) == 'true';

  Future<bool> hasPin() async => (await _settings.get(appLockPinHashSettingKey)) != null;

  Future<void> setPin(String pin) async {
    await _settings.set(appLockPinHashSettingKey, _hashPin(pin));
    await _settings.set(appLockEnabledSettingKey, 'true');
  }

  Future<void> disable() async {
    await _settings.set(appLockEnabledSettingKey, 'false');
  }

  /// Re-enables lock using the already-configured PIN (no-op if none exists).
  Future<void> enable() async {
    if (await hasPin()) await _settings.set(appLockEnabledSettingKey, 'true');
  }

  Future<bool> verifyPin(String pin) async {
    final stored = await _settings.get(appLockPinHashSettingKey);
    return stored != null && stored == _hashPin(pin);
  }

  Future<bool> canUseBiometrics() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
