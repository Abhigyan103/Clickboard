import 'package:get/get.dart';
import '../../features/authentication/controllers/input_controller.dart';

class InitDependency implements Bindings {
  @override
  void dependencies() {
    Get.put(InputController());
  }
}
