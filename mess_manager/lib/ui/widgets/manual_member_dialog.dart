import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';

typedef ManualMemberResult = ({String name, String? phone});

Future<ManualMemberResult?> showManualMemberDialog(
  BuildContext context, {
  String? initialName,
  String? initialPhone,
}) {
  return showDialog<ManualMemberResult>(
    context: context,
    builder: (_) => _ManualMemberDialog(initialName: initialName, initialPhone: initialPhone),
  );
}

class _ManualMemberDialog extends StatefulWidget {
  const _ManualMemberDialog({this.initialName, this.initialPhone});

  final String? initialName;
  final String? initialPhone;

  @override
  State<_ManualMemberDialog> createState() => _ManualMemberDialogState();
}

class _ManualMemberDialogState extends State<_ManualMemberDialog> {
  late final _name = TextEditingController(text: widget.initialName);
  late final _phone = TextEditingController(text: widget.initialPhone);

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
      title: Text(l10n.wizardAddManually),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _name, autofocus: true, decoration: InputDecoration(hintText: l10n.wizardMemberNameHint)),
          const SizedBox(height: 10),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: l10n.wizardPhoneHint),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonCancel)),
        FilledButton(
          onPressed: () {
            final name = _name.text.trim();
            if (name.isEmpty) return;
            final phone = _phone.text.trim();
            Navigator.of(context).pop((name: name, phone: phone.isEmpty ? null : phone));
          },
          child: Text(l10n.commonAdd),
        ),
      ],
    );
  }
}
