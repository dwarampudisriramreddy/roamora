import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roamora/core/data/storage_repository.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';
import 'package:roamora/features/profile/data/user_repository.dart';
import 'package:roamora/features/profile/domain/user_model.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<UserModel?> build() {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) return null;
    return ref.watch(userRepositoryProvider).getUser(user.uid).first;
  }

  Future<void> updateGender(String gender) async {
    final user = state.value;
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (user == null || currentUser == null || currentUser.uid.isEmpty) {
      debugPrint('CRITICAL: Cannot update gender. User: $user, AuthUID: ${currentUser?.uid}');
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Use currentUser.uid as the definitive source of truth for the document path
      final updatedUser = user.copyWith(uid: currentUser.uid, gender: gender);
      await ref.read(userRepositoryProvider).updateUserProfile(updatedUser);
      return updatedUser;
    });
  }

  Future<void> updateAvatar(File file) async {
    final user = state.value;
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (user == null || currentUser == null || currentUser.uid.isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final photoURL = await ref.read(storageRepositoryProvider).uploadUserAvatar(
            uid: currentUser.uid,
            file: file,
          );
      final updatedUser = user.copyWith(uid: currentUser.uid, photoURL: photoURL);
      await ref.read(userRepositoryProvider).updateUserProfile(updatedUser);
      return updatedUser;
    });
  }

  Future<void> addInterest(String interest) async {
    final user = state.value;
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (user == null || currentUser == null || currentUser.uid.isEmpty || user.interests.contains(interest)) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updatedUser = user.copyWith(uid: currentUser.uid, interests: [...user.interests, interest]);
      await ref.read(userRepositoryProvider).updateUserProfile(updatedUser);
      return updatedUser;
    });
  }

  Future<void> removeInterest(String interest) async {
    final user = state.value;
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (user == null || currentUser == null || currentUser.uid.isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updatedUser = user.copyWith(
        uid: currentUser.uid,
        interests: user.interests.where((i) => i != interest).toList(),
      );
      await ref.read(userRepositoryProvider).updateUserProfile(updatedUser);
      return updatedUser;
    });
  }
}
