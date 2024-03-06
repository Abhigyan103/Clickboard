// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noticeFutureHash() => r'b3d2c04b665343820133bbc5e8ca56a2386f81a8';

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

/// See also [noticeFuture].
@ProviderFor(noticeFuture)
const noticeFutureProvider = NoticeFutureFamily();

/// See also [noticeFuture].
class NoticeFutureFamily extends Family<AsyncValue<void>> {
  /// See also [noticeFuture].
  const NoticeFutureFamily();

  /// See also [noticeFuture].
  NoticeFutureProvider call({
    bool isRefreshed = false,
  }) {
    return NoticeFutureProvider(
      isRefreshed: isRefreshed,
    );
  }

  @override
  NoticeFutureProvider getProviderOverride(
    covariant NoticeFutureProvider provider,
  ) {
    return call(
      isRefreshed: provider.isRefreshed,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'noticeFutureProvider';
}

/// See also [noticeFuture].
class NoticeFutureProvider extends AutoDisposeFutureProvider<void> {
  /// See also [noticeFuture].
  NoticeFutureProvider({
    bool isRefreshed = false,
  }) : this._internal(
          (ref) => noticeFuture(
            ref as NoticeFutureRef,
            isRefreshed: isRefreshed,
          ),
          from: noticeFutureProvider,
          name: r'noticeFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noticeFutureHash,
          dependencies: NoticeFutureFamily._dependencies,
          allTransitiveDependencies:
              NoticeFutureFamily._allTransitiveDependencies,
          isRefreshed: isRefreshed,
        );

  NoticeFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isRefreshed,
  }) : super.internal();

  final bool isRefreshed;

  @override
  Override overrideWith(
    FutureOr<void> Function(NoticeFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NoticeFutureProvider._internal(
        (ref) => create(ref as NoticeFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isRefreshed: isRefreshed,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _NoticeFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoticeFutureProvider && other.isRefreshed == isRefreshed;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isRefreshed.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoticeFutureRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `isRefreshed` of this provider.
  bool get isRefreshed;
}

class _NoticeFutureProviderElement
    extends AutoDisposeFutureProviderElement<void> with NoticeFutureRef {
  _NoticeFutureProviderElement(super.provider);

  @override
  bool get isRefreshed => (origin as NoticeFutureProvider).isRefreshed;
}

String _$noticeControllerHash() => r'9f290840cdb42041902c2fa4eca7f4ed2a716e79';

/// See also [NoticeController].
@ProviderFor(NoticeController)
final noticeControllerProvider =
    NotifierProvider<NoticeController, List<Notice>>.internal(
  NoticeController.new,
  name: r'noticeControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noticeControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NoticeController = Notifier<List<Notice>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
