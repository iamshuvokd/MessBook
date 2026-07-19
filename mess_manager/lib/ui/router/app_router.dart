import 'package:go_router/go_router.dart';

import '../screens/account/account_screen.dart';
import '../screens/backup/backup_screen.dart';
import '../screens/bazar/bazar_screen.dart';
import '../screens/charts/charts_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/debug_screen.dart';
import '../screens/deposits/deposits_screen.dart';
import '../screens/expenses/add_edit_expense_screen.dart';
import '../screens/expenses/expense_list_screen.dart';
import '../screens/groups/group_edit_screen.dart';
import '../screens/groups/group_list_screen.dart';
import '../screens/groups/group_online_screen.dart';
import '../screens/groups/members_screen.dart';
import '../screens/help/help_screen.dart';
import '../screens/join/join_mess_screen.dart';
import '../screens/meals/meal_grid_screen.dart';
import '../screens/meals/meal_slots_screen.dart';
import '../screens/meals/member_meal_detail_screen.dart';
import '../screens/meals/member_routine_screen.dart';
import '../screens/meals/poll_detail_screen.dart';
import '../screens/meals/polls_list_screen.dart';
import '../screens/onboarding/create_group_wizard_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/premium/paywall_screen.dart';
import '../screens/recurring/recurring_screen.dart';
import '../screens/roles/roles_screen.dart';
import '../screens/reports/month_summary_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settle_up/settle_up_screen.dart';
import '../screens/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/onboarding/wizard', builder: (context, state) => const CreateGroupWizardScreen()),
    GoRoute(path: '/groups', builder: (context, state) => const GroupListScreen()),
    GoRoute(path: '/groups/new', builder: (context, state) => const GroupEditScreen()),
    GoRoute(
      path: '/groups/:id/edit',
      builder: (context, state) => GroupEditScreen(groupId: state.pathParameters['id']),
    ),
    GoRoute(
      path: '/groups/:id/dashboard',
      builder: (context, state) => DashboardScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/members',
      builder: (context, state) => MembersScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/roles',
      builder: (context, state) => RolesScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/deposits',
      builder: (context, state) => DepositsScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/settle-up',
      builder: (context, state) => SettleUpScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/meals',
      builder: (context, state) => MealGridScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/meals/:memberId',
      builder: (context, state) => MemberMealDetailScreen(
        groupId: state.pathParameters['id']!,
        memberId: state.pathParameters['memberId']!,
      ),
    ),
    GoRoute(
      path: '/groups/:id/meal-slots',
      builder: (context, state) => MealSlotsScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/bazar',
      builder: (context, state) => BazarScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/members/:memberId/routine',
      builder: (context, state) => MemberRoutineScreen(
        groupId: state.pathParameters['id']!,
        memberId: state.pathParameters['memberId']!,
        memberName: state.uri.queryParameters['name'] ?? '',
      ),
    ),
    GoRoute(
      path: '/groups/:id/polls',
      builder: (context, state) => PollsListScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/polls/:pollId',
      builder: (context, state) => PollDetailScreen(
        groupId: state.pathParameters['id']!,
        pollId: state.pathParameters['pollId']!,
      ),
    ),
    GoRoute(
      path: '/groups/:id/expenses',
      builder: (context, state) => ExpenseListScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/expenses/new',
      builder: (context, state) => AddEditExpenseScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/expenses/:expenseId/edit',
      builder: (context, state) => AddEditExpenseScreen(
        groupId: state.pathParameters['id']!,
        expenseId: state.pathParameters['expenseId'],
      ),
    ),
    GoRoute(
      path: '/groups/:id/report',
      builder: (context, state) => MonthSummaryScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/settings',
      builder: (context, state) => SettingsScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/recurring',
      builder: (context, state) => RecurringScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/charts',
      builder: (context, state) => ChartsScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/online',
      builder: (context, state) => GroupOnlineScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/:id/chat',
      builder: (context, state) => ChatScreen(groupId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/account', builder: (context, state) => const AccountScreen()),
    GoRoute(path: '/help', builder: (context, state) => const HelpScreen()),
    GoRoute(path: '/join', builder: (context, state) => const JoinMessScreen()),
    GoRoute(path: '/backup', builder: (context, state) => const BackupScreen()),
    GoRoute(path: '/premium/paywall', builder: (context, state) => const PaywallScreen()),
    GoRoute(path: '/debug', builder: (context, state) => const DebugScreen()),
  ],
);
