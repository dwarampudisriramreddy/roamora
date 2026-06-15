// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planning_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$planningRepositoryHash() =>
    r'824cfd0898f7819eec1ded3d7d47eefb77b45eb3';

/// See also [planningRepository].
@ProviderFor(planningRepository)
final planningRepositoryProvider =
    AutoDisposeProvider<PlanningRepository>.internal(
      planningRepository,
      name: r'planningRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$planningRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlanningRepositoryRef = AutoDisposeProviderRef<PlanningRepository>;
String _$userTripPlansHash() => r'9aafbf136e255046c9e1f77c39c5a7b52d49f255';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userTripPlans].
@ProviderFor(userTripPlans)
const userTripPlansProvider = UserTripPlansFamily();

/// See also [userTripPlans].
class UserTripPlansFamily extends Family<AsyncValue<List<TripPlanModel>>> {
  /// See also [userTripPlans].
  const UserTripPlansFamily();

  /// See also [userTripPlans].
  UserTripPlansProvider call(String userId) {
    return UserTripPlansProvider(userId);
  }

  @override
  UserTripPlansProvider getProviderOverride(
    covariant UserTripPlansProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userTripPlansProvider';
}

/// See also [userTripPlans].
class UserTripPlansProvider
    extends AutoDisposeStreamProvider<List<TripPlanModel>> {
  /// See also [userTripPlans].
  UserTripPlansProvider(String userId)
    : this._internal(
        (ref) => userTripPlans(ref as UserTripPlansRef, userId),
        from: userTripPlansProvider,
        name: r'userTripPlansProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userTripPlansHash,
        dependencies: UserTripPlansFamily._dependencies,
        allTransitiveDependencies:
            UserTripPlansFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserTripPlansProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<TripPlanModel>> Function(UserTripPlansRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserTripPlansProvider._internal(
        (ref) => create(ref as UserTripPlansRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TripPlanModel>> createElement() {
    return _UserTripPlansProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserTripPlansProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserTripPlansRef on AutoDisposeStreamProviderRef<List<TripPlanModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserTripPlansProviderElement
    extends AutoDisposeStreamProviderElement<List<TripPlanModel>>
    with UserTripPlansRef {
  _UserTripPlansProviderElement(super.provider);

  @override
  String get userId => (origin as UserTripPlansProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
