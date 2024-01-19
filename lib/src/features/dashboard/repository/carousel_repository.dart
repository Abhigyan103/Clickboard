import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';

import '../../../models/carousel_model.dart';

class CarouselRepository {
  final Reference _carouselRef;
  final String department;

  CarouselRepository(
      {required FirebaseStorage firebaseStorage, required this.department})
      : _carouselRef = firebaseStorage.ref('$department/Carousel');
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
