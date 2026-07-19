# MessBook — Next Features Plan (from Mess Manager reference app)

Planned 2026-07-17. Status: **approved for planning only — do NOT implement until the user explicitly says to build a feature.** Each feature is independent; build in any order the user asks. Recommended order if asked "do all": 1 → 2 → 3 → 4 (smallest risk first).

---

## Feature 1 — In-app FAQ / Help screen  (smallest)

**What:** Static help screen answering the questions a first-time mess manager/member actually has, in both languages. Mirrors the reference app's FAQ tab.

**Build:**
- New `lib/ui/screens/help/help_screen.dart`, route `/help`. `ListView` of `ExpansionTile`s (question → answer).
- ~10 Q&As as ARB keys (en + bn): create a mess, add members, what roles/permissions mean, how a member joins by code (sign-in → code → claim identity), meals & polls, how meal rate is calculated, settle up, month close, backup/restore, bring online + invite code sharing.
- Entry points: drawer "App & data" section (`helpTitle`), Settings → new tile under Data.
- No server work, no schema. Verify: gen-l10n → analyze → test.

## Feature 2 — Transfer ownership ("Change manager")  (small-medium)

**What:** One-tap handover of the App Admin role, like the reference app's "মেনেজার পরিবর্তন". Today the admin must manually promote someone and nothing demotes themselves.

**Build:**
- Roles screen (`roles_screen.dart`): new "Transfer ownership" card (App Admin only) → member picker → confirm dialog (explains: they become manager, you become a regular member).
- Client op order matters: promote target to `appAdmin` FIRST (caller still admin), then demote self to `member` — both via existing `MembersRepository.setRole`, then `triggerBackgroundSync`.
- Server: for online messes also transfer `groups.owner_user_id`. New route `POST /groups/:id/transfer-ownership { newOwnerMemberId }` (App-Admin-gated, single transaction: both role updates + owner_user_id if the target member has a linked user_id). Client calls it when `group.isOnline`; offline messes just do the two local role writes.
- After transfer: actingAs stays self (now member) → UI restricts automatically (fail-closed canProvider already handles it).
- ARB: ~6 new keys (en+bn). Verify: analyze/test + node --check; manual: transfer, confirm old admin loses Roles entry, new admin gains it, server 403s old admin on role route.

## Feature 3 — Month lifecycle: "Start new month" with balance carry-forward  (medium)

**What:** The reference app's headline flow: close the running month, optionally carry every member's balance into the new month, history locked read-only.

**Build:**
- Existing foundation: `months` table (closedAt/snapshotJson + meal pair), `isSelectedMonthClosedProvider`, month-close in `month_summary_screen.dart`.
- New "Start new month" screen or sheet (entry: report screen button + drawer Money section): shows current month summary, checkbox "Carry member balances forward" (default on), warning that the closed month becomes read-only (mirror reference: "এডিট করা যাবে না").
- Carry-forward mechanics: for each member with net ≠ 0, insert an opening adjustment **deposit** dated the 1st of the new month (positive net → deposit of +net, negative → −net), note = auto "Carried from <month>" (ARB key). Deposits already sync + flow into balances; no new tables.
- Close both ledgers when `mealLedgerSeparate` (reuse existing close logic), then `selectedMonthProvider.next()`.
- Read-only enforcement: extend existing closed-month guard to block add/edit actions dated inside a closed month (meal grid cells, expense add/edit save, deposit sheet, settlement record) with a snackbar "Month is closed" (ARB). Check each write path once.
- ARB: ~8 keys (en+bn). Verify: analyze/test; manual: close with carry-forward → new month opens with correct opening deposits, old month rejects edits, report still renders.

## Feature 4 — Bazar (shopping) duty roster  (largest — schema on both sides)

**What:** Assign who does bazar on which date, see the next duty on the dashboard, reminder on your day. Reference app has per-member "বাজার তারিখ"; this is net-new functionality for MessBook.

**Build:**
- **Schema (client)**: new Drift table `BazarDuties` (id, groupId→groups, memberId→members, date int, note text?, done bool default false, updatedAt) + schema version bump + migration.
- **Schema (server)**: same table in `db/schema.sql` (FKs, `group_id` index) + add to sync `TABLES` map (group-scoped, has updated_at) in `src/routes/sync.js` — verify camel/snake mapping.
- Repository + providers: `BazarRepository` (watchUpcoming, addDuty single date or repeat-weekly helper, toggleDone, delete), `bazarDutiesOfSelectedGroupProvider`, `nextBazarDutyProvider`.
- UI: new screen `/groups/:id/bazar` (list grouped by date, done checkmarks, FAB add: member + date(s) + note; gate writes behind `mealsManage`), wrapped in `SyncRefreshIndicator`, `triggerBackgroundSync` on every write. Drawer "Daily" entry + dashboard card "Next bazar: <member> · <date>" (tap → screen).
- Reminder: local notification morning-of for the acting member's own duty (reuse `NotificationService` zonedSchedule pattern, new channel `bazar_duty`). FCM push for duty assignment = later, not in v1.
- ARB: ~12 keys (en+bn). Verify: analyze/test, node --check, schema migration on upgrade (existing DB opens clean), two-device sync of a duty.

---

**Standing rules for all four:** offline-first, LWW by updatedAt, ARB parity en+bn, gen-l10n before analyze, no APK build without an explicit "build it", server restart before online testing.
