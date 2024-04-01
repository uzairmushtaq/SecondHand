
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:secondhand/utils/root.dart';



class GoogleAuthController extends GetxController {
   User? user;
  FirebaseAuth auth = FirebaseAuth.instance;
   GoogleSignIn? googleSignIn;
  // ignore: type_annotate_public_apis
  var isSign = false.obs;
   GoogleAuthController? controller;
  @override
  void onInit() {
    googleSignIn = GoogleSignIn();
    // ever(isSign, handleAuth);
    isSign.value = auth.currentUser != null;
    auth.authStateChanges().listen((event) {
      isSign.value = event != null;
    });
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // ignore: type_annotate_public_apis
  // handleAuth(bool callback) {
    

  //   Future.delayed(const Duration(seconds: 2), () {
  //     if (callback) {
  //       Get.offAll(const Root());
  //     } else {
  //       // Get.offAll(const RegistorOrSigninPage());
  //     }
  //   });
  // }
}
