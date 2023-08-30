import 'package:firebase_storage/firebase_storage.dart';

class CarouselImage {
  final String url;
  final DateTime timeCreated;
  final Reference ref;
  CarouselImage(
      {required this.url, required this.timeCreated, required this.ref});
}
