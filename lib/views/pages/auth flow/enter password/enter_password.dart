import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/controllers/signup.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/custom_auth_inputfield.dart';
import 'package:secondhand/views/widgets/next_button.dart';
import 'package:secondhand/views/widgets/second_hand_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:secondhand/views/widgets/show_loading.dart';

class EnterPasswordPage extends StatelessWidget {
  EnterPasswordPage({
    Key? key,
  }) : super(key: key);
  final controller =Get.find<SignupCont>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Obx(
        ()=> ShowLoading(
          inAsyncCall: authCont.isLoading.value,
          child: Scaffold(
            backgroundColor: kLightYellow,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: SizedBox(
                width: SizeConfig.widthMultiplier * 100,
                child: AnimationLimiter(
                  child: Form(
                    key: formKey,
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
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          //signup img
                          Image.asset(signUpImg),
                          Text(
                            AppLocalizations.of(context)!.registration,
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 5,
                                color: kTextColor,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          Text(
                            AppLocalizations.of(context)!.now_password,
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2.2,
                                color: klightGreen,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          CustomAuthInputField(
                              controller: controller.passCont,
                              isPassword: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.enter_password;
                                }
                                if (value.length < 8) {
                                  return AppLocalizations.of(context)!
                                      .minimum_8_characters;
                                  // A minimum 8 characters password contains a combination\nof uppercase and lowercase letter and number are required.
                                }
                              },
                              hintText: AppLocalizations.of(context)!.password),
                          CustomAuthInputField(
                              controller: controller.confirmPassCont,
                              isPassword: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.enter_password;
                                }
                                if (value != controller.passCont.text) {
                                  return AppLocalizations.of(context)!
                                      .password_not_match;
                                }
                              },
                              hintText:
                                  AppLocalizations.of(context)!.confirm_password),
            
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 4,
                          ),
                          NextButton(
                              title: AppLocalizations.of(context)!.next,
                              color: kSecondaryColor,
                              borderColor: kSecondaryColor,
                              textColor: kWhiteColor,
                              icon: Icons.arrow_forward_ios_rounded,
                              press: () {
                                if (formKey.currentState!.validate()) {
                                 controller.goToWellDonePage();
                                } else {
                              
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //       backgroundColor: kLightYellow,
                                  //       padding: EdgeInsets.all(0),
                                  //       content: CustomAuthSnackBar(
                                  //         title:
                                  //             "Your password does not match our requirements.",
                                  //         subTitle: "Please, choose another one :)",
                                  //       )),
                                  // );
                  
                                   
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
          ),
        ),
      ),
    );
  }
}
