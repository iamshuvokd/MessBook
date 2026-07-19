import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

/// Static FAQ, grouped by topic. Every question a first-time mess manager
/// or member actually has — no group context needed, so this screen works
/// identically whether or not a mess is even selected yet.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = <(String, String)>[
      (l10n.helpQCreateMess, l10n.helpACreateMess),
      (l10n.helpQAddMembers, l10n.helpAAddMembers),
      (l10n.helpQRoles, l10n.helpARoles),
      (l10n.helpQJoin, l10n.helpAJoin),
      (l10n.helpQMeals, l10n.helpAMeals),
      (l10n.helpQMealRate, l10n.helpAMealRate),
      (l10n.helpQPolls, l10n.helpAPolls),
      (l10n.helpQSettleUp, l10n.helpASettleUp),
      (l10n.helpQMonthClose, l10n.helpAMonthClose),
      (l10n.helpQBackup, l10n.helpABackup),
      (l10n.helpQOnline, l10n.helpAOnline),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(l10n.helpTitle),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (context, i) {
          final (question, answer) = entries[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                title: Text(question, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedAlignment: Alignment.topLeft,
                children: [
                  Text(answer, style: const TextStyle(fontSize: 12.5, height: 1.5, color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
