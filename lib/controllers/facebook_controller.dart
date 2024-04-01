import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/services/auth.dart';
import '../models/user_model.dart';
import '../services/database.dart';

class FacebookLoginController extends GetxController {
  User? user;

  void facebookAuthentication(language) async {
    try {
      authCont.isLoading.value = true;
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: (['email', 'public_profile']));
      final token = result.accessToken!.token;
      //print(
      // 'Facebook token userID : ${result.accessToken!.grantedPermissions}');
      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/'
          'v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));

      final profile = jsonDecode(graphResponse.body);
      //print("Profile is equal to $profile");
      try {
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookCredential);
        authCont.isLoading.value = false;

        user = userCredential.user;
        //creating firestore User
        final UserModel _user = UserModel(
            id: user!.uid,
            fullName: user!.displayName,
            phone: user!.phoneNumber,
            profilePic: user!.photoURL,
            email: user!.email,
            password: "Facebook auth not allow to show pass",
            alias: "Optional",
            language: language,
            showAlias: false,
            showNumber: false);
        AuthService.createUser(_user).then((value) {
          authCont.isLoading.value = false;
        });
      } catch (e) {
        final snackBar = SnackBar(
          margin: const EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
          backgroundColor: (Colors.redAccent),
          action: SnackBarAction(
            label: 'dismiss',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(snackBar);
      }
    } catch (e) {
      authCont.isLoading.value = false;

      //print("error occurred");
      //print(e.toString());
    }
  }
}
