import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roamora/core/utils/presence_service.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';
import 'package:roamora/features/chat/data/chat_repository.dart';
import 'package:roamora/features/chat/domain/message_model.dart';
import 'package:roamora/features/profile/data/user_repository.dart';
import 'package:roamora/features/profile/domain/user_model.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String otherUserId;

  const ChatScreen({super.key, required this.otherUserId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(String chatId, String currentUserId) {
    if (_controller.text.trim().isEmpty) return;
    
    final message = MessageModel(
      id: const Uuid().v4(),
      senderId: currentUserId,
      text: _controller.text.trim(),
      timestamp: DateTime.now(),
    );
    
    ref.read(chatRepositoryProvider).sendMessage(chatId, message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authRepositoryProvider).currentUser;
    if (currentUser == null) return const Scaffold(body: Center(child: Text('Not logged in')));

    final chatId = ref.watch(chatRepositoryProvider).getChatId(currentUser.uid, widget.otherUserId);
    final messagesAsync = ref.watch(chatMessagesProvider(chatId));
    final otherUserAsync = ref.watch(userRepositoryProvider).getUser(widget.otherUserId);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<UserModel?>(
          stream: otherUserAsync,
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user == null) return const Text('Chat');
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.email, style: const TextStyle(fontSize: 16)),
                Consumer(
                  builder: (context, ref, _) {
                    final isOnlineAsync = ref.watch(userOnlineStatusProvider(user.uid));
                    return Text(
                      isOnlineAsync.valueOrNull == true ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 11,
                        color: isOnlineAsync.valueOrNull == true ? Colors.greenAccent : Colors.white70,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = msg.senderId == currentUser.uid;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(color: isMe ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(chatId, currentUser.uid),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(chatId, currentUser.uid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
