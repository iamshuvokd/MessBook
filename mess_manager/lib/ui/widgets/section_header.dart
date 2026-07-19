import 'package:flutter/material.dart';

/// The grey uppercase-style section label used across Settings, Account,
/// the drawer and the Roles screen — extracted so every screen stays
/// visually consistent.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.4, color: Colors.grey),
      ),
    );
  }
}
