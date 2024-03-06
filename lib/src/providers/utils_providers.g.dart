// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utils_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myUserHash() => r'4cbcd2b414c42e34d6b3c1f0203e1b5c1aa6fdda';

/// See also [MyUser].
@ProviderFor(MyUser)
final myUserProvider = NotifierProvider<MyUser, Student?>.internal(
  MyUser.new,
  name: r'myUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyUser = Notifier<Student?>;
String _$myPhotoHash() => r'4dc88089fedb469fb4578600cd79e5cb637f4f1a';

/// See also [MyPhoto].
@ProviderFor(MyPhoto)
final myPhotoProvider = AutoDisposeNotifierProvider<MyPhoto, Image?>.internal(
  MyPhoto.new,
  name: r'myPhotoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myPhotoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyPhoto = AutoDisposeNotifier<Image?>;
String _$navigationIndexHash() => r'0dcf17ffae80a5006c78698de9bf96144ea1ef3e';

/// See also [NavigationIndex].
@ProviderFor(NavigationIndex)
final navigationIndexProvider =
    AutoDisposeNotifierProvider<NavigationIndex, int>.internal(
  NavigationIndex.new,
  name: r'navigationIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$navigationIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NavigationIndex = AutoDisposeNotifier<int>;
String _$timeRemainingHash() => r'7afdf88b739a8b612d6005e81950d1b6db5465ba';

/// See also [TimeRemaining].
@ProviderFor(TimeRemaining)
final timeRemainingProvider =
    AutoDisposeNotifierProvider<TimeRemaining, double>.internal(
  TimeRemaining.new,
  name: r'timeRemainingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timeRemainingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TimeRemaining = AutoDisposeNotifier<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
