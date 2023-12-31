import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/carousel_model.dart';
import '../repository/carousel_repository.dart';

final carouselProvider =
    StateNotifierProvider<CarouselController, List<CarouselImage>>(
  (ref) => CarouselController(
      carouselRepository: ref.watch(carouselRepositoryProvider)),
);
final carouselFutureProvider = FutureProvider<void>(
    (ref) async => ref.watch(carouselProvider.notifier).getAllImages());

class CarouselController extends StateNotifier<List<CarouselImage>> {
  final CarouselRepository _carouselRepository;
  CarouselController({required CarouselRepository carouselRepository})
      : _carouselRepository = carouselRepository,
        super([]);

  Future<void> getAllImages() async {
    state = await _carouselRepository.getAllImages();
    return;
  }
}
