import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/repository_providers.dart';

/// The shared pull-to-refresh behavior for every group-scoped list screen:
/// syncs the group (if it's online) before letting the gesture complete.
/// Local Drift streams pick up whatever the pull brought down automatically
/// — no manual provider invalidation needed. A no-op (but still lets the
/// pull-down animate and settle) for groups that aren't online yet, or if
/// the sync fails, since this is a convenience refresh, not a required step.
class SyncRefreshIndicator extends ConsumerWidget {
  const SyncRefreshIndicator({super.key, required this.groupId, required this.child});

  final String groupId;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        final groups = ref.read(activeGroupsProvider).value ?? const [];
        final matching = groups.where((g) => g.id == groupId);
        if (matching.isEmpty || !matching.first.isOnline) return;
        try {
          await ref.read(syncServiceProvider).syncGroup(groupId);
        } catch (_) {
          // Best-effort — offline or server-down just means nothing new
          // came down; the refresh gesture still completes normally.
        }
      },
      child: child,
    );
  }
}
