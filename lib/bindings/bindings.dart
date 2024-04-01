
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/google_controller.dart';
import '../controllers/google_login_controller.dart';
import '../controllers/user_controller.dart';

class AuthBindings extends Bindings {  
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
