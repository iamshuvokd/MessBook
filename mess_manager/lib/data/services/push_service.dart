import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../ui/router/app_router.dart';
import 'api_client.dart';
import 'notification_service.dart';
import 'sync_service.dart';

/// FCM registration + display for chat and membership push — the app stays
/// offline-first, so this is purely additive: chat delivery is already
/// real-time over the socket (this only matters when it's backgrounded or
/// closed), and membership changes have no other live channel at all, so a
/// `memberJoined` push is the only thing that makes a newly-added member
/// show up on another device without a manual pull-to-refresh or waiting for
/// the next periodic sync. Only ever runs for a signed-in account.
class PushService {
  PushService(this._messaging, this._api, this._notifications, this._sync);

  final FirebaseMessaging _messaging;
  final ApiClient _api;
  final NotificationService _notifications;
  final SyncService _sync;

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<RemoteMessage>? _openedAppSub;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    if (!await _api.isSignedIn) return;
    _initialized = true;

    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    if (token != null) await _registerToken(token);
    _tokenRefreshSub = _messaging.onTokenRefresh.listen(_registerToken);

    _foregroundSub = FirebaseMessaging.onMessage.listen(_handleForeground);
    _openedAppSub = FirebaseMessaging.onMessageOpenedApp.listen(_handleOpened);

    final openedFromTerminated = await _messaging.getInitialMessage();
    if (openedFromTerminated != null) _handleOpened(openedFromTerminated);
  }

  Future<void> _registerToken(String token) async {
    try {
      await _api.post('/me/device-token', {'fcmToken': token});
    } catch (_) {
      // Best-effort; the next app open or token refresh retries.
    }
  }

  Future<void> _handleForeground(RemoteMessage message) async {
    final groupId = message.data['groupId'];
    final isMemberJoined = message.data['type'] == 'memberJoined';

    // The sync fires regardless of whether there's a visible notification to
    // show — it's what actually makes a newly-added member (or anything else
    // this push type covers later) show up without a manual pull-to-refresh.
    if (isMemberJoined && groupId is String && groupId.isNotEmpty) {
      unawaited(_sync.syncGroup(groupId));
    }

    final notification = message.notification;
    if (notification == null) return;
    if (isMemberJoined) {
      await _notifications.showMemberJoined(title: notification.title ?? '', body: notification.body ?? '');
    } else {
      await _notifications.showChatMessage(title: notification.title ?? '', body: notification.body ?? '');
    }
  }

  void _handleOpened(RemoteMessage message) {
    final groupId = message.data['groupId'];
    if (groupId is! String || groupId.isEmpty) return;
    if (message.data['type'] == 'memberJoined') {
      unawaited(_sync.syncGroup(groupId));
      appRouter.push('/groups/$groupId/members');
    } else {
      appRouter.push('/groups/$groupId/chat');
    }
  }

  void dispose() {
    _tokenRefreshSub?.cancel();
    _foregroundSub?.cancel();
    _openedAppSub?.cancel();
  }
}
