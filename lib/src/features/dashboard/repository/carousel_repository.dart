import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class CarouselRepository {
  final Reference _carouselRef;

  CarouselRepository(
      {required FirebaseStorage firebaseStorage})
      : _carouselRef = firebaseStorage.ref('Carousel');
  Future<List<Image>> getAllImages() async {
    List<Image> images = [];
    try {
      ListResult imagesResult = await _carouselRef.listAll();
      for (var fileRef in imagesResult.items) {
        String url = await fileRef.getDownloadURL();
        await fileRef
            .getMetadata()
            .then((value) async => images.add(Image.network(url,fit: BoxFit.cover,)));
      }
    } catch (e) {
      print('Error fetching carousels');
    }
    return images;
  }
}
