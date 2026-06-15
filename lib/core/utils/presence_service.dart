import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';

part 'presence_service.g.dart';

class PresenceService {
  final FirebaseDatabase _database;
  final FirebaseAuth _auth;

  PresenceService(this._database, this._auth) {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        final presenceRef = _database.ref('status/${user.uid}');
        
        // On connect, set online and timestamp
        // On disconnect, set offline and timestamp
        _database.ref('.info/connected').onValue.listen((event) {
          if (event.snapshot.value == true) {
            presenceRef.onDisconnect().set({
              'state': 'offline',
              'last_changed': ServerValue.timestamp,
            });

            presenceRef.set({
              'state': 'online',
              'last_changed': ServerValue.timestamp,
            });
          }
        });
      }
    });
  }

  Stream<bool> isUserOnline(String uid) {
    return _database.ref('status/$uid/state').onValue.map((event) {
      return event.snapshot.value == 'online';
    });
  }
}

@riverpod
PresenceService presenceService(PresenceServiceRef ref) {
  return PresenceService(
    FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://roamora-9ab71-default-rtdb.firebaseio.com/',
    ),
    FirebaseAuth.instance,
  );
}

@riverpod
Stream<bool> userOnlineStatus(UserOnlineStatusRef ref, String uid) {
  return ref.watch(presenceServiceProvider).isUserOnline(uid);
}
