// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carousel_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$carouselFutureHash() => r'fbf6e0565f079eeb0d39e11bf14d76408ad6a6cc';

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

/// See also [carouselFuture].
@ProviderFor(carouselFuture)
const carouselFutureProvider = CarouselFutureFamily();

/// See also [carouselFuture].
class CarouselFutureFamily extends Family<AsyncValue<void>> {
  /// See also [carouselFuture].
  const CarouselFutureFamily();

  /// See also [carouselFuture].
  CarouselFutureProvider call({
    bool isRefreshed = false,
  }) {
    return CarouselFutureProvider(
      isRefreshed: isRefreshed,
    );
  }

  @override
  CarouselFutureProvider getProviderOverride(
    covariant CarouselFutureProvider provider,
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
  String? get name => r'carouselFutureProvider';
}

/// See also [carouselFuture].
class CarouselFutureProvider extends AutoDisposeFutureProvider<void> {
  /// See also [carouselFuture].
  CarouselFutureProvider({
    bool isRefreshed = false,
  }) : this._internal(
          (ref) => carouselFuture(
            ref as CarouselFutureRef,
            isRefreshed: isRefreshed,
          ),
          from: carouselFutureProvider,
          name: r'carouselFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$carouselFutureHash,
          dependencies: CarouselFutureFamily._dependencies,
          allTransitiveDependencies:
              CarouselFutureFamily._allTransitiveDependencies,
          isRefreshed: isRefreshed,
        );

  CarouselFutureProvider._internal(
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
    FutureOr<void> Function(CarouselFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CarouselFutureProvider._internal(
        (ref) => create(ref as CarouselFutureRef),
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
    return _CarouselFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CarouselFutureProvider && other.isRefreshed == isRefreshed;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isRefreshed.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CarouselFutureRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `isRefreshed` of this provider.
  bool get isRefreshed;
}

class _CarouselFutureProviderElement
    extends AutoDisposeFutureProviderElement<void> with CarouselFutureRef {
  _CarouselFutureProviderElement(super.provider);

  @override
  bool get isRefreshed => (origin as CarouselFutureProvider).isRefreshed;
}

String _$carouselControllerHash() =>
    r'69de11431e8feca792634d1cc97349c0bbedec33';

/// See also [CarouselController].
@ProviderFor(CarouselController)
final carouselControllerProvider =
    NotifierProvider<CarouselController, List<CarouselImage>>.internal(
  CarouselController.new,
  name: r'carouselControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$carouselControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CarouselController = Notifier<List<CarouselImage>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
