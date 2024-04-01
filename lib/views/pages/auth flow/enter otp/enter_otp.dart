import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/controllers/signup.dart';

import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/next_button.dart';
import 'package:secondhand/views/widgets/custom_auth_snackbar.dart';
import 'package:secondhand/views/widgets/second_hand_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:secondhand/views/widgets/show_loading.dart';

import 'components/otp_boxes.dart';

class EnterOTPpage extends StatefulWidget {
  const EnterOTPpage({
    Key? key,
  }) : super(key: key);

  @override
  State<EnterOTPpage> createState() => _EnterOTPpageState();
}

class _EnterOTPpageState extends State<EnterOTPpage> {
  //sending otp to that phone number which is coming from previous screen
  final authCont = Get.find<AuthController>();
  final controller = Get.find<SignupCont>();
  @override
  void initState() {
    Future.delayed(Duration.zero, () => controller.sendOTP());
    super.initState();
  }

  String checkPin = "";
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
                      duration: const Duration(milliseconds: 00),
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
                          //"Registration",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 5,
                              color: kTextColor,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                        Text(
                          AppLocalizations.of(context)!.last_step,
                          //"You are almost done, last step.",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 2.2,
                              color: klightGreen,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                        //OTP textfield
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 9,
                          width: SizeConfig.widthMultiplier * 82,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const OtpBoxes(),
                              OTPTextField(
                                length: 6,
                                width: MediaQuery.of(context).size.width,
                                fieldWidth: SizeConfig.widthMultiplier * 12,
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 3.5,
                                    fontWeight: FontWeight.w600),
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                otpFieldStyle: OtpFieldStyle(
                                    backgroundColor: Colors.transparent,
                                    borderColor: Colors.transparent,
                                    errorBorderColor: Colors.transparent,
                                    enabledBorderColor: Colors.transparent,
                                    focusBorderColor: Colors.transparent,
                                    disabledBorderColor: Colors.transparent),
                                fieldStyle: FieldStyle.box,
                                onCompleted: (pin) {
                                  setState(() {
                                    checkPin = pin;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 1,
                        ),
                        NextButton(
                            title: AppLocalizations.of(context)!.verify,
                            color: kSecondaryColor,
                            borderColor: kSecondaryColor,
                            textColor: kWhiteColor,
                            icon: Icons.arrow_forward_ios_rounded,
                            press: () {
                              if (checkPin != "") {
                                authCont.isLoading.value = true;
                                controller.checkCode(checkPin);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: kLightYellow,
                                        padding: EdgeInsets.all(0),
                                        content: CustomAuthSnackBar(
                                            title: "Error",
                                            subTitle: "Please enter otp")));
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
                            }),
                        Center(
                          child: TextButton(
                            onPressed: () => controller.sendOTP(),
                            child: Text(
                              AppLocalizations.of(context)!.receive_your_code,
                              //"Didn’t receive your code?",
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  color: klightGreen),
                            ),
                          ),
                        )
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
