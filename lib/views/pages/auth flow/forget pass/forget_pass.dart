import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:secondhand/controllers/auth_controller.dart';


import '../../../../constants/colors.dart';
import '../../../../constants/images.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/custom_auth_snackbar.dart';
import '../../../widgets/second_hand_text.dart';
import '../../../widgets/next_button.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  bool showPass = true;
  TextEditingController emailCont = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    //signup img
                    Image.asset(signUpImg),
                    Center(child: Text(
                      AppLocalizations.of(context)!.forgot_password,
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 4,
                          color: kTextColor,
                          fontWeight: FontWeight.w700),
                    )),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    Text(
                      AppLocalizations.of(context)!.enter_mail,
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 2.2,
                          color: klightGreen,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    Form(
                      key: formKey,
                      child: SizedBox(
                        width: SizeConfig.widthMultiplier * 90,
                        child: TextFormField(
                          controller: emailCont,
                          //validation
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!.enter_mail;
                            }
                            if (!value.isEmail) {
                              return AppLocalizations.of(context)!.enter_mail;
                            }
                          },
                          decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kTextColor, width: 1)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kTextColor, width: 1)),
                              hintText: AppLocalizations.of(context)!.email,
                              hintStyle: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2.1,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF94A3B8))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 4,
                    ),
                    NextButton(
                        title: AppLocalizations.of(context)!.reset_link,
                        color: kSecondaryColor,
                        borderColor: kSecondaryColor,
                        textColor: kWhiteColor,
                        icon: Icons.arrow_forward_ios_rounded,
                        press: () {
                          if (formKey.currentState!.validate()) {
                            Get.find<AuthController>()
                                .passResetEmail(emailCont.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                  backgroundColor: kLightYellow,
                                  padding: EdgeInsets.all(0),
                                  content: CustomAuthSnackBar(
                                    title: AppLocalizations.of(context)!.password_not_match,
                                    subTitle: AppLocalizations.of(context)!.choose_another,
                                  )),
                            );
                          }
                        }),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    NextButton(
                        title: AppLocalizations.of(context)!.go_back,
                        color: kLightYellow,
                        borderColor: kSecondaryColor,
                        textColor: klightGreen,
                        icon: Icons.arrow_back_ios_new_rounded,
                        press: () {
                          Get.back();
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
