// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presence_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$presenceServiceHash() => r'718777a572226d9293c2b2c972066ceb8aef4b26';

/// See also [presenceService].
@ProviderFor(presenceService)
final presenceServiceProvider = AutoDisposeProvider<PresenceService>.internal(
  presenceService,
  name: r'presenceServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$presenceServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PresenceServiceRef = AutoDisposeProviderRef<PresenceService>;
String _$userOnlineStatusHash() => r'6748506d471f5335afdce6e36ea5640c79f5bac8';

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

/// See also [userOnlineStatus].
@ProviderFor(userOnlineStatus)
const userOnlineStatusProvider = UserOnlineStatusFamily();

/// See also [userOnlineStatus].
class UserOnlineStatusFamily extends Family<AsyncValue<bool>> {
  /// See also [userOnlineStatus].
  const UserOnlineStatusFamily();

  /// See also [userOnlineStatus].
  UserOnlineStatusProvider call(String uid) {
    return UserOnlineStatusProvider(uid);
  }

  @override
  UserOnlineStatusProvider getProviderOverride(
    covariant UserOnlineStatusProvider provider,
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
  String? get name => r'userOnlineStatusProvider';
}

/// See also [userOnlineStatus].
class UserOnlineStatusProvider extends AutoDisposeStreamProvider<bool> {
  /// See also [userOnlineStatus].
  UserOnlineStatusProvider(String uid)
    : this._internal(
        (ref) => userOnlineStatus(ref as UserOnlineStatusRef, uid),
        from: userOnlineStatusProvider,
        name: r'userOnlineStatusProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userOnlineStatusHash,
        dependencies: UserOnlineStatusFamily._dependencies,
        allTransitiveDependencies:
            UserOnlineStatusFamily._allTransitiveDependencies,
        uid: uid,
      );

  UserOnlineStatusProvider._internal(
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
    Stream<bool> Function(UserOnlineStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserOnlineStatusProvider._internal(
        (ref) => create(ref as UserOnlineStatusRef),
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
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _UserOnlineStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserOnlineStatusProvider && other.uid == uid;
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
mixin UserOnlineStatusRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserOnlineStatusProviderElement
    extends AutoDisposeStreamProviderElement<bool>
    with UserOnlineStatusRef {
  _UserOnlineStatusProviderElement(super.provider);

  @override
  String get uid => (origin as UserOnlineStatusProvider).uid;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
