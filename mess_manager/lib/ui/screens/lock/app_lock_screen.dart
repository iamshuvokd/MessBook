import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/repository_providers.dart';

/// Full-screen unlock gate shown at cold start when app lock is enabled.
/// Tries biometrics first (if available), falls back to a PIN pad.
class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  String _pin = '';
  String? _error;
  bool _biometricTried = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  Future<void> _tryBiometric() async {
    if (_biometricTried) return;
    _biometricTried = true;
    final service = ref.read(appLockServiceProvider);
    if (!await service.canUseBiometrics()) return;
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final ok = await service.authenticateWithBiometrics(l10n.lockUnlock);
    if (ok && mounted) ref.read(sessionUnlockedProvider.notifier).unlock();
  }

  Future<void> _onDigit(String d) async {
    if (_pin.length >= 6) return;
    setState(() {
      _pin += d;
      _error = null;
    });
    if (_pin.length >= 4) {
      final service = ref.read(appLockServiceProvider);
      final ok = await service.verifyPin(_pin);
      if (ok) {
        ref.read(sessionUnlockedProvider.notifier).unlock();
      } else if (_pin.length == 6) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context);
        setState(() {
          _error = l10n.lockWrongPin;
          _pin = '';
        });
      }
    }
  }

  void _backspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = ref.watch(sessionUnlockedProvider);
    if (unlocked) return widget.child;

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(gradient: AppColors.heroGradient, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.lock_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 20),
              Text(l10n.lockEnterPin, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  final filled = i < _pin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? Theme.of(context).colorScheme.primary : Colors.transparent,
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                    ),
                  );
                }),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12.5)),
              ],
              const SizedBox(height: 30),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.6,
                children: [
                  for (final k in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'back'])
                    if (k.isEmpty)
                      const SizedBox.shrink()
                    else
                      InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () => k == 'back' ? _backspace() : _onDigit(k),
                        child: Center(
                          child: k == 'back'
                              ? const Icon(Icons.backspace_outlined)
                              : Text(k, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                        ),
                      ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _tryBiometric,
                icon: const Icon(Icons.fingerprint_rounded),
                label: Text(l10n.lockUseBiometric),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
