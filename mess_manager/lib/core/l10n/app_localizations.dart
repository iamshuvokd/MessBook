import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// Application name shown in title bars and launcher
  ///
  /// In en, this message translates to:
  /// **'MessBook'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get navExpenses;

  /// No description provided for @navMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get navMeals;

  /// No description provided for @navReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get navReport;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @debugScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Debug · Seed data'**
  String get debugScreenTitle;

  /// No description provided for @debugGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get debugGroups;

  /// No description provided for @debugMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get debugMembers;

  /// No description provided for @debugCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get debugCategories;

  /// No description provided for @debugNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get debugNoData;

  /// No description provided for @categoryBazar.
  ///
  /// In en, this message translates to:
  /// **'Bazar/Grocery'**
  String get categoryBazar;

  /// No description provided for @categoryRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get categoryRent;

  /// No description provided for @categoryUtility.
  ///
  /// In en, this message translates to:
  /// **'Utility'**
  String get categoryUtility;

  /// No description provided for @categoryWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get categoryWifi;

  /// No description provided for @categoryMaid.
  ///
  /// In en, this message translates to:
  /// **'Maid/Cook'**
  String get categoryMaid;

  /// No description provided for @categoryGas.
  ///
  /// In en, this message translates to:
  /// **'Gas Cylinder'**
  String get categoryGas;

  /// No description provided for @categoryRepairs.
  ///
  /// In en, this message translates to:
  /// **'Repairs'**
  String get categoryRepairs;

  /// No description provided for @categoryMisc.
  ///
  /// In en, this message translates to:
  /// **'Misc'**
  String get categoryMisc;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageBangla.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get settingsLanguageBangla;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsBanglaDigits.
  ///
  /// In en, this message translates to:
  /// **'Bangla digits'**
  String get settingsBanglaDigits;

  /// No description provided for @settingsAppLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get settingsAppLock;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @onboardTitle.
  ///
  /// In en, this message translates to:
  /// **'MessBook'**
  String get onboardTitle;

  /// No description provided for @onboardPage1Body.
  ///
  /// In en, this message translates to:
  /// **'Track meals, bills and balances for your mess — all in one app, no internet needed.'**
  String get onboardPage1Body;

  /// No description provided for @onboardPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Fully offline'**
  String get onboardPage2Title;

  /// No description provided for @onboardPage2Body.
  ///
  /// In en, this message translates to:
  /// **'No account, no login required. Your data lives only on this phone.'**
  String get onboardPage2Body;

  /// No description provided for @onboardPage3Title.
  ///
  /// In en, this message translates to:
  /// **'Back up what matters'**
  String get onboardPage3Title;

  /// No description provided for @onboardPage3Body.
  ///
  /// In en, this message translates to:
  /// **'Export a backup file anytime, or turn on automatic Google Drive backup with Premium.'**
  String get onboardPage3Body;

  /// No description provided for @onboardGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardGetStarted;

  /// No description provided for @onboardLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get onboardLanguageEnglish;

  /// No description provided for @onboardLanguageBangla.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get onboardLanguageBangla;

  /// No description provided for @onboardRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'How will you use MessBook?'**
  String get onboardRoleTitle;

  /// No description provided for @onboardRoleAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'I manage a mess'**
  String get onboardRoleAdminTitle;

  /// No description provided for @onboardRoleAdminSub.
  ///
  /// In en, this message translates to:
  /// **'Set up your mess, add members and start tracking'**
  String get onboardRoleAdminSub;

  /// No description provided for @onboardRoleMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m joining a mess'**
  String get onboardRoleMemberTitle;

  /// No description provided for @onboardRoleMemberSub.
  ///
  /// In en, this message translates to:
  /// **'Sign in and enter the invite code your manager shared'**
  String get onboardRoleMemberSub;

  /// No description provided for @onboardRestoreLink.
  ///
  /// In en, this message translates to:
  /// **'Already have a mess? Sign in to restore it'**
  String get onboardRestoreLink;

  /// No description provided for @onboardRestoreNoMessFound.
  ///
  /// In en, this message translates to:
  /// **'No mess found for this Google account yet.'**
  String get onboardRestoreNoMessFound;

  /// No description provided for @drawerSectionDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get drawerSectionDaily;

  /// No description provided for @drawerSectionMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get drawerSectionMoney;

  /// No description provided for @drawerSectionPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get drawerSectionPeople;

  /// No description provided for @drawerSectionInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get drawerSectionInsights;

  /// No description provided for @drawerSectionSystem.
  ///
  /// In en, this message translates to:
  /// **'App & data'**
  String get drawerSectionSystem;

  /// No description provided for @drawerSwitchMess.
  ///
  /// In en, this message translates to:
  /// **'Switch mess'**
  String get drawerSwitchMess;

  /// No description provided for @wizardStepName.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get wizardStepName;

  /// No description provided for @wizardStepNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Green House Mess'**
  String get wizardStepNameHint;

  /// No description provided for @wizardManagerName.
  ///
  /// In en, this message translates to:
  /// **'Your name (mess manager)'**
  String get wizardManagerName;

  /// No description provided for @wizardManagerNameSub.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be added as the manager of this mess'**
  String get wizardManagerNameSub;

  /// No description provided for @wizardManagerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rakib'**
  String get wizardManagerNameHint;

  /// No description provided for @wizardStepType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get wizardStepType;

  /// No description provided for @wizardTypeMess.
  ///
  /// In en, this message translates to:
  /// **'Mess'**
  String get wizardTypeMess;

  /// No description provided for @wizardTypeFlat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get wizardTypeFlat;

  /// No description provided for @wizardTypeTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get wizardTypeTrip;

  /// No description provided for @wizardTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get wizardTypeOther;

  /// No description provided for @wizardMonthStartsOn.
  ///
  /// In en, this message translates to:
  /// **'Month starts on'**
  String get wizardMonthStartsOn;

  /// No description provided for @wizardMealTracking.
  ///
  /// In en, this message translates to:
  /// **'Meal tracking'**
  String get wizardMealTracking;

  /// No description provided for @wizardMealTrackingSub.
  ///
  /// In en, this message translates to:
  /// **'Meal grid, meal rate & meal-based splits'**
  String get wizardMealTrackingSub;

  /// No description provided for @wizardStepMembers.
  ///
  /// In en, this message translates to:
  /// **'Add members'**
  String get wizardStepMembers;

  /// No description provided for @wizardStepMembersSub.
  ///
  /// In en, this message translates to:
  /// **'Add roommates from your contacts, or type names manually'**
  String get wizardStepMembersSub;

  /// No description provided for @wizardAddFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Add from contacts'**
  String get wizardAddFromContacts;

  /// No description provided for @wizardAddManually.
  ///
  /// In en, this message translates to:
  /// **'Manually'**
  String get wizardAddManually;

  /// No description provided for @wizardFinish.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get wizardFinish;

  /// No description provided for @wizardMemberNameHint.
  ///
  /// In en, this message translates to:
  /// **'Member name'**
  String get wizardMemberNameHint;

  /// No description provided for @wizardPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get wizardPhoneHint;

  /// No description provided for @groupsTitle.
  ///
  /// In en, this message translates to:
  /// **'My groups'**
  String get groupsTitle;

  /// No description provided for @groupsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get groupsEmpty;

  /// No description provided for @groupsNewGroup.
  ///
  /// In en, this message translates to:
  /// **'New group'**
  String get groupsNewGroup;

  /// No description provided for @groupsFreeLimitNote.
  ///
  /// In en, this message translates to:
  /// **'Free plan includes 1 active group. Unlock Premium for unlimited groups & full history.'**
  String get groupsFreeLimitNote;

  /// No description provided for @groupsMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String groupsMembersCount(int count);

  /// No description provided for @membersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersTitle;

  /// No description provided for @membersActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String membersActiveCount(int count);

  /// No description provided for @membersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get membersEmpty;

  /// No description provided for @membersJoined.
  ///
  /// In en, this message translates to:
  /// **'joined {date}'**
  String membersJoined(String date);

  /// No description provided for @membersLeft.
  ///
  /// In en, this message translates to:
  /// **'left {date}'**
  String membersLeft(String date);

  /// No description provided for @membersDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get membersDeactivate;

  /// No description provided for @membersReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get membersReactivate;

  /// No description provided for @membersDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete member'**
  String get membersDelete;

  /// No description provided for @membersDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this member?'**
  String get membersDeleteConfirmTitle;

  /// No description provided for @membersDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will be permanently removed from this mess. This can\'t be undone.'**
  String membersDeleteConfirmBody(String name);

  /// No description provided for @membersDeleteBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Can\'t delete this member'**
  String get membersDeleteBlockedTitle;

  /// No description provided for @membersDeleteBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'This member already has meals, expenses, deposits, settlements, or polls linked to them. Deactivate them instead — deleting would break those records.'**
  String get membersDeleteBlockedBody;

  /// No description provided for @membersDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String membersDeleted(String name);

  /// No description provided for @membersManagerBadge.
  ///
  /// In en, this message translates to:
  /// **'MANAGER'**
  String get membersManagerBadge;

  /// No description provided for @membersLeftBadge.
  ///
  /// In en, this message translates to:
  /// **'LEFT'**
  String get membersLeftBadge;

  /// No description provided for @membersSubAdminBadge.
  ///
  /// In en, this message translates to:
  /// **'SUB-ADMIN'**
  String get membersSubAdminBadge;

  /// No description provided for @membersRolesHint.
  ///
  /// In en, this message translates to:
  /// **'Every member here currently has full access. Tap to open Roles & permissions and choose what each member can do.'**
  String get membersRolesHint;

  /// No description provided for @membersAssignRole.
  ///
  /// In en, this message translates to:
  /// **'Assign role'**
  String get membersAssignRole;

  /// No description provided for @membersRoleSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s role'**
  String membersRoleSheetTitle(String name);

  /// No description provided for @membersRoleAppAdmin.
  ///
  /// In en, this message translates to:
  /// **'App Admin'**
  String get membersRoleAppAdmin;

  /// No description provided for @membersRoleAppAdminSub.
  ///
  /// In en, this message translates to:
  /// **'Full control of this mess — every permission'**
  String get membersRoleAppAdminSub;

  /// No description provided for @membersRoleSubAdmin.
  ///
  /// In en, this message translates to:
  /// **'Sub-admin'**
  String get membersRoleSubAdmin;

  /// No description provided for @membersRoleSubAdminSub.
  ///
  /// In en, this message translates to:
  /// **'Pick what they can manage below'**
  String get membersRoleSubAdminSub;

  /// No description provided for @membersRoleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get membersRoleMember;

  /// No description provided for @membersRoleMemberSub.
  ///
  /// In en, this message translates to:
  /// **'Can only see their own meals, expenses and dues'**
  String get membersRoleMemberSub;

  /// No description provided for @membersCustomPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get membersCustomPermissions;

  /// No description provided for @presetMealAdmin.
  ///
  /// In en, this message translates to:
  /// **'Meal Admin'**
  String get presetMealAdmin;

  /// No description provided for @presetExpenseAdmin.
  ///
  /// In en, this message translates to:
  /// **'Expense Admin'**
  String get presetExpenseAdmin;

  /// No description provided for @presetPollCreator.
  ///
  /// In en, this message translates to:
  /// **'Poll Creator'**
  String get presetPollCreator;

  /// No description provided for @presetMemberAdmin.
  ///
  /// In en, this message translates to:
  /// **'Member Admin'**
  String get presetMemberAdmin;

  /// No description provided for @permissionMealsManage.
  ///
  /// In en, this message translates to:
  /// **'Manage meals'**
  String get permissionMealsManage;

  /// No description provided for @permissionPollsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create polls'**
  String get permissionPollsCreate;

  /// No description provided for @permissionPollsManage.
  ///
  /// In en, this message translates to:
  /// **'Manage polls'**
  String get permissionPollsManage;

  /// No description provided for @permissionExpensesManage.
  ///
  /// In en, this message translates to:
  /// **'Manage expenses'**
  String get permissionExpensesManage;

  /// No description provided for @permissionMoneyManage.
  ///
  /// In en, this message translates to:
  /// **'Manage deposits & settlements'**
  String get permissionMoneyManage;

  /// No description provided for @permissionMembersManage.
  ///
  /// In en, this message translates to:
  /// **'Manage members'**
  String get permissionMembersManage;

  /// No description provided for @settingsMessSection.
  ///
  /// In en, this message translates to:
  /// **'Mess'**
  String get settingsMessSection;

  /// No description provided for @settingsEditMess.
  ///
  /// In en, this message translates to:
  /// **'Edit mess details'**
  String get settingsEditMess;

  /// No description provided for @settingsLanguageAppearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Language & appearance'**
  String get settingsLanguageAppearanceSection;

  /// No description provided for @rolesIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Right now every member has full access. Tap a member below to make them a sub-admin with only the permissions you choose, or keep them view-only.'**
  String get rolesIntroBody;

  /// No description provided for @rolesFullAccess.
  ///
  /// In en, this message translates to:
  /// **'Full access'**
  String get rolesFullAccess;

  /// No description provided for @rolesViewOnly.
  ///
  /// In en, this message translates to:
  /// **'View only'**
  String get rolesViewOnly;

  /// No description provided for @rolesTransferSection.
  ///
  /// In en, this message translates to:
  /// **'Ownership'**
  String get rolesTransferSection;

  /// No description provided for @rolesTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer manager role'**
  String get rolesTransferTitle;

  /// No description provided for @rolesTransferSub.
  ///
  /// In en, this message translates to:
  /// **'Hand over App Admin to another member'**
  String get rolesTransferSub;

  /// No description provided for @rolesTransferPick.
  ///
  /// In en, this message translates to:
  /// **'Choose the new manager'**
  String get rolesTransferPick;

  /// No description provided for @rolesTransferConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer manager role?'**
  String get rolesTransferConfirmTitle;

  /// No description provided for @rolesTransferConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will become the mess manager and you\'ll become a regular member. You won\'t be able to undo this yourself.'**
  String rolesTransferConfirmBody(String name);

  /// No description provided for @rolesTransferConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get rolesTransferConfirmButton;

  /// No description provided for @rolesTransferNotJoined.
  ///
  /// In en, this message translates to:
  /// **'That member must sign in and join the mess online before they can become manager.'**
  String get rolesTransferNotJoined;

  /// No description provided for @rolesTransferDone.
  ///
  /// In en, this message translates to:
  /// **'{name} is now the mess manager'**
  String rolesTransferDone(String name);

  /// No description provided for @settingsRolesSection.
  ///
  /// In en, this message translates to:
  /// **'Roles & permissions'**
  String get settingsRolesSection;

  /// No description provided for @settingsRolesManage.
  ///
  /// In en, this message translates to:
  /// **'Manage roles'**
  String get settingsRolesManage;

  /// No description provided for @settingsRolesNotConfiguredSub.
  ///
  /// In en, this message translates to:
  /// **'Every member currently has full access — tap to assign sub-admin roles and restrict what they can do.'**
  String get settingsRolesNotConfiguredSub;

  /// No description provided for @settingsRolesConfiguredSub.
  ///
  /// In en, this message translates to:
  /// **'Assign sub-admin roles and fine-tune permissions per member'**
  String get settingsRolesConfiguredSub;

  /// No description provided for @settingsActingAsSection.
  ///
  /// In en, this message translates to:
  /// **'Preview as'**
  String get settingsActingAsSection;

  /// No description provided for @settingsActingAs.
  ///
  /// In en, this message translates to:
  /// **'Acting as'**
  String get settingsActingAs;

  /// No description provided for @settingsActingAsSub.
  ///
  /// In en, this message translates to:
  /// **'See the app as this member sees it'**
  String get settingsActingAsSub;

  /// No description provided for @settingsActingAsNone.
  ///
  /// In en, this message translates to:
  /// **'App Admin (default)'**
  String get settingsActingAsNone;

  /// No description provided for @contactsPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick from contacts'**
  String get contactsPickerTitle;

  /// No description provided for @contactsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String contactsSelected(int count);

  /// No description provided for @contactsAddSelected.
  ///
  /// In en, this message translates to:
  /// **'Add {count} members'**
  String contactsAddSelected(int count);

  /// No description provided for @contactsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission denied'**
  String get contactsPermissionDenied;

  /// No description provided for @contactsPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission is blocked. Enable it from app settings.'**
  String get contactsPermissionPermanentlyDenied;

  /// No description provided for @contactsOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get contactsOpenSettings;

  /// No description provided for @contactsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search contacts…'**
  String get contactsSearchHint;

  /// No description provided for @contactsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No contacts found'**
  String get contactsEmpty;

  /// No description provided for @groupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Group name is required'**
  String get groupNameRequired;

  /// No description provided for @memberNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Member name is required'**
  String get memberNameRequired;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @expensesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get expensesEmpty;

  /// No description provided for @expensesToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get expensesToday;

  /// No description provided for @expensesDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this expense?'**
  String get expensesDeleteConfirm;

  /// No description provided for @expensesPaid.
  ///
  /// In en, this message translates to:
  /// **'paid'**
  String get expensesPaid;

  /// No description provided for @expensesPayersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} payers'**
  String expensesPayersCount(int count);

  /// No description provided for @expensesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get expensesFilterAll;

  /// No description provided for @expensesAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expensesAddTitle;

  /// No description provided for @expensesAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get expensesAmountPaid;

  /// No description provided for @expensesPaidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get expensesPaidBy;

  /// No description provided for @expensesAddPayer.
  ///
  /// In en, this message translates to:
  /// **'Add payer'**
  String get expensesAddPayer;

  /// No description provided for @expensesNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get expensesNoteHint;

  /// No description provided for @expensesSave.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get expensesSave;

  /// No description provided for @expensesSplitConfigure.
  ///
  /// In en, this message translates to:
  /// **'Split equally · tap to configure'**
  String get expensesSplitConfigure;

  /// No description provided for @expensesSplitMembersEach.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} member} other{{count} members}} · ৳{each} each'**
  String expensesSplitMembersEach(int count, String each);

  /// No description provided for @expensesSplitMembers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} member} other{{count} members}}'**
  String expensesSplitMembers(int count);

  /// No description provided for @splitTabEqual.
  ///
  /// In en, this message translates to:
  /// **'Equal'**
  String get splitTabEqual;

  /// No description provided for @splitTabUnequal.
  ///
  /// In en, this message translates to:
  /// **'Unequal'**
  String get splitTabUnequal;

  /// No description provided for @splitTabShares.
  ///
  /// In en, this message translates to:
  /// **'Shares'**
  String get splitTabShares;

  /// No description provided for @splitTabPercent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get splitTabPercent;

  /// No description provided for @splitTitle.
  ///
  /// In en, this message translates to:
  /// **'Split ৳{amount}'**
  String splitTitle(String amount);

  /// No description provided for @splitEqually.
  ///
  /// In en, this message translates to:
  /// **'Split equally'**
  String get splitEqually;

  /// No description provided for @splitUnequally.
  ///
  /// In en, this message translates to:
  /// **'Split unequally'**
  String get splitUnequally;

  /// No description provided for @splitByShares.
  ///
  /// In en, this message translates to:
  /// **'Split by shares'**
  String get splitByShares;

  /// No description provided for @splitByPercent.
  ///
  /// In en, this message translates to:
  /// **'Split by percent'**
  String get splitByPercent;

  /// No description provided for @splitByMeals.
  ///
  /// In en, this message translates to:
  /// **'Split by meals'**
  String get splitByMeals;

  /// No description provided for @splitAssigned.
  ///
  /// In en, this message translates to:
  /// **'৳{sum} of ৳{total} assigned'**
  String splitAssigned(String sum, String total);

  /// No description provided for @dashboardTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get dashboardTotalSpent;

  /// No description provided for @dashboardMonthOverview.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get dashboardMonthOverview;

  /// No description provided for @dashboardMyAccount.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get dashboardMyAccount;

  /// No description provided for @dashboardMyMeals.
  ///
  /// In en, this message translates to:
  /// **'My meals'**
  String get dashboardMyMeals;

  /// No description provided for @dashboardMyMealBill.
  ///
  /// In en, this message translates to:
  /// **'Meal bill'**
  String get dashboardMyMealBill;

  /// No description provided for @dashboardMyDeposit.
  ///
  /// In en, this message translates to:
  /// **'My deposit'**
  String get dashboardMyDeposit;

  /// No description provided for @dashboardMyBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get dashboardMyBalance;

  /// No description provided for @dashboardNextBazar.
  ///
  /// In en, this message translates to:
  /// **'Next bazar duty'**
  String get dashboardNextBazar;

  /// No description provided for @bazarTitle.
  ///
  /// In en, this message translates to:
  /// **'Bazar roster'**
  String get bazarTitle;

  /// No description provided for @bazarEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bazar duties yet'**
  String get bazarEmpty;

  /// No description provided for @bazarEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Add who\'s doing the grocery shopping and when'**
  String get bazarEmptySub;

  /// No description provided for @bazarAdd.
  ///
  /// In en, this message translates to:
  /// **'Add duty'**
  String get bazarAdd;

  /// No description provided for @bazarWhose.
  ///
  /// In en, this message translates to:
  /// **'Who\'s doing bazar?'**
  String get bazarWhose;

  /// No description provided for @bazarNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get bazarNoteLabel;

  /// No description provided for @bazarNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. weekly vegetables'**
  String get bazarNoteHint;

  /// No description provided for @dashboardQuickAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get dashboardQuickAddExpense;

  /// No description provided for @dashboardQuickSettleUp.
  ///
  /// In en, this message translates to:
  /// **'Settle up'**
  String get dashboardQuickSettleUp;

  /// No description provided for @dashboardQuickMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get dashboardQuickMembers;

  /// No description provided for @dashboardRecentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Recent expenses'**
  String get dashboardRecentExpenses;

  /// No description provided for @dashboardSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get dashboardSeeAll;

  /// No description provided for @dashboardNoExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get dashboardNoExpenses;

  /// No description provided for @dashboardBalanceOwed.
  ///
  /// In en, this message translates to:
  /// **'you\'re owed'**
  String get dashboardBalanceOwed;

  /// No description provided for @dashboardBalanceOwe.
  ///
  /// In en, this message translates to:
  /// **'you owe'**
  String get dashboardBalanceOwe;

  /// No description provided for @dashboardBalanceSettled.
  ///
  /// In en, this message translates to:
  /// **'settled'**
  String get dashboardBalanceSettled;

  /// No description provided for @depositsTitle.
  ///
  /// In en, this message translates to:
  /// **'Deposits'**
  String get depositsTitle;

  /// No description provided for @depositsCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get depositsCollected;

  /// No description provided for @depositsSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get depositsSpent;

  /// No description provided for @depositsInHand.
  ///
  /// In en, this message translates to:
  /// **'In hand'**
  String get depositsInHand;

  /// No description provided for @depositsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No deposits yet'**
  String get depositsEmpty;

  /// No description provided for @depositsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add deposit'**
  String get depositsAdd;

  /// No description provided for @depositsAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get depositsAmountHint;

  /// No description provided for @depositsMemberHint.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get depositsMemberHint;

  /// No description provided for @depositsNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get depositsNoteHint;

  /// No description provided for @settleUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Settle up'**
  String get settleUpTitle;

  /// No description provided for @settleUpAutoNote.
  ///
  /// In en, this message translates to:
  /// **'{count} payments settle the whole group (instead of manual member-to-member debts).'**
  String settleUpAutoNote(int count);

  /// No description provided for @settleUpAllSettled.
  ///
  /// In en, this message translates to:
  /// **'Everyone is settled up'**
  String get settleUpAllSettled;

  /// No description provided for @settleUpRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get settleUpRecord;

  /// No description provided for @settleUpRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get settleUpRecorded;

  /// No description provided for @settleUpNone.
  ///
  /// In en, this message translates to:
  /// **'No settlements recorded yet'**
  String get settleUpNone;

  /// No description provided for @settleUpConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get settleUpConfirmTitle;

  /// No description provided for @settleUpAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get settleUpAmountHint;

  /// No description provided for @settleUpMethodHint.
  ///
  /// In en, this message translates to:
  /// **'Method (optional, e.g. cash, bKash)'**
  String get settleUpMethodHint;

  /// No description provided for @settleUpBalanceCheck.
  ///
  /// In en, this message translates to:
  /// **'Group balance check'**
  String get settleUpBalanceCheck;

  /// No description provided for @settleUpFullAmountRemaining.
  ///
  /// In en, this message translates to:
  /// **'Full remaining: ৳{amount}'**
  String settleUpFullAmountRemaining(String amount);

  /// No description provided for @mealsGridTitle.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get mealsGridTitle;

  /// No description provided for @mealsNoMembersYetSub.
  ///
  /// In en, this message translates to:
  /// **'Add members before you can start tracking meals'**
  String get mealsNoMembersYetSub;

  /// No description provided for @mealsSameAsYesterday.
  ///
  /// In en, this message translates to:
  /// **'Same as yesterday'**
  String get mealsSameAsYesterday;

  /// No description provided for @mealsBulkFill.
  ///
  /// In en, this message translates to:
  /// **'Bulk fill'**
  String get mealsBulkFill;

  /// No description provided for @mealsTotalMeals.
  ///
  /// In en, this message translates to:
  /// **'Total meals'**
  String get mealsTotalMeals;

  /// No description provided for @mealsRateLive.
  ///
  /// In en, this message translates to:
  /// **'Meal rate · LIVE'**
  String get mealsRateLive;

  /// No description provided for @mealsSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set meals'**
  String get mealsSetTitle;

  /// No description provided for @mealsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get mealsCountLabel;

  /// No description provided for @mealsGuestLabel.
  ///
  /// In en, this message translates to:
  /// **'Guest meals'**
  String get mealsGuestLabel;

  /// No description provided for @mealsBulkFillTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk fill this day'**
  String get mealsBulkFillTitle;

  /// No description provided for @mealsBulkFillHint.
  ///
  /// In en, this message translates to:
  /// **'Set this meal count for every member'**
  String get mealsBulkFillHint;

  /// No description provided for @mealsMemberDetail.
  ///
  /// In en, this message translates to:
  /// **'meals'**
  String get mealsMemberDetail;

  /// No description provided for @mealsMemberTotalMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get mealsMemberTotalMeals;

  /// No description provided for @mealsMemberGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get mealsMemberGuest;

  /// No description provided for @mealsMemberBill.
  ///
  /// In en, this message translates to:
  /// **'Meal bill'**
  String get mealsMemberBill;

  /// No description provided for @mealsDailyEntries.
  ///
  /// In en, this message translates to:
  /// **'Daily entries'**
  String get mealsDailyEntries;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'{month} report'**
  String reportTitle(String month);

  /// No description provided for @reportTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get reportTotalSpent;

  /// No description provided for @reportTotalMeals.
  ///
  /// In en, this message translates to:
  /// **'Total meals'**
  String get reportTotalMeals;

  /// No description provided for @reportMealRate.
  ///
  /// In en, this message translates to:
  /// **'Meal rate'**
  String get reportMealRate;

  /// No description provided for @reportShareImage.
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get reportShareImage;

  /// No description provided for @reportPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get reportPdf;

  /// No description provided for @reportCsv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get reportCsv;

  /// No description provided for @reportCloseMonth.
  ///
  /// In en, this message translates to:
  /// **'Close month'**
  String get reportCloseMonth;

  /// No description provided for @reportCloseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Close {month}?'**
  String reportCloseConfirmTitle(String month);

  /// No description provided for @reportCloseConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This locks all records for this month. You can still view everything, but nothing can be edited after closing.'**
  String get reportCloseConfirmBody;

  /// No description provided for @reportCloseSnapshotSaved.
  ///
  /// In en, this message translates to:
  /// **'Snapshot saved'**
  String get reportCloseSnapshotSaved;

  /// No description provided for @reportCloseSnapshotSub.
  ///
  /// In en, this message translates to:
  /// **'Report frozen exactly as it is now'**
  String get reportCloseSnapshotSub;

  /// No description provided for @reportCloseCarryForward.
  ///
  /// In en, this message translates to:
  /// **'Balances carry forward'**
  String get reportCloseCarryForward;

  /// No description provided for @reportCloseCarryForwardSub.
  ///
  /// In en, this message translates to:
  /// **'Unsettled dues open next month automatically'**
  String get reportCloseCarryForwardSub;

  /// No description provided for @reportLockedBanner.
  ///
  /// In en, this message translates to:
  /// **'This month is closed and locked'**
  String get reportLockedBanner;

  /// No description provided for @reportMonthClosed.
  ///
  /// In en, this message translates to:
  /// **'Month closed'**
  String get reportMonthClosed;

  /// No description provided for @reportStartNewMonth.
  ///
  /// In en, this message translates to:
  /// **'Start new month'**
  String get reportStartNewMonth;

  /// No description provided for @monthClosedCannotEdit.
  ///
  /// In en, this message translates to:
  /// **'This month is closed. Reopen it or pick a different date to edit.'**
  String get monthClosedCannotEdit;

  /// No description provided for @reportColMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get reportColMember;

  /// No description provided for @reportColMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get reportColMeals;

  /// No description provided for @reportColMealBill.
  ///
  /// In en, this message translates to:
  /// **'Meal bill'**
  String get reportColMealBill;

  /// No description provided for @reportColShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get reportColShared;

  /// No description provided for @reportColPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid+Dep'**
  String get reportColPaid;

  /// No description provided for @reportColDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get reportColDue;

  /// No description provided for @reportTotalRow.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get reportTotalRow;

  /// No description provided for @reportShareChooserTitle.
  ///
  /// In en, this message translates to:
  /// **'Share month report'**
  String get reportShareChooserTitle;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backupTitle;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export file'**
  String get backupExport;

  /// No description provided for @backupImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get backupImport;

  /// No description provided for @backupNeverBackedUp.
  ///
  /// In en, this message translates to:
  /// **'Never backed up'**
  String get backupNeverBackedUp;

  /// No description provided for @backupBackedUpOn.
  ///
  /// In en, this message translates to:
  /// **'Backed up {date}'**
  String backupBackedUpOn(String date);

  /// No description provided for @backupOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup overdue'**
  String get backupOverdueTitle;

  /// No description provided for @backupOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'Export a backup file to stay safe.'**
  String get backupOverdueBody;

  /// No description provided for @backupOverdueAction.
  ///
  /// In en, this message translates to:
  /// **'Back up'**
  String get backupOverdueAction;

  /// No description provided for @backupImportPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Import preview'**
  String get backupImportPreviewTitle;

  /// No description provided for @backupImportWarning.
  ///
  /// In en, this message translates to:
  /// **'Importing replaces all current data. Export a backup first.'**
  String get backupImportWarning;

  /// No description provided for @backupImportConfirm.
  ///
  /// In en, this message translates to:
  /// **'Replace all data'**
  String get backupImportConfirm;

  /// No description provided for @backupImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully'**
  String get backupImportSuccess;

  /// No description provided for @backupInvalidTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t import this file'**
  String get backupInvalidTitle;

  /// No description provided for @backupChecksumValid.
  ///
  /// In en, this message translates to:
  /// **'Checksum valid · schema v{version}'**
  String backupChecksumValid(int version);

  /// No description provided for @backupExportedOn.
  ///
  /// In en, this message translates to:
  /// **'Exported {date}'**
  String backupExportedOn(String date);

  /// No description provided for @lockEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get lockEnterPin;

  /// No description provided for @lockSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN'**
  String get lockSetPin;

  /// No description provided for @lockConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get lockConfirmPin;

  /// No description provided for @lockPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs didn\'t match. Try again.'**
  String get lockPinMismatch;

  /// No description provided for @lockWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get lockWrongPin;

  /// No description provided for @lockUseBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics instead'**
  String get lockUseBiometric;

  /// No description provided for @lockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lockUnlock;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsPremiumBanner.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get settingsPremiumBanner;

  /// No description provided for @settingsPremiumBannerSub.
  ///
  /// In en, this message translates to:
  /// **'Unlimited groups · PDF · charts · Drive backup'**
  String get settingsPremiumBannerSub;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language & format'**
  String get settingsLanguageSection;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance & security'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsRemindersSection.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsRemindersSection;

  /// No description provided for @settingsDataSection.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsDataSection;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpTitle;

  /// No description provided for @helpQCreateMess.
  ///
  /// In en, this message translates to:
  /// **'How do I create a mess?'**
  String get helpQCreateMess;

  /// No description provided for @helpACreateMess.
  ///
  /// In en, this message translates to:
  /// **'On first launch, choose \"I manage a mess,\" then follow the wizard: name your mess, add members from your contacts or manually, and choose whether meal costs and other bills are tracked together or separately.'**
  String get helpACreateMess;

  /// No description provided for @helpQAddMembers.
  ///
  /// In en, this message translates to:
  /// **'How do I add or remove members later?'**
  String get helpQAddMembers;

  /// No description provided for @helpAAddMembers.
  ///
  /// In en, this message translates to:
  /// **'Open Members from the drawer. Tap \"Add from contacts\" or \"Add manually\" to add someone. To remove someone, use the ⋮ menu on their row — Deactivate keeps their history, Delete member only works if they have no meals, expenses, or payments recorded yet.'**
  String get helpAAddMembers;

  /// No description provided for @helpQRoles.
  ///
  /// In en, this message translates to:
  /// **'What do roles and permissions mean?'**
  String get helpQRoles;

  /// No description provided for @helpARoles.
  ///
  /// In en, this message translates to:
  /// **'The App Admin (the mess creator) always has full access. Every other member can be a Sub-Admin with only the permissions you choose (e.g. managing meals but not money), or a plain Member who can view everything but not edit. Set this up from Roles & permissions.'**
  String get helpARoles;

  /// No description provided for @helpQJoin.
  ///
  /// In en, this message translates to:
  /// **'How does a member join from their own phone?'**
  String get helpQJoin;

  /// No description provided for @helpAJoin.
  ///
  /// In en, this message translates to:
  /// **'First bring your mess online (Settings → Mess → Online) to get an invite code. Share that code with the member. They open MessBook, choose \"I\'m joining a mess,\" sign in with Google, and enter the code — then either claim their existing name or add themselves as new.'**
  String get helpAJoin;

  /// No description provided for @helpQMeals.
  ///
  /// In en, this message translates to:
  /// **'How do I track meals?'**
  String get helpQMeals;

  /// No description provided for @helpAMeals.
  ///
  /// In en, this message translates to:
  /// **'Open Meals from the drawer to log each member\'s meals per day, including half meals and guest meals. You can also set up a weekly routine per member so their usual meals fill in automatically.'**
  String get helpAMeals;

  /// No description provided for @helpQMealRate.
  ///
  /// In en, this message translates to:
  /// **'How is the meal rate calculated?'**
  String get helpQMealRate;

  /// No description provided for @helpAMealRate.
  ///
  /// In en, this message translates to:
  /// **'The meal rate is the total meal spending for the month divided by the total number of meals everyone ate. Each member\'s meal bill is their own meal count multiplied by that rate.'**
  String get helpAMealRate;

  /// No description provided for @helpQPolls.
  ///
  /// In en, this message translates to:
  /// **'What are meal polls for?'**
  String get helpQPolls;

  /// No description provided for @helpAPolls.
  ///
  /// In en, this message translates to:
  /// **'Polls let members vote on which meals they\'ll take for a given day, instead of the manager guessing or asking everyone individually. Anyone with poll-creation permission can start one; every member can vote regardless of role.'**
  String get helpAPolls;

  /// No description provided for @helpQSettleUp.
  ///
  /// In en, this message translates to:
  /// **'How does Settle Up work?'**
  String get helpQSettleUp;

  /// No description provided for @helpASettleUp.
  ///
  /// In en, this message translates to:
  /// **'Settle Up looks at everyone\'s balance and suggests the fewest possible payments to bring every balance to zero, instead of everyone paying everyone else individually.'**
  String get helpASettleUp;

  /// No description provided for @helpQMonthClose.
  ///
  /// In en, this message translates to:
  /// **'What happens when I close a month?'**
  String get helpQMonthClose;

  /// No description provided for @helpAMonthClose.
  ///
  /// In en, this message translates to:
  /// **'Closing a month locks its meals, expenses, and deposits so they can no longer be edited, and starts a fresh month. You can choose to carry forward each member\'s balance as an opening entry in the new month.'**
  String get helpAMonthClose;

  /// No description provided for @helpQBackup.
  ///
  /// In en, this message translates to:
  /// **'How do I back up my data?'**
  String get helpQBackup;

  /// No description provided for @helpABackup.
  ///
  /// In en, this message translates to:
  /// **'Go to Backup & restore from the drawer to export a backup file anytime, or import one to restore. This works fully offline and doesn\'t require an account.'**
  String get helpABackup;

  /// No description provided for @helpQOnline.
  ///
  /// In en, this message translates to:
  /// **'Do I need the internet to use MessBook?'**
  String get helpQOnline;

  /// No description provided for @helpAOnline.
  ///
  /// In en, this message translates to:
  /// **'No — MessBook works fully offline on a single phone. Bringing a mess online (and signing in with Google) is only needed if you want other members to join from their own phones and see live updates.'**
  String get helpAOnline;

  /// No description provided for @settingsFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get settingsFollowSystem;

  /// No description provided for @settingsPinBiometric.
  ///
  /// In en, this message translates to:
  /// **'PIN + biometric'**
  String get settingsPinBiometric;

  /// No description provided for @settingsDailyMealReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily meal reminder'**
  String get settingsDailyMealReminder;

  /// No description provided for @settingsEveryNight.
  ///
  /// In en, this message translates to:
  /// **'Every night'**
  String get settingsEveryNight;

  /// No description provided for @settingsMonthCloseReminder.
  ///
  /// In en, this message translates to:
  /// **'Month-close reminder'**
  String get settingsMonthCloseReminder;

  /// No description provided for @settingsLastDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Last day of month window'**
  String get settingsLastDayOfMonth;

  /// No description provided for @settingsBackupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get settingsBackupRestore;

  /// No description provided for @settingsResetData.
  ///
  /// In en, this message translates to:
  /// **'Reset all data'**
  String get settingsResetData;

  /// No description provided for @settingsResetDataSub.
  ///
  /// In en, this message translates to:
  /// **'Requires typing RESET'**
  String get settingsResetDataSub;

  /// No description provided for @settingsResetConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Type RESET to confirm'**
  String get settingsResetConfirmHint;

  /// No description provided for @settingsResetTypeHere.
  ///
  /// In en, this message translates to:
  /// **'Type here'**
  String get settingsResetTypeHere;

  /// No description provided for @chartsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get chartsTitle;

  /// No description provided for @chartsWhereWentTitle.
  ///
  /// In en, this message translates to:
  /// **'Where {month} went'**
  String chartsWhereWentTitle(String month);

  /// No description provided for @chartsTotal.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get chartsTotal;

  /// No description provided for @chartsTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly spend trend'**
  String get chartsTrendTitle;

  /// No description provided for @chartsTrendMonths.
  ///
  /// In en, this message translates to:
  /// **'{count} months'**
  String chartsTrendMonths(int count);

  /// No description provided for @chartsNoData.
  ///
  /// In en, this message translates to:
  /// **'No spending data yet'**
  String get chartsNoData;

  /// No description provided for @recurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring expenses'**
  String get recurringTitle;

  /// No description provided for @recurringAdd.
  ///
  /// In en, this message translates to:
  /// **'Add recurring'**
  String get recurringAdd;

  /// No description provided for @recurringEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recurring expenses set up'**
  String get recurringEmpty;

  /// No description provided for @recurringDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of each month'**
  String recurringDayOfMonth(int day);

  /// No description provided for @recurringActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get recurringActive;

  /// No description provided for @recurringPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get recurringPaused;

  /// No description provided for @recurringAddIsPremium.
  ///
  /// In en, this message translates to:
  /// **'Recurring expenses are a Premium feature'**
  String get recurringAddIsPremium;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'MessBook Premium'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay once. Yours forever. No subscription.'**
  String get paywallSubtitle;

  /// No description provided for @paywallFeatureGroups.
  ///
  /// In en, this message translates to:
  /// **'Unlimited groups'**
  String get paywallFeatureGroups;

  /// No description provided for @paywallFeatureHistory.
  ///
  /// In en, this message translates to:
  /// **'Full history — every past month'**
  String get paywallFeatureHistory;

  /// No description provided for @paywallFeatureExport.
  ///
  /// In en, this message translates to:
  /// **'PDF & CSV export'**
  String get paywallFeatureExport;

  /// No description provided for @paywallFeatureCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts & insights'**
  String get paywallFeatureCharts;

  /// No description provided for @paywallFeatureDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive auto-backup'**
  String get paywallFeatureDrive;

  /// No description provided for @paywallFeatureRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring expenses & receipt photos'**
  String get paywallFeatureRecurring;

  /// No description provided for @paywallUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock everything · {price}'**
  String paywallUnlockButton(String price);

  /// No description provided for @paywallDefaultPrice.
  ///
  /// In en, this message translates to:
  /// **'৳499'**
  String get paywallDefaultPrice;

  /// No description provided for @paywallOneTimeNote.
  ///
  /// In en, this message translates to:
  /// **'One-time payment via Google Play'**
  String get paywallOneTimeNote;

  /// No description provided for @paywallRestorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get paywallRestorePurchase;

  /// No description provided for @paywallAlreadyUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Premium already unlocked'**
  String get paywallAlreadyUnlocked;

  /// No description provided for @paywallPurchaseError.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get paywallPurchaseError;

  /// No description provided for @paywallRestoreNone.
  ///
  /// In en, this message translates to:
  /// **'No previous purchase found for this account'**
  String get paywallRestoreNone;

  /// No description provided for @paywallStoreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Play Store billing isn\'t available on this device'**
  String get paywallStoreUnavailable;

  /// No description provided for @chartsPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Charts are a Premium feature'**
  String get chartsPremiumTitle;

  /// No description provided for @chartsPremiumBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium to see category breakdowns and spending trends.'**
  String get chartsPremiumBody;

  /// No description provided for @chartsUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get chartsUnlockButton;

  /// No description provided for @groupsUpgradeRequired.
  ///
  /// In en, this message translates to:
  /// **'Free plan includes 1 active group'**
  String get groupsUpgradeRequired;

  /// No description provided for @reportHistoryLocked.
  ///
  /// In en, this message translates to:
  /// **'Free plan shows the current and previous month. Unlock Premium for full history.'**
  String get reportHistoryLocked;

  /// No description provided for @reportExportIsPremium.
  ///
  /// In en, this message translates to:
  /// **'PDF & CSV export are Premium features'**
  String get reportExportIsPremium;

  /// No description provided for @backupDriveSection.
  ///
  /// In en, this message translates to:
  /// **'Google Drive auto-backup'**
  String get backupDriveSection;

  /// No description provided for @backupDriveToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily auto-backup'**
  String get backupDriveToggleTitle;

  /// No description provided for @backupDriveToggleSub.
  ///
  /// In en, this message translates to:
  /// **'Uploads an encrypted-in-transit copy to your Google Drive appdata folder every day'**
  String get backupDriveToggleSub;

  /// No description provided for @backupDriveSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String backupDriveSignedInAs(String email);

  /// No description provided for @backupDriveSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign in to Google Drive'**
  String get backupDriveSignInFailed;

  /// No description provided for @backupDrivePremiumNote.
  ///
  /// In en, this message translates to:
  /// **'Google Drive auto-backup is a Premium feature — manual file export/import is always free'**
  String get backupDrivePremiumNote;

  /// No description provided for @expensesReceiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Receipt photo'**
  String get expensesReceiptPhoto;

  /// No description provided for @expensesAddReceiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add receipt photo'**
  String get expensesAddReceiptPhoto;

  /// No description provided for @expensesRemoveReceiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get expensesRemoveReceiptPhoto;

  /// No description provided for @expensesReceiptIsPremium.
  ///
  /// In en, this message translates to:
  /// **'Receipt photos are a Premium feature'**
  String get expensesReceiptIsPremium;

  /// No description provided for @commonProBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get commonProBadge;

  /// No description provided for @commonErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String commonErrorPrefix(String error);

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsDailyMealReminderTime.
  ///
  /// In en, this message translates to:
  /// **'10:00 PM'**
  String get settingsDailyMealReminderTime;

  /// No description provided for @recurringAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get recurringAmountLabel;

  /// No description provided for @groupsMealsOn.
  ///
  /// In en, this message translates to:
  /// **'meals on'**
  String get groupsMealsOn;

  /// No description provided for @mealsGuestCount.
  ///
  /// In en, this message translates to:
  /// **'+{count} guest'**
  String mealsGuestCount(String count);

  /// No description provided for @backupPreviewGroups.
  ///
  /// In en, this message translates to:
  /// **'{count} groups'**
  String backupPreviewGroups(String count);

  /// No description provided for @backupPreviewMembers.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String backupPreviewMembers(String count);

  /// No description provided for @backupPreviewExpenses.
  ///
  /// In en, this message translates to:
  /// **'{count} expenses'**
  String backupPreviewExpenses(String count);

  /// No description provided for @backupPreviewMeals.
  ///
  /// In en, this message translates to:
  /// **'{count} meals'**
  String backupPreviewMeals(String count);

  /// No description provided for @backupPreviewDeposits.
  ///
  /// In en, this message translates to:
  /// **'{count} deposits'**
  String backupPreviewDeposits(String count);

  /// No description provided for @splitNoMealDataForMonth.
  ///
  /// In en, this message translates to:
  /// **'No meal data for this month'**
  String get splitNoMealDataForMonth;

  /// No description provided for @splitNoMealsForSelectedMembers.
  ///
  /// In en, this message translates to:
  /// **'No meals recorded for the selected members'**
  String get splitNoMealsForSelectedMembers;

  /// No description provided for @notifyMealReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Log today\'s meals'**
  String get notifyMealReminderTitle;

  /// No description provided for @notifyMealReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Update today\'s meal count before it slips your mind.'**
  String get notifyMealReminderBody;

  /// No description provided for @notifyMonthCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Month closing soon'**
  String get notifyMonthCloseTitle;

  /// No description provided for @notifyMonthCloseBody.
  ///
  /// In en, this message translates to:
  /// **'Review this month\'s expenses and close it out.'**
  String get notifyMonthCloseBody;

  /// No description provided for @notifyBackupOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup reminder'**
  String get notifyBackupOverdueTitle;

  /// No description provided for @notifyBackupOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s been a while since your last backup. Export one from Settings.'**
  String get notifyBackupOverdueBody;

  /// No description provided for @ledgerMealTab.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get ledgerMealTab;

  /// No description provided for @ledgerGeneralTab.
  ///
  /// In en, this message translates to:
  /// **'Rent & others'**
  String get ledgerGeneralTab;

  /// No description provided for @groupMealLedgerSeparate.
  ///
  /// In en, this message translates to:
  /// **'Separate meal money'**
  String get groupMealLedgerSeparate;

  /// No description provided for @groupMealLedgerSeparateSub.
  ///
  /// In en, this message translates to:
  /// **'Meal costs get their own balance, settle-up and month close — kept apart from rent & other shared costs'**
  String get groupMealLedgerSeparateSub;

  /// No description provided for @depositsPurposeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which balance is this for?'**
  String get depositsPurposeQuestion;

  /// No description provided for @pollNonVoterPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'If someone doesn\'t vote'**
  String get pollNonVoterPolicyLabel;

  /// No description provided for @nonVoterPolicyRoutine.
  ///
  /// In en, this message translates to:
  /// **'Use their routine'**
  String get nonVoterPolicyRoutine;

  /// No description provided for @nonVoterPolicyPending.
  ///
  /// In en, this message translates to:
  /// **'Leave pending for Meal Admin'**
  String get nonVoterPolicyPending;

  /// No description provided for @nonVoterPolicyZero.
  ///
  /// In en, this message translates to:
  /// **'Count as no meal'**
  String get nonVoterPolicyZero;

  /// No description provided for @nonVoterPolicyRepeatYesterday.
  ///
  /// In en, this message translates to:
  /// **'Repeat yesterday'**
  String get nonVoterPolicyRepeatYesterday;

  /// No description provided for @mealSlotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Slots'**
  String get mealSlotsTitle;

  /// No description provided for @mealSlotsSub.
  ///
  /// In en, this message translates to:
  /// **'Customize Breakfast, Lunch, Dinner and what each counts as'**
  String get mealSlotsSub;

  /// No description provided for @mealSlotAdd.
  ///
  /// In en, this message translates to:
  /// **'Add slot'**
  String get mealSlotAdd;

  /// No description provided for @mealSlotName.
  ///
  /// In en, this message translates to:
  /// **'Slot name'**
  String get mealSlotName;

  /// No description provided for @mealSlotWeight.
  ///
  /// In en, this message translates to:
  /// **'Counts as (meals)'**
  String get mealSlotWeight;

  /// No description provided for @mealSlotWeightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 0.5 for half a meal'**
  String get mealSlotWeightHint;

  /// No description provided for @mealSlotBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealSlotBreakfast;

  /// No description provided for @mealSlotLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealSlotLunch;

  /// No description provided for @mealSlotDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealSlotDinner;

  /// No description provided for @mealSlotDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get mealSlotDeactivate;

  /// No description provided for @mealSlotReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get mealSlotReactivate;

  /// No description provided for @mealSlotEmpty.
  ///
  /// In en, this message translates to:
  /// **'No meal slots yet'**
  String get mealSlotEmpty;

  /// No description provided for @membersMealRoutine.
  ///
  /// In en, this message translates to:
  /// **'Meal routine'**
  String get membersMealRoutine;

  /// No description provided for @routineTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s meal routine'**
  String routineTitle(String name);

  /// No description provided for @routineSub.
  ///
  /// In en, this message translates to:
  /// **'Auto-fills the meal grid every day from this routine'**
  String get routineSub;

  /// No description provided for @routineDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get routineDaily;

  /// No description provided for @routineCustomizeDay.
  ///
  /// In en, this message translates to:
  /// **'Customize a specific day'**
  String get routineCustomizeDay;

  /// No description provided for @routineWeekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get routineWeekdayMon;

  /// No description provided for @routineWeekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get routineWeekdayTue;

  /// No description provided for @routineWeekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get routineWeekdayWed;

  /// No description provided for @routineWeekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get routineWeekdayThu;

  /// No description provided for @routineWeekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get routineWeekdayFri;

  /// No description provided for @routineWeekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get routineWeekdaySat;

  /// No description provided for @routineWeekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get routineWeekdaySun;

  /// No description provided for @routineLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal leave'**
  String get routineLeaveTitle;

  /// No description provided for @routineLeaveAdd.
  ///
  /// In en, this message translates to:
  /// **'Add leave dates'**
  String get routineLeaveAdd;

  /// No description provided for @routineLeaveFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get routineLeaveFrom;

  /// No description provided for @routineLeaveTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get routineLeaveTo;

  /// No description provided for @routineLeaveNote.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get routineLeaveNote;

  /// No description provided for @routineLeaveEmpty.
  ///
  /// In en, this message translates to:
  /// **'No leave scheduled'**
  String get routineLeaveEmpty;

  /// No description provided for @pollsTitle.
  ///
  /// In en, this message translates to:
  /// **'Polls'**
  String get pollsTitle;

  /// No description provided for @pollsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No polls yet'**
  String get pollsEmpty;

  /// No description provided for @pollCreate.
  ///
  /// In en, this message translates to:
  /// **'Create poll'**
  String get pollCreate;

  /// No description provided for @pollTypeSlots.
  ///
  /// In en, this message translates to:
  /// **'Meal slots'**
  String get pollTypeSlots;

  /// No description provided for @pollTypeCount.
  ///
  /// In en, this message translates to:
  /// **'Meal count'**
  String get pollTypeCount;

  /// No description provided for @pollTypeMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu choice'**
  String get pollTypeMenu;

  /// No description provided for @pollQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Question (e.g. Tomorrow\'s dinner?)'**
  String get pollQuestionHint;

  /// No description provided for @pollOptionsHint.
  ///
  /// In en, this message translates to:
  /// **'Options, one per line'**
  String get pollOptionsHint;

  /// No description provided for @pollCloseAt.
  ///
  /// In en, this message translates to:
  /// **'Closes at'**
  String get pollCloseAt;

  /// No description provided for @pollNonVoterOverride.
  ///
  /// In en, this message translates to:
  /// **'Non-voter rule for this poll'**
  String get pollNonVoterOverride;

  /// No description provided for @pollNonVoterUseDefault.
  ///
  /// In en, this message translates to:
  /// **'Use mess default'**
  String get pollNonVoterUseDefault;

  /// No description provided for @pollForDate.
  ///
  /// In en, this message translates to:
  /// **'For {date}'**
  String pollForDate(String date);

  /// No description provided for @pollVoteNow.
  ///
  /// In en, this message translates to:
  /// **'Vote now'**
  String get pollVoteNow;

  /// No description provided for @pollVoteSlotsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which meals will you take?'**
  String get pollVoteSlotsQuestion;

  /// No description provided for @pollVoteCountQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many meals?'**
  String get pollVoteCountQuestion;

  /// No description provided for @pollVoteMenuQuestion.
  ///
  /// In en, this message translates to:
  /// **'Pick one'**
  String get pollVoteMenuQuestion;

  /// No description provided for @pollVoteSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit vote'**
  String get pollVoteSubmit;

  /// No description provided for @pollVoted.
  ///
  /// In en, this message translates to:
  /// **'Voted'**
  String get pollVoted;

  /// No description provided for @pollClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get pollClosed;

  /// No description provided for @pollOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get pollOpen;

  /// No description provided for @pollReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen voting'**
  String get pollReopen;

  /// No description provided for @pollReopenHint.
  ///
  /// In en, this message translates to:
  /// **'Give members more time to vote. The poll reopens and closes again at the new time, re-applying results (manual meal edits are kept).'**
  String get pollReopenHint;

  /// No description provided for @pollReopenAction.
  ///
  /// In en, this message translates to:
  /// **'Reopen & extend'**
  String get pollReopenAction;

  /// No description provided for @pollDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete poll'**
  String get pollDelete;

  /// No description provided for @pollDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this poll and all its votes? This can\'t be undone. Meals already recorded from it stay in the sheet.'**
  String get pollDeleteConfirm;

  /// No description provided for @pollVotedCount.
  ///
  /// In en, this message translates to:
  /// **'{voted}/{total} voted'**
  String pollVotedCount(String voted, String total);

  /// No description provided for @pollResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get pollResultsTitle;

  /// No description provided for @pollPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Still need to set'**
  String get pollPendingTitle;

  /// No description provided for @pollPendingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing pending'**
  String get pollPendingEmpty;

  /// No description provided for @pollResolveSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get pollResolveSet;

  /// No description provided for @pollCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Created by {name}'**
  String pollCreatedBy(String name);

  /// No description provided for @dashboardTodaysPoll.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Poll'**
  String get dashboardTodaysPoll;

  /// No description provided for @notifyPollReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Poll closing soon'**
  String get notifyPollReminderTitle;

  /// No description provided for @notifyPollReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Vote in today\'s meal poll before it closes.'**
  String get notifyPollReminderBody;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @accountNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get accountNotSignedIn;

  /// No description provided for @accountSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google to bring a mess online or join one on another device'**
  String get accountSignInSubtitle;

  /// No description provided for @accountSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get accountSignInButton;

  /// No description provided for @accountSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get accountSignInFailed;

  /// No description provided for @accountSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String accountSignedInAs(String email);

  /// No description provided for @accountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get accountSignOut;

  /// No description provided for @accountServerSection.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get accountServerSection;

  /// No description provided for @accountServerUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'API server URL'**
  String get accountServerUrlLabel;

  /// No description provided for @accountServerUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://api.yourdomain.com'**
  String get accountServerUrlHint;

  /// No description provided for @accountServerUrlSaved.
  ///
  /// In en, this message translates to:
  /// **'Server URL saved'**
  String get accountServerUrlSaved;

  /// No description provided for @onlineSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Online & sync'**
  String get onlineSectionTitle;

  /// No description provided for @onlineBringOnlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Bring this mess online'**
  String get onlineBringOnlineTitle;

  /// No description provided for @onlineBringOnlineSub.
  ///
  /// In en, this message translates to:
  /// **'Get an invite code so other members can join from their phones'**
  String get onlineBringOnlineSub;

  /// No description provided for @onlineBringOnlineButton.
  ///
  /// In en, this message translates to:
  /// **'Bring online'**
  String get onlineBringOnlineButton;

  /// No description provided for @onlineSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in first to bring this mess online'**
  String get onlineSignInRequired;

  /// No description provided for @onlineAlreadyOnline.
  ///
  /// In en, this message translates to:
  /// **'This mess is online'**
  String get onlineAlreadyOnline;

  /// No description provided for @onlineInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get onlineInviteCodeLabel;

  /// No description provided for @onlineShareInvite.
  ///
  /// In en, this message translates to:
  /// **'Share invite code'**
  String get onlineShareInvite;

  /// No description provided for @onlineBringOnlineError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t bring this mess online. Please try again.'**
  String get onlineBringOnlineError;

  /// No description provided for @onlineSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get onlineSyncNow;

  /// No description provided for @onlineSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get onlineSyncing;

  /// No description provided for @onlineSyncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get onlineSyncSuccess;

  /// No description provided for @onlineSyncError.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Please try again.'**
  String get onlineSyncError;

  /// No description provided for @joinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join a mess'**
  String get joinTitle;

  /// No description provided for @joinCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get joinCodeLabel;

  /// No description provided for @joinCodeHint.
  ///
  /// In en, this message translates to:
  /// **'MESS-XXXX'**
  String get joinCodeHint;

  /// No description provided for @joinContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get joinContinue;

  /// No description provided for @joinIdentityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Is one of these you?'**
  String get joinIdentityQuestion;

  /// No description provided for @joinImNew.
  ///
  /// In en, this message translates to:
  /// **'I\'m new — add me'**
  String get joinImNew;

  /// No description provided for @joinChangeCode.
  ///
  /// In en, this message translates to:
  /// **'Change code'**
  String get joinChangeCode;

  /// No description provided for @joinYourNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get joinYourNameLabel;

  /// No description provided for @joinYourNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rahim'**
  String get joinYourNameHint;

  /// No description provided for @joinButton.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinButton;

  /// No description provided for @joinSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in first to join a mess'**
  String get joinSignInRequired;

  /// No description provided for @joinLookupError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find that mess. Please check the code and try again.'**
  String get joinLookupError;

  /// No description provided for @joinError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t join. Please check the code and try again.'**
  String get joinError;

  /// No description provided for @joinSuccess.
  ///
  /// In en, this message translates to:
  /// **'Joined {name}'**
  String joinSuccess(String name);

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Mess Chat'**
  String get chatTitle;

  /// No description provided for @chatEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Say hello!'**
  String get chatEmpty;

  /// No description provided for @chatMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get chatMessageHint;

  /// No description provided for @chatConnectError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect to chat. Check your connection and reopen this screen.'**
  String get chatConnectError;

  /// No description provided for @chatSendError.
  ///
  /// In en, this message translates to:
  /// **'Message didn\'t send. Please try again.'**
  String get chatSendError;

  /// No description provided for @chatUnknownSender.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get chatUnknownSender;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
