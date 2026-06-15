import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';
import 'package:roamora/features/profile/data/user_repository.dart';
import 'package:roamora/core/utils/location_service.dart';

final locationSyncProvider = Provider<void>((ref) {
  final user = ref.watch(authStateProvider).value;
  final position = ref.watch(positionStreamProvider).value;

  if (user != null && position != null) {
    ref.read(userRepositoryProvider).updateUserLocation(
      user.uid,
      position.latitude,
      position.longitude,
    );
  }
});
