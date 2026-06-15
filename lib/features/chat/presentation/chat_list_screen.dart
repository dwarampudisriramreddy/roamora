import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';
import 'package:roamora/features/chat/data/chat_repository.dart';
import 'package:roamora/core/utils/presence_service.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authRepositoryProvider).currentUser;
    if (currentUser == null) return const Center(child: Text('Please login'));

    final activeChatsAsync = ref.watch(activeChatsProvider(currentUser.uid));

    return Scaffold(
      body: activeChatsAsync.when(
        data: (users) {
          if (users.isEmpty) {
            // Attempt repair if empty
            ref.read(chatRepositoryProvider).repairExistingChats();
            return const Center(child: Text('No active chats. Start one in Discovery!'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: Consumer(
                  builder: (context, ref, _) {
                    final isOnlineAsync = ref.watch(userOnlineStatusProvider(user.uid));
                    return Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                          child: user.photoURL == null ? const Icon(Icons.person) : null,
                        ),
                        if (isOnlineAsync.valueOrNull == true)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                title: Text(user.email),
                subtitle: Text(user.interests.isNotEmpty ? user.interests.join(', ') : 'Traveler'),
                trailing: const Icon(Icons.chat_bubble_outline),
                onTap: () => context.push('/chat/${user.uid}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
