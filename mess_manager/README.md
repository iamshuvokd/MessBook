# mess_manager (MessBook)

The Flutter app behind **MessBook** — see the [repo root README](../README.md)
for a feature overview. This package still uses its original `mess_manager`
name/folders/DB file internally; only the app's branding (launcher label,
in-app title, Android `applicationId`) changed to "MessBook".

- **Platform**: Android-first, offline-first (no login required for local
  use). Flutter 3.41+ stable.
- **Architecture**: layered/clean — `lib/core` (theme, l10n, shared utils),
  `lib/data` (Drift/SQLite DB, repositories, services), `lib/domain`
  (pure business logic: split/balance/meal-rate/proration engines, models),
  `lib/ui` (Riverpod providers, go_router, screens, widgets).
- **State management**: `flutter_riverpod`. **DB**: `drift` (SQLite).
  **Routing**: `go_router`. **Localization**: `flutter_localizations` + ARB
  (English + Bangla, full parity enforced).

## Running locally

```sh
flutter pub get
flutter run
```

Online sync/chat features (optional — the app is fully usable without them)
need the companion server running and `apiBaseUrl` pointed at it from the
Account screen; see the server's own README for setup.

## Verifying changes

```sh
flutter analyze   # must stay clean
flutter test      # unit + widget tests
```

## Project layout

```
lib/
  core/       theme, localization (ARB), shared formatting/lookup utils
  data/
    db/           Drift schema + generated code
    repositories/ one per domain table, wraps Drift queries as streams/futures
    services/     cross-cutting: sync, auth, backup, notifications, chat, realtime, billing
  domain/
    engines/    pure-Dart business logic (splits, balances, meal rate, proration, debt simplification)
    models/     domain value types
  ui/
    providers/  Riverpod wiring (repository providers, app-level state)
    router/     go_router route table
    screens/    one folder per feature area
    widgets/    shared, reusable widgets
test/           mirrors lib/ for unit + widget tests
```
