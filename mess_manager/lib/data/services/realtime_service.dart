import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as sio;

import 'api_client.dart';

/// One Socket.IO connection joined to a single mess's `group:<id>` room —
/// the same room [ChatService] uses for `newMessage`, kept as a separate
/// connection because this one's lifecycle is different: it needs to stay
/// open for as long as a group is being actively viewed (any screen), not
/// just while the chat screen is on-screen.
///
/// Purely a low-latency nudge on top of the existing REST push/pull sync —
/// on `dataChanged` the caller re-runs its normal pull, same as the 15s
/// foreground timer already does. No new merge logic, no bypass of the
/// offline-first last-write-wins sync engine.
class RealtimeService {
  RealtimeService(this._apiClient);

  final ApiClient _apiClient;
  sio.Socket? _socket;
  final _dataChanged = StreamController<List<String>>.broadcast();

  Stream<List<String>> get dataChanged => _dataChanged.stream;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connectAndJoin(String groupId) async {
    final token = await _apiClient.accessToken;
    if (token == null) return;

    disconnect();

    final socket = sio.io(
      _apiClient.baseUrl,
      sio.OptionBuilder().setTransports(['websocket']).disableAutoConnect().setAuth({'token': token}).build(),
    );
    _socket = socket;
    socket.on('dataChanged', (data) {
      final tables = ((data as Map)['tables'] as List?)?.cast<String>() ?? const <String>[];
      _dataChanged.add(tables);
    });

    final connected = Completer<void>();
    socket.onConnect((_) {
      if (!connected.isCompleted) connected.complete();
    });
    socket.onConnectError((err) {
      if (!connected.isCompleted) connected.completeError(err);
    });
    socket.connect();
    try {
      await connected.future.timeout(const Duration(seconds: 10));
    } catch (_) {
      // Best-effort: the 15s foreground poll timer still covers this group
      // if the live socket never connects (offline, server unreachable).
      disconnect();
      return;
    }

    await socket.emitWithAckAsync('joinGroup', groupId);
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _dataChanged.close();
  }
}
