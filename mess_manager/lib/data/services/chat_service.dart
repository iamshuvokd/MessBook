import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as sio;

import 'api_client.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.text,
    this.clientNonce,
    required this.createdAt,
  });

  final String id;
  final String groupId;
  final String memberId;
  final String text;
  final String? clientNonce;
  final DateTime createdAt;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        memberId: json['memberId'] as String,
        text: json['text'] as String,
        clientNonce: json['clientNonce'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      );
}

class ChatServiceException implements Exception {
  const ChatServiceException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// One Socket.IO connection, joined to a single mess's chat room at a time.
/// History (initial load / catch-up after being offline) goes over plain
/// REST via [ApiClient] — this only carries the live connection, so chat
/// stays a thin layer on top of the same accounts+sync foundation rather
/// than a separate always-on service.
class ChatService {
  ChatService(this._apiClient);

  final ApiClient _apiClient;
  sio.Socket? _socket;
  final _messages = StreamController<ChatMessage>.broadcast();
  final _joined = StreamController<bool>.broadcast();

  Stream<ChatMessage> get messages => _messages.stream;

  /// `true` once this device is in the group's room and live messages will
  /// arrive; `false` while disconnected or retrying. Emits on every change,
  /// so the UI can clear its error banner when the connection comes back
  /// instead of staying stuck on the first failure.
  Stream<bool> get joined => _joined.stream;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connectAndJoin(String groupId) async {
    final token = await _apiClient.accessToken;
    if (token == null) throw const ChatServiceException('Not signed in');

    disconnect();

    final socket = sio.io(
      _apiClient.baseUrl,
      sio.OptionBuilder().setTransports(['websocket']).disableAutoConnect().setAuth({'token': token}).build(),
    );
    _socket = socket;
    socket.on('newMessage', (data) {
      _messages.add(ChatMessage.fromJson((data as Map).cast<String, dynamic>()));
    });

    // (Re)join the room on EVERY connect, exactly as RealtimeService does.
    // socket.io reconnects with a brand-new server-side socket that belongs
    // to no rooms, so joining only once meant chat silently stopped
    // receiving `newMessage` after the first network blip, server restart or
    // app resume — "works once, then dies".
    socket.onConnect((_) {
      socket.emitWithAck('joinGroup', groupId, ack: (dynamic res) {
        final error = res is Map ? res['error'] : null;
        _joined.add(error == null);
      });
    });
    socket.onDisconnect((_) => _joined.add(false));

    // Fire-and-forget, like RealtimeService. This used to await the first
    // connect with a 10s timeout and throw, which permanently killed chat
    // for that screen visit if the server happened to be unreachable at the
    // moment it opened — it never recovered even once the server came back.
    // socket.io keeps retrying in the background and re-joins above.
    socket.connect();
  }

  Future<ChatMessage> sendMessage(String groupId, String text, {String? clientNonce}) async {
    final socket = _socket;
    if (socket == null || !socket.connected) throw const ChatServiceException('Not connected');

    final ack = (await socket.emitWithAckAsync('sendMessage', {
      'groupId': groupId,
      'text': text,
      'clientNonce': ?clientNonce,
    }) as Map)
        .cast<String, dynamic>();
    if (ack['error'] != null) throw ChatServiceException(ack['error'] as String);
    return ChatMessage.fromJson((ack['message'] as Map).cast<String, dynamic>());
  }

  /// Newest-first page of history. Pass the oldest message's `createdAt` as
  /// [before] to page further back.
  Future<List<ChatMessage>> fetchHistory(String groupId, {DateTime? before, int limit = 50}) async {
    final beforeMs = before?.millisecondsSinceEpoch;
    final query = '?limit=$limit${beforeMs != null ? '&before=$beforeMs' : ''}';
    final response = await _apiClient.get('/groups/$groupId/messages$query');
    final rows = (response['messages'] as List).cast<Map<String, dynamic>>();
    return rows.map(ChatMessage.fromJson).toList();
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _messages.close();
    _joined.close();
  }
}
