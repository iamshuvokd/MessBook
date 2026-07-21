import 'package:drift/drift.dart';

/// All money columns store integer paisa. Never use REAL/float for currency.
/// Every table carries `updatedAt` (epoch ms) for future cloud-sync support.

class Groups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  // 'mess' | 'flat' | 'trip' | 'other'
  TextColumn get type => text().withDefault(const Constant('mess'))();
  TextColumn get currencySymbol => text().withDefault(const Constant('৳'))();
  IntColumn get monthStartDay => integer().withDefault(const Constant(1))();
  BoolColumn get mealEnabled => boolean().withDefault(const Constant(true))();
  // When true, meal costs and rent/other shared costs are two fully
  // independent balances (own debt-simplification, own settle-up, own
  // month-close) instead of one combined net per member.
  BoolColumn get mealLedgerSeparate => boolean().withDefault(const Constant(false))();
  // Default for polls that don't set their own override — 'routine' |
  // 'pending' | 'zero' | 'repeatYesterday' (customizable by the App Admin,
  // per-poll overridable too — user decision).
  TextColumn get defaultNonVoterPolicy => text().withDefault(const Constant('routine'))();
  // How many minutes before a poll closes every member's device fires the
  // "vote now" reminder. Mess-wide (set by the App Admin) and synced, so all
  // members share one policy rather than each phone guessing; 0 = off.
  IntColumn get pollReminderMinutes => integer().withDefault(const Constant(30))();
  // Warn when a member's remaining balance falls below this (paisa).
  // 0 = the mess hasn't set a threshold, so no low-balance warnings.
  IntColumn get lowBalanceThresholdPaisa => integer().withDefault(const Constant(0))();
  // When on, a member under the threshold stops getting meals added
  // automatically (routine auto-fill / poll defaults) until they top up.
  BoolColumn get autoMealOffBelowThreshold => boolean().withDefault(const Constant(false))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  // Set once this mess is "brought online" (registered with the sync
  // server); null means it's still purely local. Shown to the App Admin so
  // they can share it with other members via the join screen.
  TextColumn get inviteCode => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'groups';
}

class Members extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  IntColumn get joinDate => integer()();
  IntColumn get leaveDate => integer().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  // 'appAdmin' | 'subAdmin' | 'member' — the mess owner (App Admin) has
  // every permission implicitly; a subAdmin's actual rights live in
  // `permissions` (comma-separated MemberPermission keys, e.g.
  // 'meals.manage,polls.create'); a plain 'member' has none.
  TextColumn get role => text().withDefault(const Constant('member'))();
  TextColumn get permissions => text().withDefault(const Constant(''))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'members';
}

class Categories extends Table {
  TextColumn get id => text()();
  // null = default/global category available to every group
  TextColumn get groupId => text().nullable().references(Groups, #id)();
  TextColumn get name => text()();
  // stable i18n key for seeded defaults (e.g. "bazar"); null for user-created categories
  TextColumn get defaultKey => text().nullable()();
  BoolColumn get isMealCategory => boolean().withDefault(const Constant(false))();
  TextColumn get icon => text()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'categories';
}

class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  IntColumn get amountPaisa => integer()();
  IntColumn get date => integer()();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get note => text().nullable()();
  TextColumn get receiptPath => text().nullable()();
  BoolColumn get isRecurringInstance => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'expenses';
}

