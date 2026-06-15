import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';
import 'package:roamora/features/home/domain/event_model.dart';
import 'package:roamora/features/profile/domain/user_model.dart';

part 'discovery_repository.g.dart';

class DiscoveryRepository {
  final FirebaseFirestore _firestore;

  DiscoveryRepository(this._firestore);

  Stream<List<UserModel>> getNearbyTravelers(DiscoveryMode mode, [String? currentUserId]) {
    // Basic implementation: fetch all for now, filter in memory or via simple query
    // Real geofencing would require GeoFirestore or similar
    Query query = _firestore.collection('users');
    
    if (mode == DiscoveryMode.womenOnly) {
      // Assuming we have a gender field in the real app, but for now we filter by discoveryMode
      // This is a placeholder for actual women-only logic
    } else if (mode == DiscoveryMode.mine && currentUserId != null) {
      query = query.where('uid', isEqualTo: currentUserId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<EventModel>> getNearbyEvents(DiscoveryMode mode, [String? currentUserId]) {
    Query query = _firestore.collection('events');
    
    final oneDayAgo = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
    query = query.where('startTime', isGreaterThanOrEqualTo: oneDayAgo);
    
    if (mode == DiscoveryMode.mine && currentUserId != null) {
      query = query.where('hostId', isEqualTo: currentUserId);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        try {
          return EventModel.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing EventModel (Nearby) ID: ${doc.id}. Error: $e. Data: $data');
          rethrow;
        }
      }).toList();
    });
  }

  Future<void> createEvent(EventModel event) {
    return _firestore.collection('events').doc(event.id).set(event.toJson());
  }

  Future<void> deleteEvent(String eventId) {
    return _firestore.collection('events').doc(eventId).delete();
  }

  Stream<List<EventModel>> getUserEvents(String uid) {
    return _firestore
        .collection('events')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        try {
          return EventModel.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing EventModel (UserEvents) ID: ${doc.id}. Error: $e. Data: $data');
          // Instead of rethrowing and breaking the stream, we could return a "broken" event or skip it.
          // For debugging, we'll rethrow but now with more info in the console.
          rethrow;
        }
      }).toList();
    });
  }
}

@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@riverpod
DiscoveryRepository discoveryRepository(DiscoveryRepositoryRef ref) {
  return DiscoveryRepository(ref.watch(firebaseFirestoreProvider));
}

@riverpod
Stream<List<UserModel>> nearbyTravelers(NearbyTravelersRef ref, DiscoveryMode mode) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  return ref.watch(discoveryRepositoryProvider).getNearbyTravelers(mode, user?.uid);
}

@riverpod
Stream<List<EventModel>> nearbyEvents(NearbyEventsRef ref, DiscoveryMode mode) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  return ref.watch(discoveryRepositoryProvider).getNearbyEvents(mode, user?.uid);
}

@riverpod
Stream<List<EventModel>> userEvents(UserEventsRef ref, String uid) {
  return ref.watch(discoveryRepositoryProvider).getUserEvents(uid);
}

