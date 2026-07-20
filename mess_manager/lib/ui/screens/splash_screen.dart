import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/repository_providers.dart';

/// Decides where to land the user: onboarding for a fresh install,
/// or straight to the group list once at least one group exists.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    var groups = await ref.read(groupsRepositoryProvider).watchActiveGroups().first;
    // A fresh install with no local messes but an already-signed-in Google
    // session (persisted across reinstall on some devices, or a data-clear
    // that didn't touch the OS-level Google session) — restore this
    // account's existing online messes before assuming there's really
    // nothing and sending the user through "create a new mess" onboarding.
    if (groups.isEmpty && await ref.read(authServiceProvider).isSignedIn) {
      await ref.read(syncServiceProvider).restoreOnlineGroups().catchError((_) => 0);
      groups = await ref.read(groupsRepositoryProvider).watchActiveGroups().first;
    }
    if (!mounted) return;
    context.go(groups.isEmpty ? '/onboarding' : '/groups');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
