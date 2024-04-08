// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$documentFutureHash() => r'67203aa5d3c1189aa4a396efc747d84b563a2208';

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

/// See also [documentFuture].
@ProviderFor(documentFuture)
const documentFutureProvider = DocumentFutureFamily();

/// See also [documentFuture].
class DocumentFutureFamily extends Family<AsyncValue<void>> {
  /// See also [documentFuture].
  const DocumentFutureFamily();

  /// See also [documentFuture].
  DocumentFutureProvider call({
    bool isRefreshed = false,
  }) {
    return DocumentFutureProvider(
      isRefreshed: isRefreshed,
    );
  }

  @override
  DocumentFutureProvider getProviderOverride(
    covariant DocumentFutureProvider provider,
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
  String? get name => r'documentFutureProvider';
}

/// See also [documentFuture].
class DocumentFutureProvider extends AutoDisposeFutureProvider<void> {
  /// See also [documentFuture].
  DocumentFutureProvider({
    bool isRefreshed = false,
  }) : this._internal(
          (ref) => documentFuture(
            ref as DocumentFutureRef,
            isRefreshed: isRefreshed,
          ),
          from: documentFutureProvider,
          name: r'documentFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$documentFutureHash,
          dependencies: DocumentFutureFamily._dependencies,
          allTransitiveDependencies:
              DocumentFutureFamily._allTransitiveDependencies,
          isRefreshed: isRefreshed,
        );

  DocumentFutureProvider._internal(
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
    FutureOr<void> Function(DocumentFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DocumentFutureProvider._internal(
        (ref) => create(ref as DocumentFutureRef),
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
    return _DocumentFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentFutureProvider && other.isRefreshed == isRefreshed;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isRefreshed.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DocumentFutureRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `isRefreshed` of this provider.
  bool get isRefreshed;
}

class _DocumentFutureProviderElement
    extends AutoDisposeFutureProviderElement<void> with DocumentFutureRef {
  _DocumentFutureProviderElement(super.provider);

  @override
  bool get isRefreshed => (origin as DocumentFutureProvider).isRefreshed;
}

String _$documentControllerHash() =>
    r'e5527b26dd98785b9607db891b545f784bd6d09c';

/// See also [DocumentController].
@ProviderFor(DocumentController)
final documentControllerProvider =
    NotifierProvider<DocumentController, List<Document>>.internal(
  DocumentController.new,
  name: r'documentControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$documentControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DocumentController = Notifier<List<Document>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
