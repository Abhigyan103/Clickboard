// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resultFutureHash() => r'ef3586d068ba1df55255c1c3dfb19ab614e79638';

/// See also [resultFuture].
@ProviderFor(resultFuture)
final resultFutureProvider = AutoDisposeFutureProvider<void>.internal(
  resultFuture,
  name: r'resultFutureProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$resultFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ResultFutureRef = AutoDisposeFutureProviderRef<void>;
String _$resultControllerHash() => r'f5a54c3ebe3a9a0e7bc500f29ada6ebe0d70e9a7';

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
