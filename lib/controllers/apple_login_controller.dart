import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/services/auth.dart';
import 'package:secondhand/utils/root.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user_model.dart';
import 'package:crypto/crypto.dart';

class AppleLoginController extends GetxController {
 

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void appleAuthentication(String language) async {
 User? user;
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    try {
      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      authCont.isLoading.value = false;

      user = userCredential.user;
      //creating firestore User
      final UserModel _user = UserModel(
          id: user!.uid,
          fullName: user!.displayName,
          phone: user!.phoneNumber,
          profilePic: user!.photoURL,
          email: user!.email,
          password: "Apple auth not allow to show pass",
          alias: "Optional",
          language: "language",
          showAlias: false,
          showNumber: false);
      AuthService.createUser(_user).then((value) {
        

             Navigator.pushAndRemoveUntil<dynamic>(
        Get.overlayContext!,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => Root(),
        ),
        (route) => false,
      );
        
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


    /*
    try {
      authCont.isLoading.value  = true;
      final LoginResult result = await AppleAuth.instance
          .login(permissions: (['email', 'public_profile']));
      final token = result.accessToken!.token;
      //print(
          'Apple token userID : ${result.accessToken!.grantedPermissions}');
      final graphResponse = await http.get(Uri.parse(
          'https://graph.apple.com/'
          'v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));

      final profile = jsonDecode(graphResponse.body);
      //print("Profile is equal to $profile");
      try {
        final AuthCredential appleCredential =
            AppleAuthProvider.credential(result.accessToken!.token);
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(appleCredential);
         authCont.isLoading.value  = false;

        user = userCredential.user;
        //creating firestore User
        final UserModel _user = UserModel(
            id: user!.uid,
            fullName: user!.displayName,
            phone: user!.phoneNumber,
            profilePic: user!.photoURL,
            email: user!.email,
            password: "Apple auth not allow to show pass",
            alias: "Optional",
            showAlias: false,
            showNumber: false);
        AuthService.createUser(_user).then((value) {
          Get.put(authController());
       
          authCont.isLoading.value  = false;
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
         authCont.isLoading.value  = false;

      //print("error occurred");
      //print(e.toString());
    }

     */
  }
}
