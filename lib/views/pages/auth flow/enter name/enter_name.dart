import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:secondhand/views/pages/auth%20flow/enter%20password/enter_password.dart';
import 'package:secondhand/views/widgets/second_hand_text.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import '../../../widgets/custom_auth_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnterNamePage extends StatelessWidget {
  EnterNamePage({Key? key}) : super(key: key);
  final controller = Get.find<SignupCont>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: ShowLoading(
          inAsyncCall: authCont.isLoading.value,
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
                          'Now, your full name :)',
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
                            child: CustomAuthInputField(
                                controller: controller.nameCont,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  if (!value.contains(' ')) {
                                    return 'Please enter your full name';
                                  }
                                },
                                hintText: 'Full Name')),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 4,
                        ),
                        NextButton(
                            title: AppLocalizations.of(context)!.next,
                            color: kSecondaryColor,
                            borderColor: kSecondaryColor,
                            textColor: kWhiteColor,
                            icon: Icons.arrow_forward_ios_rounded,
                            press: () async {
                              if (formKey.currentState!.validate()) {
                                Get.to(() => EnterPasswordPage());
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
    );
  }
}
