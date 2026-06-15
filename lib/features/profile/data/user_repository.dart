import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roamora/features/profile/domain/user_model.dart';

part 'user_repository.g.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> updateUserLocation(String uid, double latitude, double longitude) {
    return _firestore.collection('users').doc(uid).set({
      'latitude': latitude,
      'longitude': longitude,
    }, SetOptions(merge: true));
  }

  Future<void> createUserProfile(UserModel user) {
    return _firestore.collection('users').doc(user.uid).set(user.toJson(), SetOptions(merge: true));
  }

  Future<void> updateUserProfile(UserModel user) {
    debugPrint('UserRepository: Setting profile for ${user.uid} with email: ${user.email}');
    return _firestore.collection('users').doc(user.uid).set(user.toJson(), SetOptions(merge: true));
  }

  Stream<UserModel?> getUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      final data = snapshot.data() as Map<String, dynamic>;
      // Ensure UID is present in the data passed to fromJson
      if (data['uid'] == null || (data['uid'] as String).isEmpty) {
        data['uid'] = uid;
      }
      return UserModel.fromJson(data);
    });
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<UserModel?> userProfile(UserProfileRef ref, String uid) {
  return ref.watch(userRepositoryProvider).getUser(uid);
}
