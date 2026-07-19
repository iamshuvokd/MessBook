import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/category_l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/icon_lookup.dart';
import '../providers/app_providers.dart';

class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(categoriesStreamProvider);
    final groups = ref.watch(groupsStreamProvider);
    final members = ref.watch(membersStreamProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.debugScreenTitle),
        actions: [
          IconButton(
            tooltip: 'EN / বাং',
            icon: Text(
              locale.languageCode == 'en' ? 'বাং' : 'EN',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            onPressed: () => ref.read(localeProvider.notifier).toggle(),
          ),
          IconButton(
            icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(text: '${l10n.debugGroups}: ${groups.value?.length ?? '…'}'),
          _SectionHeader(text: '${l10n.debugMembers}: ${members.value?.length ?? '…'}'),
          const SizedBox(height: 8),
          _SectionHeader(text: l10n.debugCategories),
          const SizedBox(height: 8),
          categories.when(
            data: (rows) => rows.isEmpty
                ? Padding(padding: const EdgeInsets.all(24), child: Text(l10n.debugNoData))
                : Column(
                    children: [
                      for (final c in rows)
                        Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                              child: Icon(lookupIcon(c.icon)),
                            ),
                            title: Text(resolveCategoryName(l10n, c.defaultKey, c.name)),
                            subtitle: c.isMealCategory ? Text(l10n.navMeals) : null,
                          ),
                        ),
                    ],
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Error: $e'),
          ),
          const SizedBox(height: 24),
          Text(
            '৳12,345.50',
            style: moneyTextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
