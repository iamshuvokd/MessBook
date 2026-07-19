# MessBook

An offline-first shared-housing ("mess") manager for tracking expenses, meals,
deposits, and settlements among roommates — bilingual (English/বাংলা) from the
ground up.

## What it does

- **Expenses & splits** — equal, unequal, by shares, by percent, or by meal
  count, with multi-payer support and a full audit log.
- **Meal system** — a daily meal grid, per-member auto-fill routines, meal
  slots (breakfast/lunch/dinner, fully customizable), and daily voting polls.
- **Balances & settlements** — automatic debt simplification (minimum
  transactions to settle up), partial settlements, deposit tracking.
- **Roles & permissions** — App Admin / Sub-admin with granular, per-duty
  permission grants (meals, polls, expenses, money, members).
- **Reports** — monthly close with balance carry-forward, PDF/CSV export,
  shareable summary images.
- **Backup & sync** — local JSON backup with checksum verification, optional
  Google Drive auto-backup, and an optional online layer (accounts, invite
  codes, multi-device sync, live chat) that the app never depends on — every
  feature works fully offline.
- **Live updates** — expense/meal/deposit changes and chat push over
  Socket.IO the moment another device syncs, backed by Redis for cross-instance
  broadcast on the server.

## Structure

```
mess_manager/   Flutter app (Android-first) — see mess_manager/README.md
docs/           Build plans and design decisions, kept as a dated record
```

The companion sync/chat server (Node.js + Express + MySQL + Socket.IO +
Redis) lives in a separate repository, since it's an independently deployed
service, not part of the app build.

## Getting started

See [`mess_manager/README.md`](mess_manager/README.md) for build/run
instructions.

## Docs

The `docs/` folder holds the running build plans this project was developed
against — useful as a history of what was built and why, not required reading
to use or contribute to the app.
