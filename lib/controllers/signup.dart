import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/models/user_model.dart';
import 'package:secondhand/services/auth.dart';
import 'package:secondhand/services/geo_locator.dart';
import 'package:secondhand/services/send_email.dart';
import 'package:secondhand/views/pages/auth%20flow/enter%20name/enter_name.dart';
import 'package:secondhand/views/pages/auth%20flow/enter%20otp/enter_otp.dart';
import 'package:secondhand/views/pages/auth%20flow/welldone/welldone.dart';
import 'package:secondhand/views/widgets/custom_auth_snackbar.dart';

class SignupCont extends GetxController {
  RxString verificationCode = ''.obs;

  //TEXT EDITING CONTROLLERs
  TextEditingController emailCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController confirmPassCont = TextEditingController();
  
  //OTP verification
  Future<void> sendOTP() async {
    try {
      Random rand = Random();
      var code = rand.nextInt(900000) + 100000;
      SendEmailService.sendOtpEmail(
          emailCont.text, code, emailCont.text.split('@')[0]);
      print("This is the thing $code");
      verificationCode.value = code.toString();
    } catch (e) {
      customSnackBar(
          //"The code is not right.",
          AppLocalizations.of(Get.overlayContext!)!.sms_your_verification_code,
          //"Please, write a valid one :)",
          AppLocalizations.of(Get.overlayContext!)!.write_valid_one);
    }
  }

  checkCode(String otpCode) async {
    try {
      if (verificationCode.value == otpCode) {
        authCont.isLoading.value = false;
        Get.to(() => EnterNamePage());
      } else {
        authCont.isLoading.value = false;
        customSnackBar(
            //"The code is not right.",
            AppLocalizations.of(Get.overlayContext!)!.code_no_right,
            //"Please, write a valid one :)",
            AppLocalizations.of(Get.overlayContext!)!.write_valid_one);
      }
    } catch (e) {
      authCont.isLoading.value = false;
      customSnackBar(AppLocalizations.of(Get.overlayContext!)!.code_no_right,
          AppLocalizations.of(Get.overlayContext!)!.write_valid_one);
    }
  }

  //on verify phone
  Future<void> createAccount(String language) async {
    authCont.isLoading.value=true;
    final UserCredential _authResult =
        await kfirebaseAuth.createUserWithEmailAndPassword(
            email: emailCont.text.trim(), password: passCont.text);

    //creating user in the database
    //UserModel is the model where the data of the user goes and then we show the user data from the model class by the user controller in the app
    final UserModel _user = UserModel(
        id: _authResult.user?.uid,
        fullName: nameCont.text,
        profilePic: AppLocalizations.of(Get.overlayContext!)!.not_added_yet,
        email: emailCont.text,
        // phone: "+${countryCode.value}${phoneCont.text}",
        password: passCont.text,
        alias: "Optional",
        language: language,
        showAlias: false,
        showNumber: false);

    // if a user is successfully created then it goes to the homepage
    if (await AuthService.createUser(_user)) {
      Navigator.pushAndRemoveUntil<dynamic>(
        Get.overlayContext!,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => WelldonePage(),
        ),
        (route) => false,
      );
      authCont.isLoading.value = false;
    }
  }

  //check email exists or not
  checkEmailExistsOrNot(GlobalKey<FormState> formKey) async {
    authCont.isLoading.value = true;
    if (formKey.currentState!.validate()) {
      await kfirestore
          .collection("Users")
          .where("Email", isEqualTo: emailCont.text)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          authCont.isLoading.value = false;

          Get.to(() => EnterOTPpage(), transition: Transition.leftToRight);
        } else {
          authCont.isLoading.value = false;

          customSnackBar(
              'Account already exists', 'Please, choose another one :)');
        }
      });
    } else {
      authCont.isLoading.value = false;
      customSnackBar("Your email does not match our requirements.",
          "Please, enter the correct one :)");
    }
  }

  //AFTER SUCCESSFULL SIGNUP
  Future<void> goToWellDonePage() async {
    authCont.isLoading.value = true;
    final globalCont = Get.find<GlobalUIController>();
    globalCont.isPhoneOkay.value = false;
    authCont.isWeldonePage.value = true;
    authCont.isFirstSignup.value = true;
    Locale appLocale = Localizations.localeOf(Get.overlayContext!);
    await GeoLocatorService.getCurrentLocation();
    await createAccount(appLocale.languageCode);
    authCont.isLoading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    emailCont.dispose();
    nameCont.dispose();
    phoneCont.dispose();
    passCont.dispose();
    confirmPassCont.dispose();
  }
}
