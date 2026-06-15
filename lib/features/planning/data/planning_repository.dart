import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roamora/features/planning/domain/trip_plan_model.dart';

part 'planning_repository.g.dart';

class PlanningRepository {
  final FirebaseFirestore _firestore;

  PlanningRepository(this._firestore);

  Stream<List<TripPlanModel>> getTripPlans(String userId) {
    return _firestore
        .collection('trip_plans')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        try {
          return TripPlanModel.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing TripPlanModel ID: ${doc.id}. Error: $e. Data: $data');
          rethrow;
        }
      }).toList();
    });
  }

  Future<void> saveTripPlan(TripPlanModel plan) {
    return _firestore.collection('trip_plans').doc(plan.id).set(plan.toJson());
  }

  Future<void> addTripItem(String planId, TripItemModel item) {
    return _firestore.collection('trip_plans').doc(planId).update({
      'items': FieldValue.arrayUnion([item.toJson()]),
    });
  }
}

@riverpod
PlanningRepository planningRepository(PlanningRepositoryRef ref) {
  return PlanningRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<TripPlanModel>> userTripPlans(UserTripPlansRef ref, String userId) {
  return ref.watch(planningRepositoryProvider).getTripPlans(userId);
}
