import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roamora/features/chat/domain/message_model.dart';
import 'package:roamora/features/profile/data/user_repository.dart';
import 'package:roamora/features/profile/domain/user_model.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  ChatRepository(this._firestore);

  String getChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) < 0 ? '${uid1}_$uid2' : '${uid2}_$uid1';
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromJson(doc.data())).toList());
  }

  Stream<List<String>> getChats(String uid) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      debugPrint('ChatRepository: Found ${snapshot.docs.length} chat documents for user $uid');
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        debugPrint('ChatRepository: Chat doc data: $data');
        final participants = List<String>.from(data['participants'] ?? []);
        return participants.firstWhere((p) => p != uid, orElse: () => '');
      }).where((uid) => uid.isNotEmpty).toList();
    });
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    await _ensureParticipants(chatId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set(message.toJson());
  }

  Future<void> _ensureParticipants(String chatId) async {
    final participants = chatId.split('_');
    await _firestore.collection('chats').doc(chatId).set({
      'participants': participants,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Temporary fix: run this once to repair existing chats
  Future<void> repairExistingChats() async {
    final chatDocs = await _firestore.collectionGroup('messages').get();
    final chatIds = chatDocs.docs.map((doc) => doc.reference.parent.parent!.id).toSet();
    
    for (final chatId in chatIds) {
      await _ensureParticipants(chatId);
    }
    debugPrint('ChatRepository: Repaired ${chatIds.length} chat documents.');
  }
}

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<MessageModel>> chatMessages(ChatMessagesRef ref, String chatId) {
  return ref.watch(chatRepositoryProvider).getMessages(chatId);
}

@riverpod
Stream<List<String>> activeChatUids(ActiveChatUidsRef ref, String uid) {
  return ref.watch(chatRepositoryProvider).getChats(uid);
}

@riverpod
Stream<List<UserModel>> activeChats(ActiveChatsRef ref, String uid) {
  final uidsStream = ref.watch(chatRepositoryProvider).getChats(uid);
  return uidsStream.asyncMap((uids) async {
    final userRepository = ref.watch(userRepositoryProvider);
    final users = await Future.wait(uids.map((uid) => userRepository.getUser(uid).first));
    return users.whereType<UserModel>().toList();
  });
}
