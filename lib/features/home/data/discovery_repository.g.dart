// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseFirestoreHash() => r'230b9276da2e44bb1aa6b300e1ddbb2f93c422da';

/// See also [firebaseFirestore].
@ProviderFor(firebaseFirestore)
final firebaseFirestoreProvider =
    AutoDisposeProvider<FirebaseFirestore>.internal(
      firebaseFirestore,
      name: r'firebaseFirestoreProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$firebaseFirestoreHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseFirestoreRef = AutoDisposeProviderRef<FirebaseFirestore>;
String _$discoveryRepositoryHash() =>
    r'b2d9c4096b0f5f6fd3608cf3ef3dbffd5a287267';

/// See also [discoveryRepository].
@ProviderFor(discoveryRepository)
final discoveryRepositoryProvider =
    AutoDisposeProvider<DiscoveryRepository>.internal(
      discoveryRepository,
      name: r'discoveryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$discoveryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiscoveryRepositoryRef = AutoDisposeProviderRef<DiscoveryRepository>;
String _$nearbyTravelersHash() => r'f0535f4d63e797b97eecb2bb94386ef1322b24f0';

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

/// See also [nearbyTravelers].
@ProviderFor(nearbyTravelers)
const nearbyTravelersProvider = NearbyTravelersFamily();

/// See also [nearbyTravelers].
class NearbyTravelersFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [nearbyTravelers].
  const NearbyTravelersFamily();

  /// See also [nearbyTravelers].
  NearbyTravelersProvider call(DiscoveryMode mode) {
    return NearbyTravelersProvider(mode);
  }

  @override
  NearbyTravelersProvider getProviderOverride(
    covariant NearbyTravelersProvider provider,
  ) {
    return call(provider.mode);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nearbyTravelersProvider';
}

/// See also [nearbyTravelers].
class NearbyTravelersProvider
    extends AutoDisposeStreamProvider<List<UserModel>> {
  /// See also [nearbyTravelers].
  NearbyTravelersProvider(DiscoveryMode mode)
    : this._internal(
        (ref) => nearbyTravelers(ref as NearbyTravelersRef, mode),
        from: nearbyTravelersProvider,
        name: r'nearbyTravelersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$nearbyTravelersHash,
        dependencies: NearbyTravelersFamily._dependencies,
        allTransitiveDependencies:
            NearbyTravelersFamily._allTransitiveDependencies,
        mode: mode,
      );

  NearbyTravelersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mode,
  }) : super.internal();

  final DiscoveryMode mode;

  @override
  Override overrideWith(
    Stream<List<UserModel>> Function(NearbyTravelersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearbyTravelersProvider._internal(
        (ref) => create(ref as NearbyTravelersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mode: mode,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<UserModel>> createElement() {
    return _NearbyTravelersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbyTravelersProvider && other.mode == mode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NearbyTravelersRef on AutoDisposeStreamProviderRef<List<UserModel>> {
  /// The parameter `mode` of this provider.
  DiscoveryMode get mode;
}

class _NearbyTravelersProviderElement
    extends AutoDisposeStreamProviderElement<List<UserModel>>
    with NearbyTravelersRef {
  _NearbyTravelersProviderElement(super.provider);

  @override
  DiscoveryMode get mode => (origin as NearbyTravelersProvider).mode;
}

String _$nearbyEventsHash() => r'4c477d73aa59432a537c80d88711415ea698b629';

/// See also [nearbyEvents].
@ProviderFor(nearbyEvents)
const nearbyEventsProvider = NearbyEventsFamily();

/// See also [nearbyEvents].
class NearbyEventsFamily extends Family<AsyncValue<List<EventModel>>> {
  /// See also [nearbyEvents].
  const NearbyEventsFamily();

  /// See also [nearbyEvents].
  NearbyEventsProvider call(DiscoveryMode mode) {
    return NearbyEventsProvider(mode);
  }

  @override
  NearbyEventsProvider getProviderOverride(
    covariant NearbyEventsProvider provider,
  ) {
    return call(provider.mode);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nearbyEventsProvider';
}

/// See also [nearbyEvents].
class NearbyEventsProvider extends AutoDisposeStreamProvider<List<EventModel>> {
  /// See also [nearbyEvents].
  NearbyEventsProvider(DiscoveryMode mode)
    : this._internal(
        (ref) => nearbyEvents(ref as NearbyEventsRef, mode),
        from: nearbyEventsProvider,
        name: r'nearbyEventsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$nearbyEventsHash,
        dependencies: NearbyEventsFamily._dependencies,
        allTransitiveDependencies:
            NearbyEventsFamily._allTransitiveDependencies,
        mode: mode,
      );

  NearbyEventsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mode,
  }) : super.internal();

  final DiscoveryMode mode;

  @override
  Override overrideWith(
    Stream<List<EventModel>> Function(NearbyEventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearbyEventsProvider._internal(
        (ref) => create(ref as NearbyEventsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mode: mode,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<EventModel>> createElement() {
    return _NearbyEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbyEventsProvider && other.mode == mode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NearbyEventsRef on AutoDisposeStreamProviderRef<List<EventModel>> {
  /// The parameter `mode` of this provider.
  DiscoveryMode get mode;
}

class _NearbyEventsProviderElement
    extends AutoDisposeStreamProviderElement<List<EventModel>>
    with NearbyEventsRef {
  _NearbyEventsProviderElement(super.provider);

  @override
  DiscoveryMode get mode => (origin as NearbyEventsProvider).mode;
}

String _$userEventsHash() => r'522d1122396ceea58b762d7cd55c4e8e30146627';

/// See also [userEvents].
@ProviderFor(userEvents)
const userEventsProvider = UserEventsFamily();

/// See also [userEvents].
class UserEventsFamily extends Family<AsyncValue<List<EventModel>>> {
  /// See also [userEvents].
  const UserEventsFamily();

  /// See also [userEvents].
  UserEventsProvider call(String uid) {
    return UserEventsProvider(uid);
  }

  @override
  UserEventsProvider getProviderOverride(
    covariant UserEventsProvider provider,
  ) {
    return call(provider.uid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userEventsProvider';
}

/// See also [userEvents].
class UserEventsProvider extends AutoDisposeStreamProvider<List<EventModel>> {
  /// See also [userEvents].
  UserEventsProvider(String uid)
    : this._internal(
        (ref) => userEvents(ref as UserEventsRef, uid),
        from: userEventsProvider,
        name: r'userEventsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userEventsHash,
        dependencies: UserEventsFamily._dependencies,
        allTransitiveDependencies: UserEventsFamily._allTransitiveDependencies,
        uid: uid,
      );

  UserEventsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<List<EventModel>> Function(UserEventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserEventsProvider._internal(
        (ref) => create(ref as UserEventsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<EventModel>> createElement() {
    return _UserEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserEventsProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserEventsRef on AutoDisposeStreamProviderRef<List<EventModel>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserEventsProviderElement
    extends AutoDisposeStreamProviderElement<List<EventModel>>
    with UserEventsRef {
  _UserEventsProviderElement(super.provider);

  @override
  String get uid => (origin as UserEventsProvider).uid;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
