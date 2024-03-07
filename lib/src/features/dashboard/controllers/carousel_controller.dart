import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/carousel_model.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/utils_providers.dart';
import '../repository/carousel_repository.dart';

part 'carousel_controller.g.dart';

@riverpod
Future<void> carouselFuture(CarouselFutureRef ref, {bool isRefreshed = false}) {
  return ref.watch(carouselControllerProvider.notifier).getAllImages();
}

@Riverpod(keepAlive: true)
class CarouselController extends _$CarouselController {
  late CarouselRepository _carouselRepository;

  @override
  List<CarouselImage> build() {
    init();
    return [];
  }

  void init() {
    _carouselRepository = CarouselRepository(
      firebaseStorage: ref.read(storageProvider),
      department: ref.watch(myUserProvider)?.dept ?? '',
    );
  }

  Future<void> getAllImages({bool isRefreshed = false}) async {
    if (!isRefreshed && state.isNotEmpty) return;
    state = await _carouselRepository.getAllImages();
  }
}
