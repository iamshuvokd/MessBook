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

    // (Re)join the group room on EVERY connect, not just the first. socket.io
    // auto-reconnects after a network drop with a brand-new server-side
    // socket that belongs to no rooms — so without re-joining here,
    // `dataChanged` silently stops arriving after the first blip and live
    // updates appear to "work once, then die". Emitting from inside
    // onConnect makes every (re)connect re-join. The join is
    // membership-checked server-side; on the rare `not_a_member` ack there's
    // nothing to do but leave the 15s foreground poll to cover this group.
    socket.onConnect((_) {
      socket.emitWithAck('joinGroup', groupId, ack: (_) {});
    });

    // Fire-and-forget: deliberately NOT awaited. If the first connect is
    // slow or the server is briefly unreachable, socket.io keeps retrying in
    // the background (and re-joins via onConnect above once it lands) while
    // the 15s foreground poll timer covers the gap — far more robust than
    // the previous "give up after a 10s timeout" behavior, which left a
    // screen with no live updates at all until it was re-entered.
    socket.connect();
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
