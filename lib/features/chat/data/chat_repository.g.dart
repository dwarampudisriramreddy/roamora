// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'6b50a68d8a99fbecd1ca3f51b9f0ca5c0a0b21cf';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = AutoDisposeProvider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRepositoryRef = AutoDisposeProviderRef<ChatRepository>;
String _$chatMessagesHash() => r'bedaf7d90ed3a88069a447a0f67aa2d6cbb90760';

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

/// See also [chatMessages].
@ProviderFor(chatMessages)
const chatMessagesProvider = ChatMessagesFamily();

/// See also [chatMessages].
class ChatMessagesFamily extends Family<AsyncValue<List<MessageModel>>> {
  /// See also [chatMessages].
  const ChatMessagesFamily();

  /// See also [chatMessages].
  ChatMessagesProvider call(String chatId) {
    return ChatMessagesProvider(chatId);
  }

  @override
  ChatMessagesProvider getProviderOverride(
    covariant ChatMessagesProvider provider,
  ) {
    return call(provider.chatId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatMessagesProvider';
}

/// See also [chatMessages].
class ChatMessagesProvider
    extends AutoDisposeStreamProvider<List<MessageModel>> {
  /// See also [chatMessages].
  ChatMessagesProvider(String chatId)
    : this._internal(
        (ref) => chatMessages(ref as ChatMessagesRef, chatId),
        from: chatMessagesProvider,
        name: r'chatMessagesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chatMessagesHash,
        dependencies: ChatMessagesFamily._dependencies,
        allTransitiveDependencies:
            ChatMessagesFamily._allTransitiveDependencies,
        chatId: chatId,
      );

  ChatMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  Override overrideWith(
    Stream<List<MessageModel>> Function(ChatMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesProvider._internal(
        (ref) => create(ref as ChatMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<MessageModel>> createElement() {
    return _ChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatMessagesRef on AutoDisposeStreamProviderRef<List<MessageModel>> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<MessageModel>>
    with ChatMessagesRef {
  _ChatMessagesProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatMessagesProvider).chatId;
}

String _$activeChatUidsHash() => r'add78ba00ec9cc371d1b364fd582407fce71d62e';

/// See also [activeChatUids].
@ProviderFor(activeChatUids)
const activeChatUidsProvider = ActiveChatUidsFamily();

/// See also [activeChatUids].
class ActiveChatUidsFamily extends Family<AsyncValue<List<String>>> {
  /// See also [activeChatUids].
  const ActiveChatUidsFamily();

  /// See also [activeChatUids].
  ActiveChatUidsProvider call(String uid) {
    return ActiveChatUidsProvider(uid);
  }

  @override
  ActiveChatUidsProvider getProviderOverride(
    covariant ActiveChatUidsProvider provider,
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
  String? get name => r'activeChatUidsProvider';
}

/// See also [activeChatUids].
class ActiveChatUidsProvider extends AutoDisposeStreamProvider<List<String>> {
  /// See also [activeChatUids].
  ActiveChatUidsProvider(String uid)
    : this._internal(
        (ref) => activeChatUids(ref as ActiveChatUidsRef, uid),
        from: activeChatUidsProvider,
        name: r'activeChatUidsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activeChatUidsHash,
        dependencies: ActiveChatUidsFamily._dependencies,
        allTransitiveDependencies:
            ActiveChatUidsFamily._allTransitiveDependencies,
        uid: uid,
      );

  ActiveChatUidsProvider._internal(
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
    Stream<List<String>> Function(ActiveChatUidsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveChatUidsProvider._internal(
        (ref) => create(ref as ActiveChatUidsRef),
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
  AutoDisposeStreamProviderElement<List<String>> createElement() {
    return _ActiveChatUidsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveChatUidsProvider && other.uid == uid;
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
mixin ActiveChatUidsRef on AutoDisposeStreamProviderRef<List<String>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _ActiveChatUidsProviderElement
    extends AutoDisposeStreamProviderElement<List<String>>
    with ActiveChatUidsRef {
  _ActiveChatUidsProviderElement(super.provider);

  @override
  String get uid => (origin as ActiveChatUidsProvider).uid;
}

String _$activeChatsHash() => r'b3fa1dd6ab56d5459a4276ce4702591b855b6d4f';

/// See also [activeChats].
@ProviderFor(activeChats)
const activeChatsProvider = ActiveChatsFamily();

/// See also [activeChats].
class ActiveChatsFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [activeChats].
  const ActiveChatsFamily();

  /// See also [activeChats].
  ActiveChatsProvider call(String uid) {
    return ActiveChatsProvider(uid);
  }

  @override
  ActiveChatsProvider getProviderOverride(
    covariant ActiveChatsProvider provider,
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
  String? get name => r'activeChatsProvider';
}

/// See also [activeChats].
class ActiveChatsProvider extends AutoDisposeStreamProvider<List<UserModel>> {
  /// See also [activeChats].
  ActiveChatsProvider(String uid)
    : this._internal(
        (ref) => activeChats(ref as ActiveChatsRef, uid),
        from: activeChatsProvider,
        name: r'activeChatsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activeChatsHash,
        dependencies: ActiveChatsFamily._dependencies,
        allTransitiveDependencies: ActiveChatsFamily._allTransitiveDependencies,
        uid: uid,
      );

  ActiveChatsProvider._internal(
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
    Stream<List<UserModel>> Function(ActiveChatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveChatsProvider._internal(
        (ref) => create(ref as ActiveChatsRef),
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
  AutoDisposeStreamProviderElement<List<UserModel>> createElement() {
    return _ActiveChatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveChatsProvider && other.uid == uid;
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
mixin ActiveChatsRef on AutoDisposeStreamProviderRef<List<UserModel>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _ActiveChatsProviderElement
    extends AutoDisposeStreamProviderElement<List<UserModel>>
    with ActiveChatsRef {
  _ActiveChatsProviderElement(super.provider);

  @override
  String get uid => (origin as ActiveChatsProvider).uid;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
