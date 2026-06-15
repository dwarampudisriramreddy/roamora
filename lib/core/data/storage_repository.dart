import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_repository.g.dart';

class StorageRepository {
  final FirebaseStorage _storage;

  StorageRepository(this._storage);

  Future<String> uploadUserAvatar({
    required String uid,
    required File file,
  }) async {
    final ref = _storage.ref().child('users').child(uid).child('avatar.jpg');
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }
}

@riverpod
StorageRepository storageRepository(StorageRepositoryRef ref) {
  return StorageRepository(FirebaseStorage.instance);
}
