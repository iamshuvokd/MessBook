import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../providers/repository_providers.dart';

/// Two-step PIN creation (enter, then confirm). Saves via [AppLockService]
/// and returns true on success, null if the user cancelled.
Future<bool?> showPinSetupDialog(BuildContext context, WidgetRef ref) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _PinSetupDialog(),
  );
}

class _PinSetupDialog extends ConsumerStatefulWidget {
  const _PinSetupDialog();

  @override
  ConsumerState<_PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends ConsumerState<_PinSetupDialog> {
  final _first = TextEditingController();
  final _second = TextEditingController();
  bool _confirming = false;
  String? _error;

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!_confirming) {
      if (_first.text.length < 4) return;
      setState(() => _confirming = true);
      return;
    }
    if (_second.text != _first.text) {
      setState(() {
        _error = l10n.lockPinMismatch;
        _second.clear();
      });
      return;
    }
    await ref.read(appLockServiceProvider).setPin(_first.text);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = _confirming ? _second : _first;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
      title: Text(_confirming ? l10n.lockConfirmPin : l10n.lockSetPin),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, letterSpacing: 8),
            onChanged: (_) => setState(() => _error = null),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12.5)),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
        FilledButton(onPressed: _submit, child: Text(l10n.commonSave)),
      ],
    );
  }
}
