import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/chat_service.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/empty_state.dart';

/// One group channel per mess (like a mess WhatsApp group), only ever shown
/// for messes that are already online — offline-only messes have nobody
/// else's phone to talk to. History loads over REST; live messages arrive
/// over the socket while this screen is open.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  StreamSubscription<ChatMessage>? _subscription;
  StreamSubscription<bool>? _joinedSubscription;
  bool _loading = true;
  bool _sending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != widget.groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(widget.groupId);
      }
    });
    _init();
  }

  Future<void> _init() async {
    final chat = ref.read(chatServiceProvider);

    // Subscribe BEFORE connecting. This used to run after connectAndJoin,
    // so a slow or failed first connect threw past it and the screen never
    // listened at all — live messages then stayed dead for the whole visit
    // even after the socket recovered on its own.
    _subscription = chat.messages.listen((message) {
      if (message.groupId != widget.groupId || !mounted) return;
      setState(() => _messages.add(message));
      _scrollToBottom();
    });

    // Track the live connection so the banner reflects reality now rather
    // than whatever happened on the first attempt.
    _joinedSubscription = chat.joined.listen((joined) {
      if (!mounted) return;
      setState(() => _error = joined ? null : AppLocalizations.of(context).chatConnectError);
    });

    try {
      final history = await chat.fetchHistory(widget.groupId);
      if (!mounted) return;
      setState(() {
        _messages.addAll(history.reversed);
        _loading = false;
      });
      _scrollToBottom();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context).chatConnectError;
      });
    }

    // Never awaited: it retries in the background and the banner above
    // clears itself once the room is joined.
    await chat.connectAndJoin(widget.groupId);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _textController.clear();
    try {
      await ref.read(chatServiceProvider).sendMessage(widget.groupId, text);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).chatSendError)));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _joinedSubscription?.cancel();
    ref.read(chatServiceProvider).disconnect();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the autoDispose ChatService (and its live socket) alive for as
    // long as this screen is on screen — _init/_send/dispose all read the
    // same instance via ref.read.
    ref.watch(chatServiceProvider);
    final l10n = AppLocalizations.of(context);
    final members = ref.watch(membersOfSelectedGroupProvider).value ?? const [];
    final myMemberId = ref.watch(actingAsMemberProvider)?.id;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatTitle)),
      body: Column(
        children: [
          if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer, fontSize: 12)),
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? EmptyState(icon: Icons.forum_rounded, title: l10n.chatEmpty)
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) {
                          final message = _messages[i];
                          final matching = members.where((m) => m.id == message.memberId);
                          final senderName = matching.isEmpty ? l10n.chatUnknownSender : matching.first.name;
                          return _MessageBubble(message: message, senderName: senderName, isMine: message.memberId == myMemberId);
                        },
                      ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(hintText: l10n.chatMessageHint),
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.senderName, required this.isMine});

  final ChatMessage message;
  final String senderName;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMine ? scheme.primaryContainer : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMine) Text(senderName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.teal700)),
            Text(message.text, style: const TextStyle(fontSize: 14.5)),
          ],
        ),
      ),
    );
  }
}
