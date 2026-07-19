import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';

enum AppTab { home, expenses, meals, report, settings }

/// Bottom nav shared by the group-scoped screens.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.groupId, required this.current});

  final String groupId;
  final AppTab current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    void go(AppTab tab) {
      if (tab == current) return;
      switch (tab) {
        case AppTab.home:
          context.go('/groups/$groupId/dashboard');
        case AppTab.expenses:
          context.go('/groups/$groupId/expenses');
        case AppTab.meals:
          context.go('/groups/$groupId/meals');
        case AppTab.report:
          context.go('/groups/$groupId/report');
        case AppTab.settings:
          context.go('/groups/$groupId/settings');
      }
    }

    return NavigationBar(
      selectedIndex: current.index,
      onDestinationSelected: (i) => go(AppTab.values[i]),
      destinations: [
        NavigationDestination(icon: const Icon(Icons.home_rounded), label: l10n.navHome),
        NavigationDestination(icon: const Icon(Icons.receipt_long_rounded), label: l10n.navExpenses),
        NavigationDestination(icon: const Icon(Icons.restaurant_rounded), label: l10n.navMeals),
        NavigationDestination(icon: const Icon(Icons.summarize_rounded), label: l10n.navReport),
        NavigationDestination(icon: const Icon(Icons.settings_rounded), label: l10n.navSettings),
      ],
    );
  }
}
