import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/services/auth.dart';
import 'package:secondhand/utils/root.dart';

import '../models/user_model.dart';
import '../services/database.dart';
import 'articles_controller.dart';
import 'auth_controller.dart';
import 'google_controller.dart';


class GoogleLoginController extends GetxController {
  final controller = Get.put(GoogleAuthController());
  User? user;

  @override
  void onInit() {
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

  void onGoogleSignIn(language) async {
    authCont.isLoading.value = true;
    final GoogleSignInAccount? _googleSignInAccount =
        await Get.find<GoogleAuthController>().googleSignIn!.signIn();
         authCont.isLoading.value  = false;
    if (GoogleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await _googleSignInAccount!.authentication;
      final OAuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      final UserCredential credential =
          await controller.auth.signInWithCredential(authCredential);
      user = credential.user;
      //creating firestore User
      final UserModel _user = UserModel(
        id: user!.uid,
        fullName: user!.displayName,
        phone: user!.phoneNumber,
        profilePic: user!.photoURL,
        email: user!.email,
        password: "Google auth not allow to show pass",
        alias: "Optional",
        language: language,
        showAlias: false,
        showNumber: false
      );
      AuthService.createUser(_user).then((value) {
   
             Navigator.pushAndRemoveUntil<dynamic>(
        Get.overlayContext!,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => Root(),
        ),
        (route) => false,
      );
        
        
      });
    }
  }
}