class ExpensePayers extends Table {
  TextColumn get expenseId => text().references(Expenses, #id)();
  TextColumn get memberId => text().references(Members, #id)();
  IntColumn get amountPaidPaisa => integer()();

  @override
  Set<Column> get primaryKey => {expenseId, memberId};

  @override
  String get tableName => 'expense_payers';
}

class ExpenseSplits extends Table {
  TextColumn get expenseId => text().references(Expenses, #id)();
  TextColumn get memberId => text().references(Members, #id)();
  IntColumn get amountPaisa => integer()();
  // 'equal' | 'unequal' | 'shares' | 'percent' | 'meal'
  TextColumn get splitType => text()();

  @override
  Set<Column> get primaryKey => {expenseId, memberId};

  @override
  String get tableName => 'expense_splits';
}

class Meals extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  TextColumn get memberId => text().references(Members, #id)();
  IntColumn get date => integer()();
  RealColumn get count => real().withDefault(const Constant(0))();
  RealColumn get guestCount => real().withDefault(const Constant(0))();
  // Display-only breakdown of which meal slots produced `count` (JSON list
  // of slot ids) — set by the auto-fill engine or slot-aware poll results;
  // null for plain manual entries. `count` stays the single number every
  // engine/report/grid actually uses.
  TextColumn get slotsJson => text().nullable()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'meals';
}

class Deposits extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  TextColumn get memberId => text().references(Members, #id)();
  IntColumn get amountPaisa => integer()();
  IntColumn get date => integer()();
  TextColumn get note => text().nullable()();
  // 'meal' | 'general' — which ledger this deposit funds when the group's
  // mealLedgerSeparate is on; irrelevant (ignored) otherwise.
  TextColumn get purpose => text().withDefault(const Constant('general'))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'deposits';
}

class Settlements extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  @ReferenceName('settlementsSent')
  TextColumn get fromMemberId => text().references(Members, #id)();
  @ReferenceName('settlementsReceived')
  TextColumn get toMemberId => text().references(Members, #id)();
  IntColumn get amountPaisa => integer()();
  IntColumn get date => integer()();
  TextColumn get method => text().nullable()();
  TextColumn get note => text().nullable()();
  // 'meal' | 'general' — which ledger this settlement pays down when the
  // group's mealLedgerSeparate is on; irrelevant (ignored) otherwise.
  TextColumn get purpose => text().withDefault(const Constant('general'))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'settlements';
}

class Months extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  TextColumn get yearMonth => text()(); // 'YYYY-MM'
  IntColumn get closedAt => integer().nullable()();
  IntColumn get mealRatePaisa => integer().nullable()();
  TextColumn get snapshotJson => text().nullable()();
  // Independent close state for the meal ledger when mealLedgerSeparate is
  // on. `closedAt`/`snapshotJson` above are then reserved for the
  // rent/other (general) ledger; in combined (non-separate) groups only
  // the general pair is ever used, unchanged from single-ledger behavior.
  IntColumn get mealClosedAt => integer().nullable()();
  TextColumn get mealSnapshotJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'months';
}

class RecurringRules extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  TextColumn get templateJson => text()();
  IntColumn get dayOfMonth => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'recurring_rules';
}

class MealPolls extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  IntColumn get date => integer()(); // day-start ms — which day this poll is FOR
  // 'slots' | 'count' | 'menu' — chosen by the creator (user decision).
  // 'slots' = tick which meal slots (Breakfast/Lunch/Dinner/...) to take.
  TextColumn get type => text()();
  TextColumn get title => text().nullable()(); // the question; required for 'menu'
  TextColumn get optionsJson => text().nullable()(); // 'menu' choices, JSON string list
  IntColumn get closeAt => integer()();
  TextColumn get createdByMemberId => text().references(Members, #id)();
  // null = falls back to groups.defaultNonVoterPolicy. 'routine' | 'pending'
  // | 'zero' | 'repeatYesterday'.
  TextColumn get nonVoterPolicy => text().nullable()();
  BoolColumn get closed => boolean().withDefault(const Constant(false))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'meal_polls';
}

class MealPollVotes extends Table {
  TextColumn get pollId => text().references(MealPolls, #id)();
  TextColumn get memberId => text().references(Members, #id)();
  // {'slotIds': [...]} | {'count': double} | {'optionIndex': int} depending
  // on the poll's type.
  TextColumn get valueJson => text()();
  IntColumn get votedAt => integer()();

  @override
  Set<Column> get primaryKey => {pollId, memberId};

  @override
  String get tableName => 'meal_poll_votes';
}

class MealSlots extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  TextColumn get name => text()(); // canonical fallback; custom slots set freely
  // 'breakfast' | 'lunch' | 'dinner' for the seeded defaults (localized in
  // the UI like categories' defaultKey); null once the admin renames it, or
  // for a slot they created from scratch.
  TextColumn get defaultKey => text().nullable()();
  // How many "meals" this slot counts as — 0.5 for a typical breakfast, 1
  // for lunch/dinner, but fully customizable (user decision).
  RealColumn get weight => real().withDefault(const Constant(1))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'meal_slots';
}

/// A member's standing meal routine: which slots they take, optionally
/// varying by weekday. The auto-fill engine materializes today's meal count
/// from this when nobody has manually set or voted on it yet.
class MemberMealRoutines extends Table {
  TextColumn get id => text()();
  TextColumn get memberId => text().references(Members, #id)();
  TextColumn get slotId => text().references(MealSlots, #id)();
  // 1=Monday..7=Sunday (DateTime.weekday), null = every day.
  IntColumn get weekday => integer().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'member_meal_routines';
}

/// A date-range pause ("going home 20–25th") that overrides the routine to
/// zero for every day in range, inclusive.
class MealLeaves extends Table {
  TextColumn get id => text()();
  TextColumn get memberId => text().references(Members, #id)();
  IntColumn get fromDate => integer()();
  IntColumn get toDate => integer()();
  TextColumn get note => text().nullable()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'meal_leaves';
}

/// A bazar (grocery-shopping) duty assigned to a member for a given day. A
/// roster, not a cost — independent of expenses. The dashboard surfaces the
/// next upcoming duty and the assignee can mark it done.
class BazarDuties extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  TextColumn get memberId => text().references(Members, #id)();
  IntColumn get date => integer()(); // day-start ms
  TextColumn get note => text().nullable()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'bazar_duties';
}

class AuditLog extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();
  // 'create' | 'update' | 'delete'
  TextColumn get action => text()();
  IntColumn get timestamp => integer()();
  TextColumn get diffJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'audit_log';
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};

  @override
  String get tableName => 'settings';
}
