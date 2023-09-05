import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/utils/utils.dart';
import '../../../models/carousel_model.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/utils_providers.dart';

final carouselRepositoryProvider = Provider(
  (ref) => CarouselRepository(
    firebaseStorage: ref.watch(storageProvider),
    roll: ref.watch(userProvider)!.roll,
  ),
);

class CarouselRepository {
  final Reference _carouselRef;
  final String department;

  CarouselRepository(
      {required FirebaseStorage firebaseStorage, required String roll})
      : department = departments[int.parse(roll[7]) - 1],
        _carouselRef = firebaseStorage
            .ref('${departments[int.parse(roll[7]) - 1]}/Carousel');
  Future<List<CarouselImage>> getAllImages() async {
    List<CarouselImage> imageUrls = [];
    try {
      ListResult images = await _carouselRef.listAll();
      for (var fileRef in images.items) {
        await fileRef
            .getMetadata()
            .then((value) async => imageUrls.add(CarouselImage(
                  ref: fileRef,
                  timeCreated: value.timeCreated!,
                  url: await fileRef.getDownloadURL(),
                )));
      }
    } finally {
      imageUrls = imageUrls
          .sortWithDate((instance) => instance.timeCreated)
          .reversed
          .toList();
    }
    return imageUrls;
  }
}
