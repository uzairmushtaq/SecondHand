import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/controllers/apple_login_controller.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/controllers/facebook_controller.dart';
import 'package:secondhand/controllers/google_login_controller.dart';
import 'package:secondhand/controllers/signup.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/auth%20flow/enter%20email/enter_email.dart';
import 'package:secondhand/views/widgets/second_hand_text.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'components/social_button.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final cont = Get.find<AuthController>();
  final registerCont=Get.put(SignupCont());
  @override
  Widget build(BuildContext context) {
    return Obx(() => ShowLoading(
        child: registerUI(context), inAsyncCall: cont.isLoading.value));
  }

  @override
  Widget registerUI(BuildContext context) {
    final textFontSize = SizeConfig.textMultiplier * 4.2;
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: kLightYellow,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 8,
              ),
              //second hand text widget
              const SecondHandTextWidget(),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              //signup img
              Image.asset(signUpImg),
              //signup text
              SizedBox(
                width: SizeConfig.widthMultiplier * 73,
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: AppLocalizations.of(context)!.choose_how + " ",
                      style: TextStyle(
                          fontSize: textFontSize,
                          color: kTextColor,
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: AppLocalizations.of(context)!.sign_up,
                      style: TextStyle(
                          fontSize: textFontSize,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w700))
                ])),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 4,
              ),
              //social sign up buttons
              SocialSignUpButton(
                  icon: emailIcon,
                  title: "E-Mail",
                  press: () {
                    Get.to(() =>  EnterEmailPage(),
                        transition: Transition.leftToRight);
                  }),
              Platform.isIOS
                  ? SocialSignUpButton(
                      icon: appleIcon,
                      title: "Apple",
                      press: () {
                        Locale appLocale = Localizations.localeOf(context);
                        Get.find<AppleLoginController>()
                            .appleAuthentication(appLocale.languageCode);
                      })
                  : const SizedBox(),
              SocialSignUpButton(
                  icon: facebookIcon,
                  title: "Facebook",
                  press: () {
                    Locale appLocale = Localizations.localeOf(context);
                    Get.find<FacebookLoginController>()
                        .facebookAuthentication(appLocale.languageCode);
                  }),
              SocialSignUpButton(
                  icon: gmailIcon,
                  title: "Google",
                  press: () {
                    Locale appLocale = Localizations.localeOf(context);
                    Get.find<GoogleLoginController>()
                        .onGoogleSignIn(appLocale.languageCode);
                  }),
              //go back button
              Center(
                child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(AppLocalizations.of(context)!.go_back,
                        style: TextStyle(
                            color: klightGreen,
                            fontSize: SizeConfig.textMultiplier * 1.9,
                            fontWeight: FontWeight.w600))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
