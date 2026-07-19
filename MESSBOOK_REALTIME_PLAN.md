# MessBook — Realtime (Socket.IO) + Redis + Account Restore Plan

Planned 2026-07-19. Status: **plan approved for later execution — do NOT build until the user says go.**
Goal: (A) true sub-second live updates for ALL mess data (not just chat), (B) Redis on the server for faster hot-path loads and multi-instance readiness, (C) sign-in with the same Gmail on any phone restores every online mess automatically — zero perceived data loss.

Current foundation this builds on (verified in code):
- Socket.IO already runs for chat (`src/chat/socket.js`): JWT handshake auth, `group:<id>` rooms, membership re-checked server-side on `joinGroup`.
- Client sync is REST push/pull with server-clock cursors + one-time self-heal; `foregroundGroupSyncProvider` polls (pull-only) every 15s while a group screen is open.
- `GET /groups` on the server already returns every group the caller owns or is a member of; `GroupsRepository.upsertFromRemote` + `SyncService.pullGroup` already exist client-side.

---

## Phase R1 — Server: broadcast "something changed" over Socket.IO

1. **Extract the io instance** into `src/realtime.js` (module-level holder set by `attachSocketServer`), exporting `emitGroupChanged(groupId, tables)` → `io.to('group:' + groupId).emit('groupChanged', { groupId, tables, at: Date.now() })`. No payload data — it's a doorbell, not a data channel; clients react by pulling, so LWW/conflict logic stays exactly where it is.
2. **Emit after every server-side write:**
   - `sync/push` (only when ≥1 row was accepted; pass the changed table names),
   - role PATCH, transfer-ownership, member delete, and the join route (alongside the existing FCM `memberJoined` push, which stays as the backgrounded-app fallback).
3. Chat is untouched (already realtime).

## Phase R2 — Client: one persistent socket that triggers instant pulls

4. **New `RealtimeSyncService`** (`lib/data/services/realtime_sync_service.dart`, reusing `socket_io_client` already in pubspec):
   - One app-lifetime socket (not per-screen like chat): connects when signed in AND the selected group is online; `joinGroup` for the selected group's room; re-join on group switch.
   - On `groupChanged` → debounce ~300ms → `syncService.pullGroup(groupId)`. Drift streams update every open screen automatically — no per-screen work needed.
   - On socket reconnect → immediate `pullGroup` (catches events missed while disconnected). On auth error → refresh token via ApiClient, reconnect.
5. **Provider wiring:** `realtimeSyncProvider` (autoDispose) watched from the same screens that watch `foregroundGroupSyncProvider`. The 15s poll RELAXES to 60s when the socket is connected and stays as the fallback when it isn't (LAN hiccups, server restarts). Never remove the poll — sockets fail silently.
6. *(Optional cleanup, later)* ChatService switches to the shared socket so the app holds one connection instead of two.

## Phase R3 — Server: Redis (optional-by-env, so dev keeps working without it)

7. **`ioredis` + `REDIS_URL` env.** Absent → everything below silently disabled (in-memory fallbacks); present (droplet/docker) → enabled. Dev on this Windows machine can run Redis via Docker Desktop or simply leave it off.
8. **Socket.IO Redis adapter** (`@socket.io/redis-adapter`) when `REDIS_URL` is set — makes `groupChanged`/chat broadcasts work across multiple Node processes (PM2/cluster on the DigitalOcean droplet later).
9. **Membership cache** — the biggest real win: `loadGroupContext` runs a members query on EVERY group-scoped request (every pull ×
 every device × every 15s). Cache `membership:<groupId>:<userId>` with a 60s TTL; explicitly invalidate on the member-mutating paths (join, role change, transfer, delete/deactivate).
10. **Deploy config:** add `redis` service to `docker-compose.prod.yml`, `.env` example line. (Full-pull response caching and presence/"who's online" dots noted as future options, not in scope.)

## Phase R4 — Account restore ("same Gmail → all my data back")

11. **Client restore flow** (`SyncService.restoreMyGroups()`): call `GET /groups`; for each remote group missing locally → `upsertFromRemote(group)` (records invite code = marks it online) → full `pullGroup(groupId)` (cursor 0; also sets acting-as identity via `myMemberId`). Runs automatically (a) right after a successful sign-in and (b) once per app-open when signed in. Groups already present locally are skipped — normal sync covers them.
12. **Account screen:** "Restore my messes" button (manual trigger) + progress indicator + result snackbar ("3 messes restored"). New ARB keys en+bn.
13. **Honest limitation, surfaced in Help/FAQ:** only messes that were brought online can be restored this way; a never-online local mess lives only in its phone backups.
14. **Test:** wipe app data → sign in as iamshuvokd → every online mess, its members, meals, roles reappear; acting-as resolves to self; join-by-code still works as before.

## Phase R5 — Verification gate

15. `flutter gen-l10n` → `flutter analyze` (0) → `flutter test` (51+); `node --check` on touched server files; server restart.
16. Two-device live test: meal added on admin appears on member's open screen **< 1 second** (socket path), and still ≤ 60s with the socket deliberately killed (poll fallback).
17. Redis on/off dev test (server boots and serves identically without REDIS_URL).
18. APK build only when explicitly requested.

## Risks / gotchas
- Never watch DB rows that sync itself writes from any timer/provider (the 10-req/s loop from 2026-07-18) — the socket service must depend only on stable ids + connection state.
- Debounce `groupChanged` handling; a burst of pushes must not stampede pulls.
- Socket auth uses the 15-min access token → handle refresh-and-reconnect or the realtime path dies quietly after 15 minutes.
- Membership cache MUST be invalidated on role/member writes or permission changes would lag up to its TTL server-side.
