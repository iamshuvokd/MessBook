// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MessBook';

  @override
  String get navHome => 'Home';

  @override
  String get navExpenses => 'Expenses';

  @override
  String get navMeals => 'Meals';

  @override
  String get navReport => 'Report';

  @override
  String get navSettings => 'Settings';

  @override
  String get debugScreenTitle => 'Debug · Seed data';

  @override
  String get debugGroups => 'Groups';

  @override
  String get debugMembers => 'Members';

  @override
  String get debugCategories => 'Categories';

  @override
  String get debugNoData => 'No data yet';

  @override
  String get categoryBazar => 'Bazar/Grocery';

  @override
  String get categoryRent => 'Rent';

  @override
  String get categoryUtility => 'Utility';

  @override
  String get categoryWifi => 'WiFi';

  @override
  String get categoryMaid => 'Maid/Cook';

  @override
  String get categoryGas => 'Gas Cylinder';

  @override
  String get categoryRepairs => 'Repairs';

  @override
  String get categoryMisc => 'Misc';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageBangla => 'বাংলা';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsBanglaDigits => 'Bangla digits';

  @override
  String get settingsAppLock => 'App lock';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonClose => 'Close';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonSearch => 'Search';

  @override
  String get onboardTitle => 'MessBook';

  @override
  String get onboardPage1Body =>
      'Track meals, bills and balances for your mess — all in one app, no internet needed.';

  @override
  String get onboardPage2Title => 'Fully offline';

  @override
  String get onboardPage2Body =>
      'No account, no login required. Your data lives only on this phone.';

  @override
  String get onboardPage3Title => 'Back up what matters';

  @override
  String get onboardPage3Body =>
      'Export a backup file anytime, or turn on automatic Google Drive backup with Premium.';

  @override
  String get onboardGetStarted => 'Get started';

  @override
  String get onboardLanguageEnglish => 'English';

  @override
  String get onboardLanguageBangla => 'বাংলা';

  @override
  String get onboardRoleTitle => 'How will you use MessBook?';

  @override
  String get onboardRoleAdminTitle => 'I manage a mess';

  @override
  String get onboardRoleAdminSub =>
      'Set up your mess, add members and start tracking';

  @override
  String get onboardRoleMemberTitle => 'I\'m joining a mess';

  @override
  String get onboardRoleMemberSub =>
      'Sign in and enter the invite code your manager shared';

  @override
  String get onboardRestoreLink => 'Already have a mess? Sign in to restore it';

  @override
  String get onboardRestoreNoMessFound =>
      'No mess found for this Google account yet.';

  @override
  String get drawerSectionDaily => 'Daily';

  @override
  String get drawerSectionMoney => 'Money';

  @override
  String get drawerSectionPeople => 'People';

  @override
  String get drawerSectionInsights => 'Insights';

  @override
  String get drawerSectionSystem => 'App & data';

  @override
  String get drawerSwitchMess => 'Switch mess';

  @override
  String get wizardStepName => 'Group name';

  @override
  String get wizardStepNameHint => 'e.g. Green House Mess';

  @override
  String get wizardManagerName => 'Your name (mess manager)';

  @override
  String get wizardManagerNameSub =>
      'You\'ll be added as the manager of this mess';

  @override
  String get wizardManagerNameHint => 'e.g. Rakib';

  @override
  String get wizardStepType => 'Type';

  @override
  String get wizardTypeMess => 'Mess';

  @override
  String get wizardTypeFlat => 'Flat';

  @override
  String get wizardTypeTrip => 'Trip';

  @override
  String get wizardTypeOther => 'Other';

  @override
  String get wizardMonthStartsOn => 'Month starts on';

  @override
  String get wizardMealTracking => 'Meal tracking';

  @override
  String get wizardMealTrackingSub =>
      'Meal grid, meal rate & meal-based splits';

  @override
  String get wizardStepMembers => 'Add members';

  @override
  String get wizardStepMembersSub =>
      'Add roommates from your contacts, or type names manually';

  @override
  String get wizardAddFromContacts => 'Add from contacts';

  @override
  String get wizardAddManually => 'Manually';

  @override
  String get wizardFinish => 'Create group';

  @override
  String get wizardMemberNameHint => 'Member name';

  @override
  String get wizardPhoneHint => 'Phone (optional)';

  @override
  String get groupsTitle => 'My groups';

  @override
  String get groupsEmpty => 'No groups yet';

  @override
  String get groupsNewGroup => 'New group';

  @override
  String get groupsFreeLimitNote =>
      'Free plan includes 1 active group. Unlock Premium for unlimited groups & full history.';

  @override
  String groupsMembersCount(int count) {
    return '$count members';
  }

  @override
  String get membersTitle => 'Members';

  @override
  String membersActiveCount(int count) {
    return '$count active';
  }

  @override
  String get membersEmpty => 'No members yet';

  @override
  String membersJoined(String date) {
    return 'joined $date';
  }

  @override
  String membersLeft(String date) {
    return 'left $date';
  }

  @override
  String get membersDeactivate => 'Deactivate';

  @override
  String get membersReactivate => 'Reactivate';

  @override
  String get membersDelete => 'Delete member';

  @override
  String get membersDeleteConfirmTitle => 'Delete this member?';

  @override
  String membersDeleteConfirmBody(String name) {
    return '$name will be permanently removed from this mess. This can\'t be undone.';
  }

  @override
  String get membersDeleteBlockedTitle => 'Can\'t delete this member';

  @override
  String get membersDeleteBlockedBody =>
      'This member already has meals, expenses, deposits, settlements, or polls linked to them. Deactivate them instead — deleting would break those records.';

  @override
  String membersDeleted(String name) {
    return '$name deleted';
  }

  @override
  String get membersManagerBadge => 'MANAGER';

  @override
  String get membersLeftBadge => 'LEFT';

  @override
  String get membersSubAdminBadge => 'SUB-ADMIN';

  @override
  String get membersRolesHint =>
      'Every member here currently has full access. Tap to open Roles & permissions and choose what each member can do.';

  @override
  String get membersAssignRole => 'Assign role';

  @override
  String membersRoleSheetTitle(String name) {
    return '$name\'s role';
  }

  @override
  String get membersRoleAppAdmin => 'App Admin';

  @override
  String get membersRoleAppAdminSub =>
      'Full control of this mess — every permission';

  @override
  String get membersRoleSubAdmin => 'Sub-admin';

  @override
  String get membersRoleSubAdminSub => 'Pick what they can manage below';

  @override
  String get membersRoleMember => 'Member';

  @override
  String get membersRoleMemberSub =>
      'Can only see their own meals, expenses and dues';

  @override
  String get membersCustomPermissions => 'Permissions';

  @override
  String get presetMealAdmin => 'Meal Admin';

  @override
  String get presetExpenseAdmin => 'Expense Admin';

  @override
  String get presetPollCreator => 'Poll Creator';

  @override
  String get presetMemberAdmin => 'Member Admin';

  @override
  String get permissionMealsManage => 'Manage meals';

  @override
  String get permissionPollsCreate => 'Create polls';

  @override
  String get permissionPollsManage => 'Manage polls';

  @override
  String get permissionExpensesManage => 'Manage expenses';

  @override
  String get permissionMoneyManage => 'Manage deposits & settlements';

  @override
  String get permissionMembersManage => 'Manage members';

  @override
  String get settingsMessSection => 'Mess';

  @override
  String get settingsEditMess => 'Edit mess details';

  @override
  String get settingsLanguageAppearanceSection => 'Language & appearance';

  @override
  String get rolesIntroBody =>
      'Right now every member has full access. Tap a member below to make them a sub-admin with only the permissions you choose, or keep them view-only.';

  @override
  String get rolesFullAccess => 'Full access';

  @override
  String get rolesViewOnly => 'View only';

  @override
  String get rolesTransferSection => 'Ownership';

  @override
  String get rolesTransferTitle => 'Transfer manager role';

  @override
  String get rolesTransferSub => 'Hand over App Admin to another member';

  @override
  String get rolesTransferPick => 'Choose the new manager';

  @override
  String get rolesTransferConfirmTitle => 'Transfer manager role?';

  @override
  String rolesTransferConfirmBody(String name) {
    return '$name will become the mess manager and you\'ll become a regular member. You won\'t be able to undo this yourself.';
  }

  @override
  String get rolesTransferConfirmButton => 'Transfer';

  @override
  String get rolesTransferNotJoined =>
      'That member must sign in and join the mess online before they can become manager.';

  @override
  String rolesTransferDone(String name) {
    return '$name is now the mess manager';
  }

  @override
  String get settingsRolesSection => 'Roles & permissions';

  @override
  String get settingsRolesManage => 'Manage roles';

  @override
  String get settingsRolesNotConfiguredSub =>
      'Every member currently has full access — tap to assign sub-admin roles and restrict what they can do.';

  @override
  String get settingsRolesConfiguredSub =>
      'Assign sub-admin roles and fine-tune permissions per member';

  @override
  String get settingsActingAsSection => 'Preview as';

  @override
  String get settingsActingAs => 'Acting as';

  @override
  String get settingsActingAsSub => 'See the app as this member sees it';

  @override
  String get settingsActingAsNone => 'App Admin (default)';

  @override
  String get contactsPickerTitle => 'Pick from contacts';

  @override
  String contactsSelected(int count) {
    return '$count selected';
  }

  @override
  String contactsAddSelected(int count) {
    return 'Add $count members';
  }

  @override
  String get contactsPermissionDenied => 'Contacts permission denied';

  @override
  String get contactsPermissionPermanentlyDenied =>
      'Contacts permission is blocked. Enable it from app settings.';

  @override
  String get contactsOpenSettings => 'Open settings';

  @override
  String get contactsSearchHint => 'Search contacts…';

  @override
  String get contactsEmpty => 'No contacts found';

  @override
  String get groupNameRequired => 'Group name is required';

  @override
  String get memberNameRequired => 'Member name is required';

  @override
  String get expensesTitle => 'Expenses';

  @override
  String get expensesEmpty => 'No expenses yet';

  @override
  String get expensesToday => 'Today';

  @override
  String get expensesDeleteConfirm => 'Delete this expense?';

  @override
  String get expensesPaid => 'paid';

  @override
  String expensesPayersCount(int count) {
    return '$count payers';
  }

  @override
  String get expensesFilterAll => 'All';

  @override
  String get expensesAddTitle => 'Add expense';

  @override
  String get expensesAmountPaid => 'Amount paid';

  @override
  String get expensesPaidBy => 'Paid by';

  @override
  String get expensesAddPayer => 'Add payer';

  @override
  String get expensesNoteHint => 'Note (optional)';

  @override
  String get expensesSave => 'Save expense';

  @override
  String get expensesSplitConfigure => 'Split equally · tap to configure';

  @override
  String expensesSplitMembersEach(int count, String each) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '$count member',
    );
    return '$_temp0 · ৳$each each';
  }

  @override
  String expensesSplitMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '$count member',
    );
    return '$_temp0';
  }

  @override
  String get splitTabEqual => 'Equal';

  @override
  String get splitTabUnequal => 'Unequal';

  @override
  String get splitTabShares => 'Shares';

  @override
  String get splitTabPercent => 'Percent';

  @override
  String splitTitle(String amount) {
    return 'Split ৳$amount';
  }

  @override
  String get splitEqually => 'Split equally';

  @override
  String get splitUnequally => 'Split unequally';

  @override
  String get splitByShares => 'Split by shares';

  @override
  String get splitByPercent => 'Split by percent';

  @override
  String get splitByMeals => 'Split by meals';

  @override
  String splitAssigned(String sum, String total) {
    return '৳$sum of ৳$total assigned';
  }

  @override
  String get dashboardTotalSpent => 'Total spent';

  @override
  String get dashboardMonthOverview => 'This month';

  @override
  String get dashboardMyAccount => 'My account';

  @override
  String get dashboardMyMeals => 'My meals';

  @override
  String get dashboardMyMealBill => 'Meal bill';

  @override
  String get dashboardMyDeposit => 'My deposit';

  @override
  String get dashboardMyBalance => 'Balance';

  @override
  String get dashboardNextBazar => 'Next bazar duty';

  @override
  String get bazarTitle => 'Bazar roster';

  @override
  String get bazarEmpty => 'No bazar duties yet';

  @override
  String get bazarEmptySub => 'Add who\'s doing the grocery shopping and when';

  @override
  String get bazarAdd => 'Add duty';

  @override
  String get bazarWhose => 'Who\'s doing bazar?';

  @override
  String get bazarNoteLabel => 'Note (optional)';

  @override
  String get bazarNoteHint => 'e.g. weekly vegetables';

  @override
  String get dashboardQuickAddExpense => 'Add expense';

  @override
  String get dashboardQuickSettleUp => 'Settle up';

  @override
  String get dashboardQuickMembers => 'Members';

  @override
  String get dashboardRecentExpenses => 'Recent expenses';

  @override
  String get dashboardSeeAll => 'See all';

  @override
  String get dashboardNoExpenses => 'No expenses yet';

  @override
  String get dashboardBalanceOwed => 'you\'re owed';

  @override
  String get dashboardBalanceOwe => 'you owe';

  @override
  String get dashboardBalanceSettled => 'settled';

  @override
  String get depositsTitle => 'Deposits';

  @override
  String get depositsCollected => 'Collected';

  @override
  String get depositsSpent => 'Spent';

  @override
  String get depositsInHand => 'In hand';

  @override
  String get depositsEmpty => 'No deposits yet';

  @override
  String get depositsAdd => 'Add deposit';

  @override
  String get depositsAmountHint => 'Amount';

  @override
  String get depositsMemberHint => 'Member';

  @override
  String get depositsNoteHint => 'Note (optional)';

  @override
  String get settleUpTitle => 'Settle up';

  @override
  String settleUpAutoNote(int count) {
    return '$count payments settle the whole group (instead of manual member-to-member debts).';
  }

  @override
  String get settleUpAllSettled => 'Everyone is settled up';

  @override
  String get settleUpRecord => 'Record';

  @override
  String get settleUpRecorded => 'Recorded';

  @override
  String get settleUpNone => 'No settlements recorded yet';

  @override
  String get settleUpConfirmTitle => 'Record payment';

  @override
  String get settleUpAmountHint => 'Amount';

  @override
  String get settleUpMethodHint => 'Method (optional, e.g. cash, bKash)';

  @override
  String get settleUpBalanceCheck => 'Group balance check';

  @override
  String settleUpFullAmountRemaining(String amount) {
    return 'Full remaining: ৳$amount';
  }

  @override
  String get mealsGridTitle => 'Meals';

  @override
  String get mealsNoMembersYetSub =>
      'Add members before you can start tracking meals';

  @override
  String get mealsSameAsYesterday => 'Same as yesterday';

  @override
  String get mealsBulkFill => 'Bulk fill';

  @override
  String get mealsTotalMeals => 'Total meals';

  @override
  String get mealsRateLive => 'Meal rate · LIVE';

  @override
  String get mealsSetTitle => 'Set meals';

  @override
  String get mealsCountLabel => 'Meals';

  @override
  String get mealsGuestLabel => 'Guest meals';

  @override
  String get mealsBulkFillTitle => 'Bulk fill this day';

  @override
  String get mealsBulkFillHint => 'Set this meal count for every member';

  @override
  String get mealsMemberDetail => 'meals';

  @override
  String get mealsMemberTotalMeals => 'Meals';

  @override
  String get mealsMemberGuest => 'Guest';

  @override
  String get mealsMemberBill => 'Meal bill';

  @override
  String get mealsDailyEntries => 'Daily entries';

  @override
  String reportTitle(String month) {
    return '$month report';
  }

  @override
  String get reportTotalSpent => 'Total spent';

  @override
  String get reportTotalMeals => 'Total meals';

  @override
  String get reportMealRate => 'Meal rate';

  @override
  String get reportShareImage => 'Share image';

  @override
  String get reportPdf => 'PDF';

  @override
  String get reportCsv => 'CSV';

  @override
  String get reportCloseMonth => 'Close month';

  @override
  String reportCloseConfirmTitle(String month) {
    return 'Close $month?';
  }

  @override
  String get reportCloseConfirmBody =>
      'This locks all records for this month. You can still view everything, but nothing can be edited after closing.';

  @override
  String get reportCloseSnapshotSaved => 'Snapshot saved';

  @override
  String get reportCloseSnapshotSub => 'Report frozen exactly as it is now';

  @override
  String get reportCloseCarryForward => 'Balances carry forward';

  @override
  String get reportCloseCarryForwardSub =>
      'Unsettled dues open next month automatically';

  @override
  String get reportLockedBanner => 'This month is closed and locked';

  @override
  String get reportMonthClosed => 'Month closed';

  @override
  String get reportStartNewMonth => 'Start new month';

  @override
  String get monthClosedCannotEdit =>
      'This month is closed. Reopen it or pick a different date to edit.';

  @override
  String get reportColMember => 'Member';

  @override
  String get reportColMeals => 'Meals';

  @override
  String get reportColMealBill => 'Meal bill';

  @override
  String get reportColShared => 'Shared';

  @override
  String get reportColPaid => 'Paid+Dep';

  @override
  String get reportColDue => 'Due';

  @override
  String get reportTotalRow => 'Total';

  @override
  String get reportShareChooserTitle => 'Share month report';

  @override
  String get backupTitle => 'Backup & restore';

  @override
  String get backupExport => 'Export file';

  @override
  String get backupImport => 'Import';

  @override
  String get backupNeverBackedUp => 'Never backed up';

  @override
  String backupBackedUpOn(String date) {
    return 'Backed up $date';
  }

  @override
  String get backupOverdueTitle => 'Backup overdue';

  @override
  String get backupOverdueBody => 'Export a backup file to stay safe.';

  @override
  String get backupOverdueAction => 'Back up';

  @override
  String get backupImportPreviewTitle => 'Import preview';

  @override
  String get backupImportWarning =>
      'Importing replaces all current data. Export a backup first.';

  @override
  String get backupImportConfirm => 'Replace all data';

  @override
  String get backupImportSuccess => 'Data restored successfully';

  @override
  String get backupInvalidTitle => 'Couldn\'t import this file';

  @override
  String backupChecksumValid(int version) {
    return 'Checksum valid · schema v$version';
  }

  @override
  String backupExportedOn(String date) {
    return 'Exported $date';
  }

  @override
  String get lockEnterPin => 'Enter your PIN';

  @override
  String get lockSetPin => 'Set a PIN';

  @override
  String get lockConfirmPin => 'Confirm your PIN';

  @override
  String get lockPinMismatch => 'PINs didn\'t match. Try again.';

  @override
  String get lockWrongPin => 'Wrong PIN';

  @override
  String get lockUseBiometric => 'Use biometrics instead';

  @override
  String get lockUnlock => 'Unlock';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPremiumBanner => 'Unlock Premium';

  @override
  String get settingsPremiumBannerSub =>
      'Unlimited groups · PDF · charts · Drive backup';

  @override
  String get settingsLanguageSection => 'Language & format';

  @override
  String get settingsAppearanceSection => 'Appearance & security';

  @override
  String get settingsRemindersSection => 'Reminders';

  @override
  String get settingsDataSection => 'Data';

  @override
  String get helpTitle => 'Help & FAQ';

  @override
  String get helpQCreateMess => 'How do I create a mess?';

  @override
  String get helpACreateMess =>
      'On first launch, choose \"I manage a mess,\" then follow the wizard: name your mess, add members from your contacts or manually, and choose whether meal costs and other bills are tracked together or separately.';

  @override
  String get helpQAddMembers => 'How do I add or remove members later?';

  @override
  String get helpAAddMembers =>
      'Open Members from the drawer. Tap \"Add from contacts\" or \"Add manually\" to add someone. To remove someone, use the ⋮ menu on their row — Deactivate keeps their history, Delete member only works if they have no meals, expenses, or payments recorded yet.';

  @override
  String get helpQRoles => 'What do roles and permissions mean?';

  @override
  String get helpARoles =>
      'The App Admin (the mess creator) always has full access. Every other member can be a Sub-Admin with only the permissions you choose (e.g. managing meals but not money), or a plain Member who can view everything but not edit. Set this up from Roles & permissions.';

  @override
  String get helpQJoin => 'How does a member join from their own phone?';

  @override
  String get helpAJoin =>
      'First bring your mess online (Settings → Mess → Online) to get an invite code. Share that code with the member. They open MessBook, choose \"I\'m joining a mess,\" sign in with Google, and enter the code — then either claim their existing name or add themselves as new.';

  @override
  String get helpQMeals => 'How do I track meals?';

  @override
  String get helpAMeals =>
      'Open Meals from the drawer to log each member\'s meals per day, including half meals and guest meals. You can also set up a weekly routine per member so their usual meals fill in automatically.';

  @override
  String get helpQMealRate => 'How is the meal rate calculated?';

  @override
  String get helpAMealRate =>
      'The meal rate is the total meal spending for the month divided by the total number of meals everyone ate. Each member\'s meal bill is their own meal count multiplied by that rate.';

  @override
  String get helpQPolls => 'What are meal polls for?';

  @override
  String get helpAPolls =>
      'Polls let members vote on which meals they\'ll take for a given day, instead of the manager guessing or asking everyone individually. Anyone with poll-creation permission can start one; every member can vote regardless of role.';

  @override
  String get helpQSettleUp => 'How does Settle Up work?';

  @override
  String get helpASettleUp =>
      'Settle Up looks at everyone\'s balance and suggests the fewest possible payments to bring every balance to zero, instead of everyone paying everyone else individually.';

  @override
  String get helpQMonthClose => 'What happens when I close a month?';

  @override
  String get helpAMonthClose =>
      'Closing a month locks its meals, expenses, and deposits so they can no longer be edited, and starts a fresh month. You can choose to carry forward each member\'s balance as an opening entry in the new month.';

  @override
  String get helpQBackup => 'How do I back up my data?';

  @override
  String get helpABackup =>
      'Go to Backup & restore from the drawer to export a backup file anytime, or import one to restore. This works fully offline and doesn\'t require an account.';

  @override
  String get helpQOnline => 'Do I need the internet to use MessBook?';

  @override
  String get helpAOnline =>
      'No — MessBook works fully offline on a single phone. Bringing a mess online (and signing in with Google) is only needed if you want other members to join from their own phones and see live updates.';

  @override
  String get settingsFollowSystem => 'Follow system';

  @override
  String get settingsPinBiometric => 'PIN + biometric';

  @override
  String get settingsDailyMealReminder => 'Daily meal reminder';

  @override
  String get settingsEveryNight => 'Every night';

  @override
  String get settingsMonthCloseReminder => 'Month-close reminder';

  @override
  String get settingsLastDayOfMonth => 'Last day of month window';

  @override
  String get settingsBackupRestore => 'Backup & restore';

  @override
  String get settingsResetData => 'Reset all data';

  @override
  String get settingsResetDataSub => 'Requires typing RESET';

  @override
  String get settingsResetConfirmHint => 'Type RESET to confirm';

  @override
  String get settingsResetTypeHere => 'Type here';

  @override
  String get chartsTitle => 'Insights';

  @override
  String chartsWhereWentTitle(String month) {
    return 'Where $month went';
  }

  @override
  String get chartsTotal => 'TOTAL';

  @override
  String get chartsTrendTitle => 'Monthly spend trend';

  @override
  String chartsTrendMonths(int count) {
    return '$count months';
  }

  @override
  String get chartsNoData => 'No spending data yet';

  @override
  String get recurringTitle => 'Recurring expenses';

  @override
  String get recurringAdd => 'Add recurring';

  @override
  String get recurringEmpty => 'No recurring expenses set up';

  @override
  String recurringDayOfMonth(int day) {
    return 'Day $day of each month';
  }

  @override
  String get recurringActive => 'Active';

  @override
  String get recurringPaused => 'Paused';

  @override
  String get recurringAddIsPremium =>
      'Recurring expenses are a Premium feature';

  @override
  String get paywallTitle => 'MessBook Premium';

  @override
  String get paywallSubtitle => 'Pay once. Yours forever. No subscription.';

  @override
  String get paywallFeatureGroups => 'Unlimited groups';

  @override
  String get paywallFeatureHistory => 'Full history — every past month';

  @override
  String get paywallFeatureExport => 'PDF & CSV export';

  @override
  String get paywallFeatureCharts => 'Charts & insights';

  @override
  String get paywallFeatureDrive => 'Google Drive auto-backup';

  @override
  String get paywallFeatureRecurring => 'Recurring expenses & receipt photos';

  @override
  String paywallUnlockButton(String price) {
    return 'Unlock everything · $price';
  }

  @override
  String get paywallDefaultPrice => '৳499';

  @override
  String get paywallOneTimeNote => 'One-time payment via Google Play';

  @override
  String get paywallRestorePurchase => 'Restore purchase';

  @override
  String get paywallAlreadyUnlocked => 'Premium already unlocked';

  @override
  String get paywallPurchaseError => 'Purchase failed. Please try again.';

  @override
  String get paywallRestoreNone =>
      'No previous purchase found for this account';

  @override
  String get paywallStoreUnavailable =>
      'Play Store billing isn\'t available on this device';

  @override
  String get chartsPremiumTitle => 'Charts are a Premium feature';

  @override
  String get chartsPremiumBody =>
      'Unlock Premium to see category breakdowns and spending trends.';

  @override
  String get chartsUnlockButton => 'Unlock Premium';

  @override
  String get groupsUpgradeRequired => 'Free plan includes 1 active group';

  @override
  String get reportHistoryLocked =>
      'Free plan shows the current and previous month. Unlock Premium for full history.';

  @override
  String get reportExportIsPremium => 'PDF & CSV export are Premium features';

  @override
  String get backupDriveSection => 'Google Drive auto-backup';

  @override
  String get backupDriveToggleTitle => 'Daily auto-backup';

  @override
  String get backupDriveToggleSub =>
      'Uploads an encrypted-in-transit copy to your Google Drive appdata folder every day';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get backupDriveSignInFailed => 'Couldn\'t sign in to Google Drive';

  @override
  String get backupDrivePremiumNote =>
      'Google Drive auto-backup is a Premium feature — manual file export/import is always free';

  @override
  String get expensesReceiptPhoto => 'Receipt photo';

  @override
  String get expensesAddReceiptPhoto => 'Add receipt photo';

  @override
  String get expensesRemoveReceiptPhoto => 'Remove photo';

  @override
  String get expensesReceiptIsPremium => 'Receipt photos are a Premium feature';

  @override
  String get commonProBadge => 'PRO';

  @override
  String commonErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsDailyMealReminderTime => '10:00 PM';

  @override
  String get recurringAmountLabel => 'Amount';

  @override
  String get groupsMealsOn => 'meals on';

  @override
  String mealsGuestCount(String count) {
    return '+$count guest';
  }

  @override
  String backupPreviewGroups(String count) {
    return '$count groups';
  }

  @override
  String backupPreviewMembers(String count) {
    return '$count members';
  }

  @override
  String backupPreviewExpenses(String count) {
    return '$count expenses';
  }

  @override
  String backupPreviewMeals(String count) {
    return '$count meals';
  }

  @override
  String backupPreviewDeposits(String count) {
    return '$count deposits';
  }

  @override
  String get splitNoMealDataForMonth => 'No meal data for this month';

  @override
  String get splitNoMealsForSelectedMembers =>
      'No meals recorded for the selected members';

  @override
  String get notifyMealReminderTitle => 'Log today\'s meals';

  @override
  String get notifyMealReminderBody =>
      'Update today\'s meal count before it slips your mind.';

  @override
  String get notifyMonthCloseTitle => 'Month closing soon';

  @override
  String get notifyMonthCloseBody =>
      'Review this month\'s expenses and close it out.';

  @override
  String get notifyBackupOverdueTitle => 'Backup reminder';

  @override
  String get notifyBackupOverdueBody =>
      'It\'s been a while since your last backup. Export one from Settings.';

  @override
  String get ledgerMealTab => 'Meals';

  @override
  String get ledgerGeneralTab => 'Rent & others';

  @override
  String get groupMealLedgerSeparate => 'Separate meal money';

  @override
  String get groupMealLedgerSeparateSub =>
      'Meal costs get their own balance, settle-up and month close — kept apart from rent & other shared costs';

  @override
  String get groupLowBalanceThreshold => 'Low balance warning';

  @override
  String get groupLowBalanceThresholdSub =>
      'Warn when a member\'s remaining balance falls below this amount (0 = off)';

  @override
  String get groupAutoMealOff => 'Stop meals when balance is low';

  @override
  String get groupAutoMealOffSub =>
      'Members below the warning amount stop getting meals added automatically until they top up';

  @override
  String get mealBalanceDeposited => 'Deposited';

  @override
  String get mealBalanceSpent => 'Meal cost';

  @override
  String get mealBalanceRemaining => 'Remaining';

  @override
  String get mealBalanceLow => 'Low balance';

  @override
  String get notifyLowBalanceTitle => 'Low mess balance';

  @override
  String get notifyLowBalanceOwnBody =>
      'Your balance is running low — please top up.';

  @override
  String notifyLowBalanceAdminBody(String name) {
    return '$name\'s balance is below the warning amount.';
  }

  @override
  String get groupPollReminder => 'Poll reminder';

  @override
  String get groupPollReminderSub =>
      'How long before a poll closes every member is reminded to vote';

  @override
  String get pollReminderOff => 'Off';

  @override
  String pollReminderBefore(String minutes) {
    return '$minutes min before';
  }

  @override
  String get depositsPurposeQuestion => 'Which balance is this for?';

  @override
  String get pollNonVoterPolicyLabel => 'If someone doesn\'t vote';

  @override
  String get nonVoterPolicyRoutine => 'Use their routine';

  @override
  String get nonVoterPolicyPending => 'Leave pending for Meal Admin';

  @override
  String get nonVoterPolicyZero => 'Count as no meal';

  @override
  String get nonVoterPolicyRepeatYesterday => 'Repeat yesterday';

  @override
  String get mealSlotsTitle => 'Meal Slots';

  @override
  String get mealSlotsSub =>
      'Customize Breakfast, Lunch, Dinner and what each counts as';

  @override
  String get mealSlotAdd => 'Add slot';

  @override
  String get mealSlotName => 'Slot name';

  @override
  String get mealSlotWeight => 'Counts as (meals)';

  @override
  String get mealSlotWeightHint => 'e.g. 0.5 for half a meal';

  @override
  String get mealSlotBreakfast => 'Breakfast';

  @override
  String get mealSlotLunch => 'Lunch';

  @override
  String get mealSlotDinner => 'Dinner';

  @override
  String get mealSlotDeactivate => 'Deactivate';

  @override
  String get mealSlotReactivate => 'Reactivate';

  @override
  String get mealSlotEmpty => 'No meal slots yet';

  @override
  String get membersMealRoutine => 'Meal routine';

  @override
  String routineTitle(String name) {
    return '$name\'s meal routine';
  }

  @override
  String get routineSub =>
      'Auto-fills the meal grid every day from this routine';

  @override
  String get routineDaily => 'Every day';

  @override
  String get routineCustomizeDay => 'Customize a specific day';

  @override
  String get routineWeekdayMon => 'Mon';

  @override
  String get routineWeekdayTue => 'Tue';

  @override
  String get routineWeekdayWed => 'Wed';

  @override
  String get routineWeekdayThu => 'Thu';

  @override
  String get routineWeekdayFri => 'Fri';

  @override
  String get routineWeekdaySat => 'Sat';

  @override
  String get routineWeekdaySun => 'Sun';

  @override
  String get routineLeaveTitle => 'Meal leave';

  @override
  String get routineLeaveAdd => 'Add leave dates';

  @override
  String get routineLeaveFrom => 'From';

  @override
  String get routineLeaveTo => 'To';

  @override
  String get routineLeaveNote => 'Reason (optional)';

  @override
  String get routineLeaveEmpty => 'No leave scheduled';

  @override
  String get pollsTitle => 'Polls';

  @override
  String get pollsEmpty => 'No polls yet';

  @override
  String get pollCreate => 'Create poll';

  @override
  String get pollTypeSlots => 'Meal slots';

  @override
  String get pollTypeCount => 'Meal count';

  @override
  String get pollTypeMenu => 'Menu choice';

  @override
  String get pollQuestionHint => 'Question (e.g. Tomorrow\'s dinner?)';

  @override
  String get pollOptionsHint => 'Options, one per line';

  @override
  String get pollCloseAt => 'Closes at';

  @override
  String get pollForDateLabel => 'For date';

  @override
  String get mealsTodayTitle => 'Today\'s meals';

  @override
  String mealsTodaySummary(String total, String eaters) {
    return '$total total · $eaters eating';
  }

  @override
  String mealsTodayGuests(String guests) {
    return 'incl. $guests guest';
  }

  @override
  String get pollNonVoterOverride => 'Non-voter rule for this poll';

  @override
  String get pollNonVoterUseDefault => 'Use mess default';

  @override
  String pollForDate(String date) {
    return 'For $date';
  }

  @override
  String get pollVoteNow => 'Vote now';

  @override
  String get pollVoteSlotsQuestion => 'Which meals will you take?';

  @override
  String get pollVoteCountQuestion => 'How many meals?';

  @override
  String get pollVoteMenuQuestion => 'Pick one';

  @override
  String get pollVoteSubmit => 'Submit vote';

  @override
  String get pollVoted => 'Voted';

  @override
  String get pollClosed => 'Closed';

  @override
  String get pollOpen => 'Open';

  @override
  String get pollReopen => 'Reopen voting';

  @override
  String get pollReopenHint =>
      'Give members more time to vote. The poll reopens and closes again at the new time, re-applying results (manual meal edits are kept).';

  @override
  String get pollReopenAction => 'Reopen & extend';

  @override
  String get pollDelete => 'Delete poll';

  @override
  String get pollDeleteConfirm =>
      'Delete this poll and all its votes? This can\'t be undone. Meals already recorded from it stay in the sheet.';

  @override
  String get pollCloseNow => 'Close now & apply';

  @override
  String get pollClosedApplied =>
      'Poll closed — results applied to the meal sheet.';

  @override
  String pollVotedCount(String voted, String total) {
    return '$voted/$total voted';
  }

  @override
  String get pollResultsTitle => 'Results';

  @override
  String get pollPendingTitle => 'Still need to set';

  @override
  String get pollPendingEmpty => 'Nothing pending';

  @override
  String get pollResolveSet => 'Set';

  @override
  String pollCreatedBy(String name) {
    return 'Created by $name';
  }

  @override
  String get dashboardTodaysPoll => 'Today\'s Poll';

  @override
  String get notifyPollReminderTitle => 'Poll closing soon';

  @override
  String get notifyPollReminderBody =>
      'Vote in today\'s meal poll before it closes.';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountNotSignedIn => 'Not signed in';

  @override
  String get accountSignInSubtitle =>
      'Sign in with Google to bring a mess online or join one on another device';

  @override
  String get accountSignInButton => 'Sign in with Google';

  @override
  String get accountSignInFailed => 'Sign-in failed. Please try again.';

  @override
  String accountSignedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get accountSignOut => 'Sign out';

  @override
  String get accountServerSection => 'Server';

  @override
  String get accountServerUrlLabel => 'API server URL';

  @override
  String get accountServerUrlHint => 'https://api.yourdomain.com';

  @override
  String get accountServerUrlSaved => 'Server URL saved';

  @override
  String get onlineSectionTitle => 'Online & sync';

  @override
  String get onlineBringOnlineTitle => 'Bring this mess online';

  @override
  String get onlineBringOnlineSub =>
      'Get an invite code so other members can join from their phones';

  @override
  String get onlineBringOnlineButton => 'Bring online';

  @override
  String get onlineSignInRequired => 'Sign in first to bring this mess online';

  @override
  String get onlineAlreadyOnline => 'This mess is online';

  @override
  String get onlineInviteCodeLabel => 'Invite code';

  @override
  String get onlineShareInvite => 'Share invite code';

  @override
  String get onlineBringOnlineError =>
      'Couldn\'t bring this mess online. Please try again.';

  @override
  String get onlineSyncNow => 'Sync now';

  @override
  String get onlineSyncing => 'Syncing…';

  @override
  String get onlineSyncSuccess => 'Synced';

  @override
  String get onlineSyncError => 'Sync failed. Please try again.';

  @override
  String get joinTitle => 'Join a mess';

  @override
  String get joinCodeLabel => 'Invite code';

  @override
  String get joinCodeHint => 'MESS-XXXX';

  @override
  String get joinContinue => 'Continue';

  @override
  String get joinIdentityQuestion => 'Is one of these you?';

  @override
  String get joinImNew => 'I\'m new — add me';

  @override
  String get joinChangeCode => 'Change code';

  @override
  String get joinYourNameLabel => 'Your name';

  @override
  String get joinYourNameHint => 'e.g. Rahim';

  @override
  String get joinButton => 'Join';

  @override
  String get joinSignInRequired => 'Sign in first to join a mess';

  @override
  String get joinLookupError =>
      'Couldn\'t find that mess. Please check the code and try again.';

  @override
  String get joinError =>
      'Couldn\'t join. Please check the code and try again.';

  @override
  String joinSuccess(String name) {
    return 'Joined $name';
  }

  @override
  String get chatTitle => 'Mess Chat';

  @override
  String get chatEmpty => 'No messages yet. Say hello!';

  @override
  String get chatMessageHint => 'Type a message';

  @override
  String get chatConnectError =>
      'Couldn\'t connect to chat. Check your connection and reopen this screen.';

  @override
  String get chatSendError => 'Message didn\'t send. Please try again.';

  @override
  String get chatUnknownSender => 'Unknown';
}
