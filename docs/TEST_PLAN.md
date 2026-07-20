# MessBook — Manual Test-Case Matrix

> Script for on-device/emulator click-through testing, organized to mirror the
> build milestones in `MESS_MANAGER_PLAN.md`. Not executed as part of the
> 2026-07-19/20 automated-test pass — written now, run later once a working
> Android device or emulator is available. Each row is golden path unless
> marked **Edge**.

## Sign-in & account (blocking issue as of 2026-07-20)

- [ ] Fresh install → tap "Sign in with Google" → Google account picker appears → completes without `DEVELOPER_ERROR`
- [ ] Signed-in state persists across app restart
- [ ] Sign out → app remains fully usable offline (no feature regresses)
- [ ] **Edge**: sign-in with no internet → clear error, not a silent hang

## Onboarding (M2)

- [ ] Fresh install → language picker (en/bn) → offline-first info → backup note → role fork
- [ ] "I manage a mess" → create-group wizard
- [ ] "I'm joining a mess" → requires sign-in first if not signed in → invite-code join screen
- [ ] "Already have a mess? Sign in to restore it" link (new, 2026-07-20): signs in → local groups populated automatically if the account owns/joined any online mess → routes to `/groups`
- [ ] **Edge**: restore link tapped with an account that owns zero online messes → snackbar "No mess found", stays on onboarding
- [ ] Bangla digits/font toggle applies instantly app-wide

## Groups & members (M2)

- [ ] Create-group wizard: name → type/month-start/meal-toggle → members
- [ ] Add member manually; add member via contacts picker (search, multi-select)
- [ ] **Edge**: contacts permission denied → manual-entry fallback still works
- [ ] Deactivate/reactivate a member; join/leave dates recorded correctly
- [ ] Group edit: currency symbol, month start day, meal toggle, "Separate meal money" toggle (only visible when meals enabled)

## Expenses & splits (M3)

- [ ] Add expense: keypad amount entry, date picker, category chips, note
- [ ] Multi-payer expense with live sum validation
- [ ] Split editor: Equal / Unequal / Shares / Percent / Meal tabs, must-sum validation, include/exclude members
- [ ] **Edge**: 100 ÷ 3 split sums to exactly 100 (largest-remainder distribution)
- [ ] Edit an existing expense; swipe-to-delete with confirm dialog
- [ ] Expense list: category filter chips, search
- [ ] Receipt photo capture/attach (premium-gated)

## Balances, deposits, settlements (M4)

- [ ] Dashboard hero card + member net chips match manual calculation
- [ ] Add deposit; Deposits screen stats (Collected/Spent/In hand)
- [ ] Settle-up: full and partial payment, "Group balance check: Σ = ৳0" banner after full settlement
- [ ] Debt simplification produces ≤ n−1 transactions and everyone nets to zero after applying them

## Meal system (M5, M13)

- [ ] Meal grid: tap-to-edit stepper (0.5 increments), guest meals, "Same as yesterday", "Bulk fill"
- [ ] Meal rate footer updates live as entries change; zero-meal month shows rate 0, no crash
- [ ] Meal Slots screen: rename/re-weight/add/deactivate a slot
- [ ] Member Routine screen: per-slot per-weekday rule + "every day" rule + meal-leave date range
- [ ] **Edge**: weekday-specific rule wins over "every day" for the same slot on that day
- [ ] **Edge**: an active meal-leave date range zeroes the routine for that span
- [ ] Create a poll (slots/count/menu type), vote as multiple members ("tap your name"), close poll
- [ ] **Edge**: closing a poll never overwrites a day that was set manually or by auto-fill already
- [ ] Non-voter policy (routine/pending/zero/repeatYesterday) applied correctly to members who didn't vote
- [ ] Poll close-time reminder notification fires ~30 min before close

## Reports & month close (M6)

- [ ] Month summary: hero stats, per-member table, share-as-image
- [ ] PDF export renders Bangla text correctly (Hind Siliguri embedded); CSV export opens cleanly
- [ ] Month close: lock banner, carry-forward balances into next month, closed month rejects new edits
- [ ] Separate-ledger groups: independent close per ledger (meal vs general)

## Backup & restore (M7)

- [ ] Export → share sheet → produces a valid JSON envelope
- [ ] Import: preview (counts + date) → replace-all confirm → data matches exactly
- [ ] **Edge**: tampered checksum rejected; newer `schemaVersion` rejected with a clear message
- [ ] Backup-overdue banner appears after 14+ days since last backup

## Notifications, recurring, charts, app lock (M8)

- [ ] Daily meal reminder fires at the configured time
- [ ] Recurring rule generates a due instance once per calendar month, not duplicated on repeat app-opens
- [ ] Charts: category pie + 6-month trend render correctly; premium gate shows for free users
- [ ] PIN setup + biometric-first unlock; wrong PIN rejected; app lock persists across restart

## Premium & Drive backup (M9)

- [ ] Paywall screen shows correct price / unlock flow (store-dependent — may be untestable without Play Console)
- [ ] Restore purchases works after reinstall
- [ ] Drive auto-backup: enable → daily backup runs silently in background; a day it can't silently refresh just skips (no crash, no interactive prompt)

## Roles & permissions (M12)

- [ ] First member added to a fresh group auto-becomes App Admin
- [ ] Assign Sub-admin with a preset (Meal Admin / Expense Admin / Poll Creator / Member Admin) and with individual permission toggles
- [ ] A member without a permission cannot see/use the gated action (expense add/edit, meal grid edit, deposit, settlement, member management)
- [ ] Role assignment itself is App-Admin-only, even for a sub-admin holding `members.manage`
- [ ] "Acting as" preview selector in Settings switches which permissions apply locally

## Online: sync, join, chat, live update (M9/M11 online plan + 2026-07-19 realtime work)

- [ ] Bring a mess online → invite code minted → visible on Group Online screen
- [ ] Join by invite code: "is this you?" identity match against unclaimed members, or add as new
- [ ] Two devices, same online mess: an edit on device A appears on device B within ~1s (live `dataChanged` nudge), not just after the 15s fallback timer
- [ ] Chat: send/receive messages live via Socket.IO; history loads via REST pagination
- [ ] Push notification for a new chat message when the recipient's app is backgrounded/killed
- [ ] Transfer ownership: old admin loses Roles access, new admin gains it, both roles updated atomically
- [ ] **Edge**: kill WiFi mid-session → app stays fully usable offline; reconnect triggers a catch-up sync
- [ ] Expired mess (`paid_until` past) flips read-only; existing data stays visible

## Bazar duty roster (MESSBOOK_NEXT_FEATURES_PLAN Feature 4, if built)

- [ ] Assign a bazar duty to a member/date; dashboard shows "Next bazar: <member> · <date>"
- [ ] Reminder notification on the assigned member's duty day
- [ ] Two-device sync of a duty (if online)

## Localization

- [ ] Every screen touched above renders correctly in both English and Bangla, no leftover hardcoded English strings
- [ ] Bangla digit toggle applies to all currency/date displays consistently
