/// A mess is "fully customizable" by its App Admin (user decision,
/// 2026-07-15): every editable area of the app — meals, polls, expenses,
/// money, members — is gated by one of these flags, which the App Admin
/// hands to sub-admins individually or via a one-tap preset.
enum MemberPermission {
  mealsManage,
  pollsCreate,
  pollsManage,
  expensesManage,
  moneyManage,
  membersManage;

  String get key => switch (this) {
        MemberPermission.mealsManage => 'meals.manage',
        MemberPermission.pollsCreate => 'polls.create',
        MemberPermission.pollsManage => 'polls.manage',
        MemberPermission.expensesManage => 'expenses.manage',
        MemberPermission.moneyManage => 'money.manage',
        MemberPermission.membersManage => 'members.manage',
      };

  static MemberPermission? fromKey(String key) =>
      MemberPermission.values.where((p) => p.key == key).firstOrNull;

  static Set<MemberPermission> setFromDb(String csv) => csv
      .split(',')
      .map((s) => fromKey(s.trim()))
      .whereType<MemberPermission>()
      .toSet();

  static String setToDb(Set<MemberPermission> permissions) =>
      permissions.map((p) => p.key).join(',');
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

/// One-tap permission bundles shown in the assignment UI (user decision).
/// The App Admin can still fine-tune individual flags after picking one.
enum PermissionPreset {
  mealAdmin,
  expenseAdmin,
  pollCreator,
  memberAdmin;

  String get labelKey => switch (this) {
        PermissionPreset.mealAdmin => 'presetMealAdmin',
        PermissionPreset.expenseAdmin => 'presetExpenseAdmin',
        PermissionPreset.pollCreator => 'presetPollCreator',
        PermissionPreset.memberAdmin => 'presetMemberAdmin',
      };

  Set<MemberPermission> get permissions => switch (this) {
        PermissionPreset.mealAdmin => const {
            MemberPermission.mealsManage,
            MemberPermission.pollsCreate,
            MemberPermission.pollsManage,
          },
        PermissionPreset.expenseAdmin => const {
            MemberPermission.expensesManage,
            MemberPermission.moneyManage,
          },
        PermissionPreset.pollCreator => const {MemberPermission.pollsCreate},
        PermissionPreset.memberAdmin => const {MemberPermission.membersManage},
      };
}

enum MemberRole {
  appAdmin,
  subAdmin,
  member;

  static MemberRole fromDb(String value) => MemberRole.values.firstWhere(
        (e) => e.name == value,
        orElse: () => MemberRole.member,
      );
}
