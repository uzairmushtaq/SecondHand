import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/services/auth.dart';
import 'package:secondhand/services/geo_locator.dart';
import 'package:secondhand/services/send_email.dart';
import 'package:secondhand/utils/root.dart';
import 'package:secondhand/views/pages/auth%20flow/enter%20name/enter_name.dart';
import 'package:secondhand/views/pages/auth%20flow/enter%20otp/enter_otp.dart';
import 'package:secondhand/views/pages/auth%20flow/welldone/welldone.dart';
import 'package:secondhand/views/pages/register%20or%20signin/register_signin.dart';
import '../constants/colors.dart';
import '../models/user_model.dart';
import '../views/widgets/custom_auth_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthController extends GetxController {
  //FOR LOADING
  RxBool isLoading = false.obs;
  //FOR LOCATION
  RxDouble userLat = 0.0.obs;
  RxDouble userLng = 0.0.obs;
  RxBool isLocationPermission = false.obs;
  //for otp verification
  RxString verificationCode = "".obs;
  RxString countryCode = "".obs;
  RxBool isFirstSignup = false.obs;
  //FOR WELCOME PAGE
  RxBool isWeldonePage = false.obs;
  //here we are making instance of firebase auth
  final _auth = FirebaseAuth.instance;

  //Here we take FirebaseUser as observable
  final Rxn<User> _firebaseUser = Rxn<User>();

  //Here we use getter for making the user data email to call anywhere in the app
  String? get user => _firebaseUser.value?.email;

  //Here we take User Model as observable for showing the user data in the app
  Rxn<UserModel> userModel = Rxn<UserModel>();

  //Here we get and set the usermodel data for using anywhere in the app
  UserModel? get userInfo => userModel.value;
  // set userInfo(UserModel value) => userModel.value = value;

  //Here we are getting the userData
  User? get userss => _firebaseUser.value;

  @override
  // ignore: type_annotate_public_apis
  onInit() {
    //Here we bind the stream which is used getting the data in the stream which have more then one type of data it is only used on observable list only
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  //Here we create a method of getting all the data from the user like name,email,etc
  // ignore: type_annotate_public_apis
  Stream<UserModel> streamCurrentUser() {
    return //It is getting data from the collection of "Users" which is in the database(uid is the unique id of each user in the app)
        FirebaseFirestore.instance
            .collection('Users')
            .doc(userss!.uid)
            .snapshots()
            .map((DocumentSnapshot doc) {
      UserModel user = UserModel();
      user = UserModel.fromDocumentSnapshot(doc);
      return user;
    });
  }

  //Here we create a signin method which inlcudes email and password which are coming from the signin page
  // ignore: type_annotate_public_apis
  onSignIn(String email, String password) async {
    try {
      isLoading.value = true;
      //if the sign in done successfully then it will go to the homepage otherwise it shows error
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        isLoading.value = false;
      }).then((value) => Get.offAll(const Root()));
    } catch (e) {
      isLoading.value = false;
      customSnackBar(
          AppLocalizations.of(Get.overlayContext!)!.no_user_or_password,
          AppLocalizations.of(Get.overlayContext!)!.try_again);
    }
  }

  // ignore: type_annotate_public_apis
  onSignOut() async {
    try {
      try {
        await GoogleSignIn().signOut();
      } catch (e) {
        print(e);
      }
      await _auth
          .signOut()
          .then((value) => Get.offAll(() => RegistorOrSigninPage()));
      // .then((value) => Get.offAll(const LoginChoicePage()));

  isLoading.value = false;
    } catch (e) {
      customSnackBar('Error', "$e");
    }
  }

  // ignore: type_annotate_public_apis
  passResetEmail(String email) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: email)
          .then((value) => customSnackBar(
              //"Successfully sent :)",
              AppLocalizations.of(Get.overlayContext!)!.successfully_sent,
              //"You can reset your password thorugh the reset email which is sent to your account. Go and check!"))));
              AppLocalizations.of(Get.overlayContext!)!.reset_password_text));
    } catch (e) {
      customSnackBar(
          //"Error in reseting password",
          AppLocalizations.of(Get.overlayContext!)!.error_reseting_password,
          "$e".split("]")[1]);
    }
  }

  

  //check phone exists or not
  // checkPhoneNumber() async {
  //   final globalCont = Get.find<GlobalUIController>();
  //   authCont.isLoading.value = true;
  //   String phone = countryCode.value + phoneCont.text;
  //   if (phone.length > 8) {
  //     var value = await FirebaseFirestore.instance
  //         .collection("Users")
  //         .where('Phone', isEqualTo: "+" + phone)
  //         .get();
  //     if (value.docs.isNotEmpty) {
  //       globalCont.isPhoneOkay.value = true;
  //       customSnackBar(
  //           // AppLocalizations.of(context)!.already_exists,
  //           "Account already exists.",
  //           // AppLocalizations.of(context)!.chose_another
  //           "Please, choose another one :)");
  //     } else {
  //       globalCont.isPhoneOkay.value = false;
  //       isWeldonePage.value = true;
  //       isFirstSignup.value = true;
  //       Locale appLocale = Localizations.localeOf(Get.overlayContext!);
  //       await GeoLocatorService.getCurrentLocation();
  //       await createAccount(appLocale.languageCode);
  //     }
  //   } else {
  //     globalCont.isPhoneOkay.value = true;
  //     customSnackBar(
  //         //AppLocalizations.of(context)!.wrong_phone_number
  //         //
  //         "Your phone number is wrong.",
  //         //AppLocalizations.of(context)!.chose_another
  //         //
  //         "Please, choose another one :)");
  //   }
  // }

}
