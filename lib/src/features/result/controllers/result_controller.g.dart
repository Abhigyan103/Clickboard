// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resultFutureHash() => r'e730d2be88396eb22ab096d138cecff4f0ed733e';

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

/// See also [resultFuture].
@ProviderFor(resultFuture)
const resultFutureProvider = ResultFutureFamily();

/// See also [resultFuture].
class ResultFutureFamily extends Family<AsyncValue<void>> {
  /// See also [resultFuture].
  const ResultFutureFamily();

  /// See also [resultFuture].
  ResultFutureProvider call({
    bool isRefreshed = false,
  }) {
    return ResultFutureProvider(
      isRefreshed: isRefreshed,
    );
  }

  @override
  ResultFutureProvider getProviderOverride(
    covariant ResultFutureProvider provider,
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
  String? get name => r'resultFutureProvider';
}

/// See also [resultFuture].
class ResultFutureProvider extends AutoDisposeFutureProvider<void> {
  /// See also [resultFuture].
  ResultFutureProvider({
    bool isRefreshed = false,
  }) : this._internal(
          (ref) => resultFuture(
            ref as ResultFutureRef,
            isRefreshed: isRefreshed,
          ),
          from: resultFutureProvider,
          name: r'resultFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$resultFutureHash,
          dependencies: ResultFutureFamily._dependencies,
          allTransitiveDependencies:
              ResultFutureFamily._allTransitiveDependencies,
          isRefreshed: isRefreshed,
        );

  ResultFutureProvider._internal(
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
    FutureOr<void> Function(ResultFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ResultFutureProvider._internal(
        (ref) => create(ref as ResultFutureRef),
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
    return _ResultFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ResultFutureProvider && other.isRefreshed == isRefreshed;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isRefreshed.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ResultFutureRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `isRefreshed` of this provider.
  bool get isRefreshed;
}

class _ResultFutureProviderElement
    extends AutoDisposeFutureProviderElement<void> with ResultFutureRef {
  _ResultFutureProviderElement(super.provider);

  @override
  bool get isRefreshed => (origin as ResultFutureProvider).isRefreshed;
}

String _$resultControllerHash() => r'cede266b48b23c520a96a1ee06c53f8b2dab21dc';

/// See also [ResultController].
@ProviderFor(ResultController)
final resultControllerProvider =
    NotifierProvider<ResultController, List<Result>>.internal(
  ResultController.new,
  name: r'resultControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resultControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ResultController = Notifier<List<Result>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
