import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/carousel_model.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/utils_providers.dart';
import '../repository/carousel_repository.dart';

part 'carousel_controller.g.dart';

@riverpod
Future<void> carouselFuture(CarouselFutureRef ref) {
  return ref.watch(carouselControllerProvider.notifier).getAllImages();
}

@riverpod
class CarouselController extends _$CarouselController {
  late final CarouselRepository _carouselRepository;

  @override
  List<CarouselImage> build() {
    return [];
  }

  void init() {
    _carouselRepository = CarouselRepository(
      firebaseStorage: ref.watch(storageProvider),
      department: ref.watch(myUserProvider)!.dept,
    );
  }

  Future<void> getAllImages() async {
    state = await _carouselRepository.getAllImages();
    return;
  }
}
