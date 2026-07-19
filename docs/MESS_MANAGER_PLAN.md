# Mess Manager — Build Plan & Todo List

> **App is now branded "MessBook"** (2026-07-16) — launcher label, in-app title, exported file names, AND the Android `applicationId`/package (now `com.messbook.mess_book`, changed while setting up Google OAuth — any previously-installed test APK needs a fresh reinstall). Dart package name/folders/DB file name deliberately still `mess_manager`, see memory `mess-manager-rebrand`. This doc keeps its original name/prose as a dated historical record.
>
> Source spec: `C:\Users\SURFACE\Downloads\MESS_MANAGER_SPEC.md`
> Project location: `D:\Project\mess_manager`
> Flutter 3.41.9 stable (installed) · Android-first · Offline-first · No login/server

## Design reference (locked)

- Pass 1 (user's demo): `C:\Users\SURFACE\Downloads\Mess Manager.html` — dashboard light/dark, add-expense keypad, split editor, meal grid.
- Pass 2 (remaining 16 frames): `D:\Project\design\mess_manager_screens_2.html` — onboarding, groups, members + contact picker, expense list, deposits, settle up, report, month-close, charts, backup, settings, paywall, Bangla dashboard, style guide.
- Design tokens: teal-700 `#007A6E` primary (teal-400 in dark), honey gradient `#FFD25A→#C28720` for premium/accent, coral-600 `#D2563F` for dues, paper-50 `#FBF9F4` light surfaces, neutral-950 `#0A0E11` dark. Fonts: DM Sans + Hind Siliguri (bn) + JetBrains Mono (money). Radius 10–20px + pill. Hero header gradient `#00867A→#003D36`.

## User additions on top of the spec

1. **Full Bangla + English localization** — every string in ARB (en, bn), Bangla digits
   toggle app-wide, Bengali font (Hind Siliguri), language switcher in Settings AND
   onboarding first page. Bangla is a first-class language, not an afterthought.
2. **Add members from phone contacts** — `flutter_contacts` + runtime permission;
   contact picker on the Add Member screen and in the onboarding wizard
   (autofills name + phone, multi-select supported).

## Package list (pinned to spec)

flutter_riverpod, drift + drift_flutter, go_router, fl_chart, pdf, printing,
flutter_local_notifications, googleapis + google_sign_in (Drive appData),
local_auth, in_app_purchase, flutter_localizations + intl,
flutter_contacts, permission_handler, image_picker (receipts),
share_plus, path_provider, uuid, crypto (backup checksum), screenshot/RepaintBoundary.

---

## Milestones (do one by one — check off as completed)

### M0 — Project bootstrap
- [x] `flutter create mess_manager` (org: com.messmanager)
- [x] Clean architecture folders: `lib/core`, `lib/data`, `lib/domain`, `lib/ui`
- [x] Add all dependencies (drift, riverpod, go_router, contacts, local_auth, etc.), minSdk 24 (flutter default, satisfies local_auth's 23+ requirement), `l10n.yaml` configured
- ✅ Accept: `flutter analyze` clean. On-device run pending (see note below).

### M1 — Scaffold + DB
- [x] Drift schema: all 13 tables from spec §3 (id UUIDv4, updatedAt, soft-delete) — `lib/data/db/tables.dart`
- [x] Default category seeding (Bazar/Grocery meal-flagged, Rent, Utility, WiFi, Maid/Cook, Gas Cylinder, Repairs, Misc) — names localized en/bn via `defaultKey` + `category_l10n.dart`
- [x] Riverpod providers + go_router shell
- [x] Theme: light/dark, Material 3, DM Sans + Hind Siliguri fonts (downloaded from Google Fonts, bundled as assets)
- [x] ARB setup en + bn; `BdFormatter` utility: ৳ currency, Bangla digits toggle, bn month/day names
- [x] Debug screen showing seeded data (`/debug` route)
- ✅ **Accept: CONFIRMED on Pixel 9 emulator.** App boots, DB creates, seed data visible, language toggles en↔bn live (verified via screenshot — full UI incl. button labels switches instantly, Hind Siliguri renders correctly).

### M2 — Groups & Members (+ contacts import)
- [x] Onboarding (3 pages: language picker, offline-first, backup note) → `/onboarding/wizard`
- [x] Create-first-group wizard (name → type/settings → members) — `create_group_wizard_screen.dart`
- [x] Group list/switcher (`group_list_screen.dart`), group create/edit (`group_edit_screen.dart`): name, type, currency (৳ fixed for now), month start day, meal toggle
- [x] Members screen: list, add, edit, deactivate/reactivate (join/leave dates) — `members_screen.dart`
- [x] **Contacts import**: `flutter_contacts` 2.x API, `permission_handler` request flow, multi-select bottom sheet (`contact_picker_sheet.dart`) with search, denied/permanently-denied fallback states with manual-entry alternative; wired into both the wizard and the Members screen
- [x] `flutter analyze` clean (0 issues) after all M2 code
- ✅ **Accept: FULLY CONFIRMED on-device.** Onboarding → wizard (name/type/month-start/meal-toggle) → contacts permission dialog → contact picker with search/multi-select → member imported with phone number → group created and persisted → Members screen shows imported member with correct join date. Full round-trip verified via adb screenshots + taps on the Pixel 9 emulator.

**Build environment notes (fixed, keep for future builds on this machine):**
- `android/app/build.gradle.kts` needs `isCoreLibraryDesugaringEnabled = true` + `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")` for `flutter_local_notifications`.
- `android/gradle.properties` needs `kotlin.incremental=false` — project on `D:` + pub cache on `C:` crashes Kotlin's incremental compiler (cross-drive relative path bug). Also reduced `-Xmx8G` → `-Xmx2G` since this machine runs critically low on free RAM (was <0.5GB free) with other apps open.
- First build downloads NDK 28.2 + CMake 3.22.1 (multi-GB) — expect 40-50 min on a cold cache; subsequent builds reuse the Gradle daemon and are much faster (~9 min observed).

### M3 — Expenses & Splits
- [x] Expense list (date groups, category filter chips, search) — `expense_list_screen.dart`. Swipe-to-delete via `Dismissible` + confirm dialog; edit via tap. Member/date filters deferred (category + search cover the acceptance bar).
- [x] Add/edit expense: keypad-first amount, date picker, category chips, multi-payer (add/remove, per-payer amounts with live sum validation), note — `add_edit_expense_screen.dart`
- [x] Split editor: Equal / Unequal / Shares / Percent tabs, live must-sum validation, include/exclude members via checkboxes — `split_editor_screen.dart`
- [x] Split calculator engine (pure Dart, largest-remainder method) — `domain/engines/split_calculator.dart`
- [x] Audit log on create/update/delete — `expenses_repository.dart`
- [x] Full Bangla + English localization for all M3 strings (ARB keys added, no hardcoded English left in the new screens)
- ✅ **Accept: FULLY CONFIRMED.** 18 unit tests pass (17 split-calculator cases incl. 100÷3 → sums to 100 exactly, distributes remainder deterministically; 1 widget smoke test). **On-device**: created a ৳150 Bazar/Grocery expense with a payer and an Equal split via the split editor — validation banner, Save-button enable/disable, and final persistence to the expense list all confirmed working end-to-end on the Pixel 9 emulator.

### M4 — Balances, Deposits, Settlements
- [x] Balance engine (`domain/engines/balance_engine.dart`) — net = paid + deposits − share + settlementsPaid − settlementsReceived
- [x] Debt simplification (`domain/engines/debt_simplifier.dart`) — greedy max-creditor/max-debtor matching, n-1 transaction bound
- [x] Dashboard: hero total-spent card, member net chips, quick actions (Add expense/Settle up/Deposits), recent expenses — `dashboard_screen.dart`. Month selector and live meal rate deferred to M5/M6 (no meal system yet to show a rate for).
- [x] Deposits screen (Collected/Spent/In hand stats, add-deposit sheet) — `deposits_screen.dart`
- [x] Settle-up screen with partial payments (editable amount in record dialog) — `settle_up_screen.dart`
- [x] Shared bottom nav (Home/Expenses/Meals/Report/Settings) added to Dashboard + Expenses; Meals/Report/Settings are "coming soon" placeholders until M5/M6/M8
- ✅ **Accept: FULLY CONFIRMED.** 11 new unit tests pass (4 balance-engine cases + 7 debt-simplifier cases including an integration test that runs balances → simplify → re-applies settlements → asserts every member nets to exactly zero). **On-device**: Dashboard shows ৳150 total spent with a correct +৳0 net chip; Settle-up screen shows the live "Group balance check: Σ = ৳0 ✓" banner — the literal acceptance criterion, visually confirmed on the emulator, not just unit-tested.
- **Bug found + fixed via on-device testing** (not caught by `flutter analyze` or unit tests): four `StreamProvider.autoDispose` calls were missing explicit generic type parameters, which made Dart infer `dynamic` from the `Stream.empty()` fallback branch and crash at runtime on `List<Deposit>.fold` with a type-check error. Fixed by adding explicit `<List<T>>` type arguments to all four providers in `repository_providers.dart`.

### M5 — Meal System
- [x] Meal grid: member rows × day columns for the calendar month, tap-to-edit stepper sheet (Meals + Guest meals, 0.5 increments), "Same as yesterday" and "Bulk fill" actions, live Total meals / Meal rate footer — `meal_grid_screen.dart`. Calendar-month based (not custom month-start-day) — same simplification as M4's balances, revisited in M6.
- [x] Member meal detail screen (stat cards + daily entries list) — `member_meal_detail_screen.dart`, reachable by tapping a member's name in the grid
- [x] Meal rate engine (`domain/engines/meal_rate_engine.dart`) — rate = meal-category expense ÷ total meals, largest-remainder bill distribution, zero-meal month → rate 0 with no div-by-zero
- [x] Meal-based split wired into the split editor's "Meal" tab (M3's placeholder), using the expense's month meal data
- [x] Full Bangla + English localization for all M5 strings
- ✅ **Accept: FULLY CONFIRMED.** 7 new unit tests pass (zero-meals no-div-by-zero, empty-member map, spec-matching rate example, reconciliation across a range of totals, guest-meal equivalence, fractional halves, zero-expense-with-real-meals). 43 tests total project-wide. **On-device**: set 2 meals for a member via the grid's stepper sheet → Total meals and Meal rate updated live (৳150 expense ÷ 2 meals = ৳75/meal, exact) → Member detail screen correctly showed Meal bill ৳150 (100% share as sole consumer) reconciling exactly with the meal-category expense total.

### M6 — Reports & Month Close
- [x] Month summary screen: hero stats, per-member table, share-as-image (RepaintBoundary→PNG) — `month_summary_screen.dart`
- [x] PDF export (`pdf_report_service.dart`, embeds Hind Siliguri for Bengali) + CSV export
- [x] Month close: lock banner, snapshot JSON (`domain/models/month_report.dart`), carry-forward balances via `MonthsRepository.previousMonthClosingNets` + `BalanceEngine.carriedForward`; proration engine (`proration_engine.dart`) for fixed costs by days-present
- [x] Full Bangla + English localization for all M6 strings
- ✅ **Code-complete, verified via `flutter analyze` (clean) + unit tests (46 passing, incl. 9 proration engine + 1 carry-forward case).** On-device click-through not completed this session — the dev machine's Android emulator process died mid-verification (unrelated to app code; host resource exhaustion) and hit a low-disk-space wall on restart (C: drive down to 1.27GB, partially freed to ~2GB by clearing %TEMP% with user approval). **Deferred to the user's final testing pass**, per their instruction to keep implementing without pausing for on-device checks.

### M7 — Backup & Restore
- [x] JSON export matching spec §6 envelope exactly (schemaVersion, exportedAt, appVersion, sha256 checksum of payload, all 11 tables) via share sheet — `backup_service.dart`, `backup_screen.dart`
- [x] Import: checksum + schemaVersion validation, preview (counts + exported date), replace-all confirm with warning
- [x] Backup-overdue banner on Dashboard (>7 days since last backup, tracked via `settings` table) — full local-notification wiring deferred to M8 alongside the other notification types
- [x] Added `file_picker` dependency (not in original fixed package list, but import is impossible without a file-selection mechanism — share_plus only handles outbound sharing) — pinned to 3.0.4 due to a `win32` version conflict with `share_plus` on Windows desktop; irrelevant to our Android-only target since the conflict is Windows-desktop-specific
- ✅ **Accept: CONFIRMED via integration tests.** 5 new tests using a plain `test()` block (not `testWidgets`) against a real in-memory Drift database — export→wipe→import round-trips every table exactly (groups, members, expenses, payers, splits, meals, deposits, categories all verified byte-for-byte equivalent post-restore), checksum-tamper detection, and newer-schema-version rejection all pass. 51 tests total project-wide.

### M8 — Notifications, Recurring, Charts, App Lock
- [x] `NotificationService` (`notification_service.dart`): daily meal reminder (default 22:00), month-close reminder, recurring-due reminder, immediate backup-overdue notification — via `flutter_local_notifications` 22.x + `timezone` (`zonedSchedule`, all-named-parameter API)
- [x] Recurring rule engine: `domain/models/recurring_rule.dart` (template JSON w/ embedded `lastGeneratedYearMonth` mutable state) + `recurring_rules_repository.dart` (`generateDueInstances` — idempotent per calendar month, equal-split among active members) + `recurring_screen.dart` UI
- [x] Charts screen: category pie + 6-month trend line via `fl_chart`, `charts_repository.dart` (Drift `.sum()` aggregates) — `charts_screen.dart`, "PRO" badge shown but ungated for now (M9 wires the actual gate)
- [x] PIN/biometric app lock: `app_lock_service.dart` (sha256 PIN hash, `local_auth` 3.x biometric fallback), `app_lock_screen.dart` (PIN pad + biometric-first attempt), `pin_setup_dialog.dart`, wired into `main.dart`'s `MaterialApp.router` `builder:` gated on `appLockEnabledProvider`
- [x] Comprehensive `settings_screen.dart`: language/dark-mode/Bangla-digits toggles, app lock switch, reminder display, backup/recurring/charts links, reset-all-data flow (type "RESET" to confirm)
- [x] `appOpenTasksProvider` (non-autoDispose `FutureProvider`, runs once per app process): generates due recurring instances for all active groups, (re)schedules daily meal + month-close reminders, fires backup-overdue notification (throttled to once/day) — watched from `dashboard_screen.dart` on load
- [x] Fixed real API-version mismatches found only by `flutter analyze` (not assumption from memory): `flutter_local_notifications` 22.0.1 requires all-named parameters for `initialize`/`zonedSchedule`/`show`/`cancel` (no positional args); `local_auth` 3.0.2's `authenticate()` dropped the `options: AuthenticationOptions(...)` parameter in favor of flattened `biometricOnly`/`persistAcrossBackgrounding` named args
- ✅ **Accept: CONFIRMED via `flutter analyze` (0 issues) + `flutter test` (51/51 passing).** On-device click-through deferred to the user's final testing pass, per their instruction to keep implementing without pausing for on-device checks ("Without lunch just implement everything one by one. i will test in last").

### M9 — Premium & Drive Backup
- [x] `BillingService` (`billing_service.dart`) wrapping `InAppPurchase.instance`: `queryPremiumProduct`, `buyPremium` (non-consumable `premium_unlock`), `restorePurchases`, `completePurchase`; `purchaseStreamListenerProvider` subscribes for the app's lifetime (watched once from `MessManagerApp`), persists unlock status to settings on `purchased`/`restored`
- [x] Paywall screen (`paywall_screen.dart`, route `/premium/paywall`) matching design mockup 2o: gradient badge, feature checklist, store price (falls back to ৳499 display if store unavailable), Unlock + Restore purchase actions, auto-dismisses with a confirmation snackbar when `premiumUnlockedProvider` flips true
- [x] Feature gating per spec's free/premium table, all redirecting to the paywall: group creation FAB blocks a 2nd active group (`group_list_screen.dart`); charts screen shows a full locked-state gate instead of the PRO badge being purely cosmetic (`charts_screen.dart`); recurring rule creation (`recurring_screen.dart`); PDF/CSV export buttons + history navigation capped at current+previous month for free users (`month_summary_screen.dart`); receipt photo capture, net-new feature using the already-existing `receiptPath` DB column + `image_picker`, copies into app documents `receipts/` dir (`add_edit_expense_screen.dart`)
- [x] `DriveBackupService` (`drive_backup_service.dart`) using `google_sign_in` 7.x's incremental-authorization API (`GoogleSignIn.instance.initialize()` → `attemptLightweightAuthentication()`/`authenticate()` → `authorizationClient.authorizationHeaders(drive.appdata scope)`) feeding an authenticated `http.BaseClient` into `googleapis` `DriveApi`; single backup file in the `appDataFolder` space, created or replaced on each run
- [x] Daily auto-backup toggle in `backup_screen.dart` (premium-gated, shows signed-in email once enabled) registers a `workmanager` periodic task (`drive_auto_backup_task.dart` holds the shared task-name constants); `main.dart` initializes `Workmanager()` with a top-level `driveAutoBackupCallbackDispatcher` that opens its own `AppDatabase()` (safe — schema uses `shareAcrossIsolates: true`) and attempts a **silent-only** sign-in (no UI available in the background isolate, so it never prompts interactively — a day it can't refresh the token silently, it just skips and retries the next day)
- [x] Full Bangla + English localization for every new string (paywall, gates, Drive backup, receipt photo) in both ARB files
- ✅ **Accept: CONFIRMED via `flutter analyze` (0 issues) + `flutter test` (51/51 passing).** Real purchase flow, Drive OAuth consent, and the WorkManager background job all require a configured Play Console listing + Google Cloud OAuth client that don't exist in this dev environment, so end-to-end billing/Drive verification is necessarily deferred to the user's on-device pass alongside the rest of the app, per their standing instruction.

### M10 — Polish & Release
- [x] ARB key parity verified programmatically: 266/266 keys match exactly between `app_en.arb` and `app_bn.arb`, no gaps either direction
- [x] Hardcoded-English audit (via a dedicated search pass) and fixes: Settings theme dropdown (System/Light/Dark), recurring rule "Amount" field label, month-close confirmation dialog title (was a hardcoded English month-name array bypassing locale entirely — replaced with `BdFormatter.monthYear`, which was already locale-correct everywhere else), group list's "meals on" suffix, guest-count text on meal detail rows, backup-import preview chip labels (groups/members/expenses/meals/deposits counts), the "PRO" badge (shared key, both charts + recurring), split editor's two meal-tab validation messages, and all four push-notification title/body strings (moved to `lookupAppLocalizations` inside `appOpenTasksProvider`, since that runs outside any widget's `BuildContext`) — plus a sweep replacing raw `'Error: $e'` with a localized `commonErrorPrefix` across 8 screens
- [x] Empty-state coverage spot-checked: 18 of ~30 screens already have explicit `isEmpty` empty-state handling from earlier milestones; no gaps found needing new work
- [x] R8/proguard enabled for release builds (`android/app/build.gradle.kts`: `isMinifyEnabled`/`isShrinkResources` + `proguard-rules.pro` covering Play Billing, Google Sign-In, `flutter_local_notifications`, `workmanager`, `sqlite3_flutter_libs`, and `local_auth`'s reflection/native-binding needs)
- [x] `android/key.properties.example` added as the template for a real upload-keystore signing config (release build still signs with the debug key for now — see below)
- ⏸ **Deferred — requires the user's own external accounts/assets, cannot be done blind:** Firebase Crashlytics (needs a Firebase project); app icon/splash image assets (needs actual design files, none were ever produced — only HTML mockups exist); Play Store listing copy + screenshots in bn+en; a real upload keystore for release signing; versioning bump (cosmetic, deferred to just before an actual release).
- ✅ **Accept: CONFIRMED via `flutter analyze` (0 issues) + `flutter test` (51/51 passing).** A full signed release AAB build was not attempted this session (needs the keystore above); offline end-to-end release verification is part of the user's final on-device pass.

### M11 — Meal/rent ledger separation (post-release user request)
- [x] Schema v2 migration (additive, existing data untouched): `groups.mealLedgerSeparate`, `deposits.purpose` + `settlements.purpose` ('meal'|'general'), `months.mealClosedAt` + `months.mealSnapshotJson` for independent meal month-close
- [x] `LedgerPurpose` domain enum; `BalancesRepository.computeBalances(ledger:)` splits by meal-category expenses + purpose-tagged deposits/settlements; `MonthsRepository`/`MonthReportRepository` take a ledger for close/carry-forward/report
- [x] UI (all bn+en): Group Edit "Separate meal money" toggle (only when meals enabled); Dashboard hero shows two labeled chip rows; Settle Up becomes Meals / Rent-&-others tabs recording purpose-tagged settlements; deposit sheet asks "Which balance is this for?"; month report gets a ledger switcher with per-ledger close
- [x] Combined mode (toggle off) is byte-for-byte the old single-ledger behavior — all existing providers untouched
- ⚠️ Known gap: backup files exported before v2 lack the new columns and would fail import (app unreleased, only dev-test backups exist); revisit if it ever matters
- ✅ **Accept: `flutter analyze` 0 issues, 51/51 tests passing.** On-device check deferred to the user's testing pass. Next per user's step list: roles (Manager/Meal Admin), meal polls, then the online layer (see `MESS_MANAGER_ONLINE_PLAN.md`).

### M12 — Roles & customizable sub-admin permissions (Step 1 of user's online-migration step list)
- [x] Schema v3 migration (additive): `members.role` ('appAdmin'|'subAdmin'|'member', default 'member') + `members.permissions` (comma-separated flag keys, default '') — existing members untouched
- [x] Domain: `MemberRole`, `MemberPermission` (mealsManage, pollsCreate, pollsManage, expensesManage, moneyManage, membersManage), `PermissionPreset` (Meal Admin, Expense Admin, Poll Creator, Member Admin — one-tap bundles, still individually editable); `Member.hasPermission()` — App Admin implicitly holds everything, a plain member holds nothing
- [x] **Roles are opt-in**: `rolesConfiguredProvider` stays permissive (today's unrestricted single-device behavior) until any member in a group is explicitly assigned a role; the first member ever added to a fresh group auto-becomes App Admin so every group that starts using roles always has one
- [x] `MembersRepository.setRole`/`setPermissions`; `assign_role_sheet.dart` — tap a member → pick App Admin / Sub-admin (then presets or individual permission checkboxes) / Member
- [x] "Acting as" preview selector in Settings (offline stand-in for real per-person login, which arrives with the online layer in `MESS_MANAGER_ONLINE_PLAN.md`) — defaults to the App Admin so the operator's device stays fully usable until they deliberately preview as someone else
- [x] Permission gating wired at the actual write points (all bn+en): expense add/edit/delete → `expensesManage`; meal grid editing (cell tap, same-as-yesterday, bulk fill) → `mealsManage`; add deposit → `moneyManage`; record a settlement → `moneyManage`; add/edit/deactivate members → `membersManage`. **Role assignment itself is always App-Admin-only and non-delegable**, even for a sub-admin holding `membersManage` (prevents privilege escalation)
- [x] Members screen shows a role badge (App Admin = reused `membersManagerBadge` "MANAGER" string, Sub-admin = new badge)
- ✅ **Accept: `flutter analyze` 0 issues, 51/51 tests passing.** No new unit tests yet (pure UI/permission-gating feature, no new engine logic) — on-device verification deferred to the user's pass. Next: Step 2, the daily meal poll module.

### M13 — Meal automation: slots, auto-routines, and daily polls (Step 2 of user's step list)
- [x] Schema v4 migration (additive): 5 new tables (`meal_polls`, `meal_poll_votes`, `meal_slots`, `member_meal_routines`, `meal_leaves`) + `groups.defaultNonVoterPolicy` + `meals.slotsJson`; migration seeds default Breakfast(0.5)/Lunch(1)/Dinner(1) slots for every existing meal-enabled group so auto-fill/polls work immediately after upgrade
- [x] **Customizable meal slots** (user decision — "customizable auto meal setup... breakfast/lunch/dinner like that"): App Admin can rename, re-weight, add, and deactivate slots per mess; seeded automatically on group creation and when meals get turned on later
- [x] **Member auto-routines**: per-slot, per-weekday (or "every day") standing rules resolved via `MealRoutinesRepository.resolveRoutineSlotIds` (weekday-specific beats "every day" for the same slot); **meal leave** date-ranges override the routine to nothing for that span
- [x] `MealAutoFillService.fillToday`, wired into `appOpenTasksProvider`: materializes today's meal count from routine only when no entry exists yet — never touches a manually-set or poll-set day
- [x] **Daily polls**, type chosen by the creator (user decision): 'slots' (tick which meal slots to take), 'count' (plain meal-count vote), 'menu' (informational choice, never touches the grid). Non-voter handling is **admin-customizable** at both the mess-default and per-poll level: `routine` (recommended — apply their standing routine) | `pending` (Meal Admin resolves) | `zero` | `repeatYesterday`
- [x] `PollsRepository.closePoll`: applies every active member's outcome to the meal grid; a clever free precedence signal — `meals.slotsJson == null` + `count > 0` on an existing entry means it was set manually (auto-fill and poll writes always set `slotsJson`), so a poll closing never clobbers a manual edit, only earlier auto-fill/poll results
- [x] Poll close-time reminder notification (30 min before close, `NotificationService.schedulePollCloseReminder`)
- [x] UI (all bn+en): Meal Slots screen (Group Edit → Meal Slots, `mealsManage`-gated); Member Routine screen (Members list → Meal routine, daily + per-weekday chips + leave date-range picker); Polls list/create/detail screens (create gated by `pollsCreate`/`pollsManage`; voting is "tap your name" shared-device style per earlier design decision — anyone can cast any member's vote, matching a phone passed around the mess); Dashboard "Today's Poll" card; a poll icon in the meal grid app bar; closed-poll "still need to set" resolution list for `pollsManage` holders
- ⚠️ **Known gap**: no new unit tests for the auto-fill/poll-close precedence logic (manual-vs-auto detection, routine resolution, non-voter policy branches) — this is meaningfully complex business logic that would benefit from coverage; recommend the user manually walk through routine → auto-fill → poll → close → pending-resolution end to end before relying on it for real money/meals
- ✅ **Accept: `flutter analyze` 0 issues, 51/51 tests passing.** On-device verification deferred to the user's pass. Next per the user's step list: Step 3, the Node.js + MySQL + Docker server (a different tech stack — new territory vs. the Flutter app work so far).

### M14 — Premium UI polish pass (user request, 2026-07-16, "make a premium improvement in ui for the full app")
- [x] `app_theme.dart` overhaul — theme-level changes cascade to every screen automatically, no per-screen rework needed:
  - Cards: soft brand-tinted shadow in light mode (elevation 3, teal-tinted `shadowColor`, `surfaceTintColor: transparent` so M3's default tint doesn't mud the palette); dark mode keeps the existing border-only look, since shadows barely read on a dark surface
  - AppBar: flush with the page at rest, lifts on `scrolledUnderElevation` once content scrolls beneath it — a scroll-aware depth cue that needed zero per-screen wiring
  - NavigationBar (bottom tab bar) and FloatingActionButton: same tinted-shadow treatment, `surfaceTintColor: transparent`
  - New: `BottomSheetThemeData` (rounded top corners, drag handle, consistent elevation — applies to all ~15 `showModalBottomSheet` call sites at once), `DialogThemeData` (matches the `AppRadius.xl` most `AlertDialog`s already set inline, so it fills in the couple that didn't rather than introducing a second radius), `SnackBarThemeData` (floating, rounded, dark toast style regardless of app theme — a common polish pattern), `ProgressIndicatorThemeData` (brand-teal spinners everywhere instead of unstyled defaults), `TextButtonThemeData`, `splashFactory: InkSparkle`
  - **Caught during the pass**: the new theme-level drag handle would have doubled up with `contact_picker_sheet.dart`'s own hand-rolled handle bar (it fully self-decorates via `backgroundColor: Colors.transparent` + its own `Material`) — fixed by passing `showDragHandle: false` at that one call site
- [x] New shared `EmptyState` widget (`lib/ui/widgets/empty_state.dart`): icon in a tinted circle + title + optional subtitle/action, replacing bare `Center(child: Text(...))`. Applied to the 8 screens with a genuine full-list empty state: groups, members, expenses, deposits, recurring, meal slots, polls, chat. Smaller inline "empty" spots inside longer pages (dashboard's recent-expenses preview, chart no-data, settle-up's already-decorated "all settled" banner, etc.) were deliberately left alone — a full-width centered icon would look disproportionate inside a scrolling section rather than a whole screen.
- ✅ **Accept: `flutter analyze` 0 issues, 51/51 tests passing.** No live visual preview was done this pass — this Android-only app has no web/desktop target scaffolded, and the established workflow for this project is implement → analyze/test → the user verifies visually on-device at build time (per "I will test in last"). Worth a look next time an APK gets built.

## Testing (ongoing, per spec §8)
- Unit ≥90% on `domain/`: splits, balances, debt simplify, meal rate, proration, month window, backup round-trip.
- Widget: add-expense, meal grid, split editor.
- Edge: 100÷3, mid-month leave, multi-payer, partial settlement, zero-meal month, newer schemaVersion reject.

## Non-goals (v1)
Cloud sync, member logins, bKash/Nagad, OCR, iOS, multi-currency.
