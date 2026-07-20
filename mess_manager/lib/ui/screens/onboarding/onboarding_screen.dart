import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    // The last page is the admin/member fork — its two cards are the only
    // way forward, so the bottom button never appears there.
    if (_page < 3) {
      _controller.nextPage(duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _LanguagePage(l10n: l10n, locale: locale),
                  _InfoPage(
                    icon: Icons.cloud_off_rounded,
                    title: l10n.onboardPage2Title,
                    body: l10n.onboardPage2Body,
                  ),
                  _InfoPage(
                    icon: Icons.cloud_upload_rounded,
                    title: l10n.onboardPage3Title,
                    body: l10n.onboardPage3Body,
                  ),
                  _RolePage(l10n: l10n),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  if (_page < 3)
                    FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      child: Text(l10n.commonNext),
                    ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      final active = i == _page;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 20 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: active
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguagePage extends ConsumerWidget {
  const _LanguagePage({required this.l10n, required this.locale});

  final AppLocalizations l10n;
  final Locale locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(26),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
            ),
            alignment: Alignment.center,
            child: const Text('৳', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          const SizedBox(height: 22),
          Text(l10n.onboardTitle, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            l10n.onboardPage1Body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 34),
          Row(
            children: [
              Expanded(
                child: _LanguageCard(
                  label: l10n.onboardLanguageBangla,
                  selected: locale.languageCode == 'bn',
                  onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('bn')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LanguageCard(
                  label: l10n.onboardLanguageEnglish,
                  selected: locale.languageCode == 'en',
                  onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('en')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: selected ? scheme.primary : scheme.outline, width: 2),
          color: selected ? scheme.primaryContainer.withValues(alpha: 0.35) : null,
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: selected ? scheme.primary : scheme.outline,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// The final onboarding step: who is this person? A mess manager creates
/// their mess right away; a member goes straight to sign-in + invite code.
/// Pushed (not go) for the join path so the system back button returns here.
class _RolePage extends StatelessWidget {
  const _RolePage({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.onboardRoleTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 28),
          _RoleCard(
            icon: Icons.storefront_rounded,
            title: l10n.onboardRoleAdminTitle,
            subtitle: l10n.onboardRoleAdminSub,
            onTap: () => context.go('/onboarding/wizard'),
          ),
          const SizedBox(height: 14),
          _RoleCard(
            icon: Icons.badge_rounded,
            title: l10n.onboardRoleMemberTitle,
            subtitle: l10n.onboardRoleMemberSub,
            onTap: () => context.push('/join'),
          ),
          const SizedBox(height: 8),
          const _RestoreAccountLink(),
        ],
      ),
    );
  }
}

/// For a returning App Admin/member on a fresh install or new device: sign
/// in and immediately restore whichever online messes this Google account
/// already owns or has joined, instead of forcing them through "create a
/// new mess". [AuthController.signIn] does the actual restore; this just
/// drives it and reacts to the outcome.
class _RestoreAccountLink extends ConsumerWidget {
  const _RestoreAccountLink();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);

    Future<void> restore() async {
      await ref.read(authControllerProvider.notifier).signIn();
      if (!context.mounted) return;
      final result = ref.read(authControllerProvider);
      if (result.hasError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.commonErrorPrefix(result.error.toString()))));
        return;
      }
      final groups = await ref.read(groupsRepositoryProvider).watchActiveGroups().first;
      if (!context.mounted) return;
      if (groups.isNotEmpty) {
        context.go('/groups');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.onboardRestoreNoMessFound)));
      }
    }

    return Center(
      child: TextButton(
        onPressed: authState.isLoading ? null : restore,
        child: authState.isLoading
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(l10n.onboardRestoreLink),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: scheme.outline, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: Icon(icon, size: 26, color: scheme.onPrimaryContainer),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _InfoPage extends StatelessWidget {
  const _InfoPage({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, size: 42, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 24),
          Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
