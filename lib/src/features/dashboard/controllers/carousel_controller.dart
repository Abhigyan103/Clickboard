import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/utils_providers.dart';
import '../repository/carousel_repository.dart';

part 'carousel_controller.g.dart';

@riverpod
Future<void> carouselFuture(CarouselFutureRef ref, {bool isRefreshed = false}) {
  return ref.watch(carouselControllerProvider.notifier).getAllImages(isRefreshed: isRefreshed);
}

@Riverpod(keepAlive: true)
class CarouselController extends _$CarouselController {
  late CarouselRepository _carouselRepository;

  @override
  List<Image> build() {
    init();
    return [];
  }

  init() {
    _carouselRepository = CarouselRepository(
      firebaseStorage: FirebaseStorage.instance,
    );
  }

  Future<void> getAllImages({bool isRefreshed = false}) async {
    if (!isRefreshed && state.isNotEmpty) return;
    state = await _carouselRepository.getAllImages();
  }
}
