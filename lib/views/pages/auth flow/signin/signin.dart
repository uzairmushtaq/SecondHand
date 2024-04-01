import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/controllers/apple_login_controller.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/controllers/facebook_controller.dart';
import 'package:secondhand/controllers/google_login_controller.dart';

import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:secondhand/views/pages/auth%20flow/forget%20pass/forget_pass.dart';
import 'package:secondhand/views/pages/auth%20flow/resgister/register.dart';
import 'package:secondhand/views/widgets/custom_auth_snackbar.dart';
import 'package:secondhand/views/widgets/second_hand_text.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/password_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool showPass = true;
  bool isKeepLogin = false;
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();

  @override
  void initState() {
    super.initState();
 
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() => ShowLoading(
        child: signInUI(context), inAsyncCall: authCont.isLoading.value));
  }

  @override
  Widget signInUI(BuildContext context) {

    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: kLightYellow,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: SizedBox(
              width: SizeConfig.widthMultiplier * 100,
              child: AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 200),
                      childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                      children: [
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 8,
                        ),
                        //second hand text widget
                        const SecondHandTextWidget(),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 4,
                        ),
                        //signup img
                        Image.asset(
                          signInImg,
                          height: SizeConfig.heightMultiplier * 15,
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 3,
                        ),
                        //welcome back text
                        Text(
                          AppLocalizations.of(context)!.welcome_back,
                          textAlign: TextAlign.center,
                          style: TextStyle(
    
                              fontSize: SizeConfig.textMultiplier * 4.8,
                              color: kTextColor,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 3,
                        ),
                        //email textfield
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 90,
                          child: TextField(
                            controller: emailCont,
                            decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kTextColor, width: 1)),
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kTextColor, width: 1)),
                                hintText: AppLocalizations.of(context)!.email_or_username,
                                hintStyle: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2.1,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF94A3B8))),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                        //password textfield
                        PasswordField(passCont: passCont),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 1,
                        ),
                        //keep me logging in with checkBox & forgetpassword button
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 97,
                          child: Row(
                            children: [
                              //custom checkBox
                             const Spacer(),
                              //forget pass button
                              TextButton(
                                  onPressed: () {
                                    Get.to(() => ForgetPasswordPage(),
                                        transition: Transition.downToUp);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.forgot_password,
                                    style: TextStyle(
                                        fontSize: SizeConfig.textMultiplier * 1.7,
                                        color: const Color(0xFF94A3B8)),
                                  )),
                              SizedBox(
                                width: SizeConfig.widthMultiplier * 1,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 1,
                        ),
                        //signin button
                        GestureDetector(
                          onTap: () {
                            Get.find<AuthController>()
                                .onSignIn(emailCont.text, passCont.text);
                          },
                          child: Container(
                              height: SizeConfig.heightMultiplier * 5.5,
                              width: SizeConfig.widthMultiplier * 90,
                              decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                child: Text(AppLocalizations.of(context)!.sign_in,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: SizeConfig.textMultiplier * 2,
                                        fontWeight: FontWeight.w600)),
                              )),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(AppLocalizations.of(context)!.go_back,
                              style: TextStyle(
                                  color: kSecondaryColor,
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                        //or widget
    
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 1,
                                width: SizeConfig.widthMultiplier * 35,
                                color: const Color(0xFF94A3B8).withOpacity(0.3),
                              ),
                              Text(
                                AppLocalizations.of(context)!.or,
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF94A3B8)),
                              ),
                              Container(
                                height: 1,
                                width: SizeConfig.widthMultiplier * 35,
                                color: const Color(0xFF94A3B8).withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 3,
                        ),
                        //social login widgets
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 50,
                          child: Row(
                            mainAxisAlignment: Platform.isAndroid
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Locale appLocale = Localizations.localeOf(context);
                                  Get.find<AppleLoginController>().appleAuthentication(appLocale.languageCode);
                                },
                                child:  Platform.isAndroid
                                    ? SizedBox(
                                    height: SizeConfig.heightMultiplier * 0)
                                    : WebsafeSvg.asset(appleIcon,
                                    height: SizeConfig.heightMultiplier * 4),
                              ),
                              InkWell(
                                onTap: () {
                                  Locale appLocale = Localizations.localeOf(context);
                                  Get.find<GoogleLoginController>().onGoogleSignIn(appLocale.languageCode);
                                },
                                child: WebsafeSvg.asset(gmailIcon,
                                    height: SizeConfig.heightMultiplier * 4),
                              ),
                              Platform.isAndroid
                                  ? SizedBox(
                                      width: SizeConfig.widthMultiplier * 20,
                                    )
                                  : SizedBox(),
                              InkWell(
                                onTap: () {
                                  Locale appLocale = Localizations.localeOf(context);
                                  Get.find<FacebookLoginController>().facebookAuthentication(appLocale.languageCode);
                                },
                                child: WebsafeSvg.asset(facebookIcon,
                                    height: SizeConfig.heightMultiplier * 4),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 1,
                        ),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.dont_have_account,
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 1.7,
                                    color: const Color(0xFF94A3B8)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => RegisterPage(),
                                      transition: Transition.downToUp);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.create_account,
                                  style: TextStyle(
                                      fontSize: SizeConfig.textMultiplier * 1.7,
                                      color: const Color(0xFF94A3B8)),
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            )),
      ),
    );
  }
}
