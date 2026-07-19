import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../providers/repository_providers.dart';

/// The app-wide navigation drawer, attached to every bottom-nav tab screen.
/// Everything the app can do is reachable from here in one tap, grouped so
/// a first-time user can see the whole feature map at a glance. The bottom
/// nav keeps the five everyday tabs; the drawer is the full directory.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final group = ref.watch(selectedGroupProvider);
    final isAppAdmin = ref.watch(actingAsMemberProvider)?.isAppAdmin ?? true;
    final mealEnabled = group?.mealEnabled ?? true;
    final isOnline = group?.isOnline ?? false;
    final inviteCode = group?.inviteCode;
    final premium = ref.watch(premiumUnlockedProvider).value ?? false;

    // Captured once so every onTap can pop the drawer first and still
    // navigate — after the pop, the drawer's own context is unusable.
    final router = GoRouter.of(context);
    void goTab(String route) {
      Navigator.of(context).pop();
      router.go(route);
    }

    void push(String route) {
      Navigator.of(context).pop();
      router.push(route);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  group?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (isOnline && inviteCode != null)
                      InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: inviteCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${l10n.onlineInviteCodeLabel}: $inviteCode')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.key_rounded, size: 13, color: Colors.white),
                              const SizedBox(width: 5),
                              Text(inviteCode,
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1)),
                            ],
                          ),
                        ),
                      ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      onTap: () => goTab('/groups'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.swap_horiz_rounded, size: 14, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(l10n.drawerSwitchMess, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (mealEnabled) ...[
            _DrawerSection(l10n.drawerSectionDaily),
            _DrawerItem(icon: Icons.restaurant_rounded, label: l10n.navMeals, onTap: () => goTab('/groups/$groupId/meals')),
            _DrawerItem(icon: Icons.how_to_vote_rounded, label: l10n.pollsTitle, onTap: () => push('/groups/$groupId/polls')),
            _DrawerItem(icon: Icons.shopping_basket_rounded, label: l10n.bazarTitle, onTap: () => push('/groups/$groupId/bazar')),
            if (isOnline) _DrawerItem(icon: Icons.chat_rounded, label: l10n.chatTitle, onTap: () => push('/groups/$groupId/chat')),
          ],
          _DrawerSection(l10n.drawerSectionMoney),
          _DrawerItem(icon: Icons.receipt_long_rounded, label: l10n.navExpenses, onTap: () => goTab('/groups/$groupId/expenses')),
          _DrawerItem(icon: Icons.savings_rounded, label: l10n.depositsTitle, onTap: () => push('/groups/$groupId/deposits')),
          _DrawerItem(icon: Icons.handshake_rounded, label: l10n.settleUpTitle, onTap: () => push('/groups/$groupId/settle-up')),
          _DrawerItem(
            icon: Icons.repeat_rounded,
            label: l10n.recurringTitle,
            pro: !premium,
            onTap: () => push('/groups/$groupId/recurring'),
          ),
          _DrawerSection(l10n.drawerSectionPeople),
          _DrawerItem(icon: Icons.group_rounded, label: l10n.membersTitle, onTap: () => push('/groups/$groupId/members')),
          if (isAppAdmin)
            _DrawerItem(
              icon: Icons.admin_panel_settings_rounded,
              label: l10n.settingsRolesSection,
              onTap: () => push('/groups/$groupId/roles'),
            ),
          _DrawerSection(l10n.drawerSectionInsights),
          _DrawerItem(icon: Icons.summarize_rounded, label: l10n.navReport, onTap: () => goTab('/groups/$groupId/report')),
          _DrawerItem(
            icon: Icons.insights_rounded,
            label: l10n.chartsTitle,
            pro: !premium,
            onTap: () => push('/groups/$groupId/charts'),
          ),
          _DrawerSection(l10n.drawerSectionSystem),
          _DrawerItem(icon: Icons.cloud_rounded, label: l10n.onlineSectionTitle, onTap: () => push('/groups/$groupId/online')),
          _DrawerItem(icon: Icons.cloud_upload_rounded, label: l10n.backupTitle, onTap: () => push('/backup')),
          _DrawerItem(icon: Icons.settings_rounded, label: l10n.navSettings, onTap: () => goTab('/groups/$groupId/settings')),
          _DrawerItem(icon: Icons.account_circle_rounded, label: l10n.accountTitle, onTap: () => push('/account')),
          _DrawerItem(icon: Icons.help_outline_rounded, label: l10n.helpTitle, onTap: () => push('/help')),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _DrawerSection extends StatelessWidget {
  const _DrawerSection(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: Colors.grey),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.icon, required this.label, required this.onTap, this.pro = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      leading: Icon(icon, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: pro
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Text(
                AppLocalizations.of(context).commonProBadge,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF3D2C05)),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
