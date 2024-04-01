import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/controllers/auth_controller.dart';

import 'package:secondhand/utils/root.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/second_hand_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:secondhand/views/widgets/show_loading.dart';

class WelldonePage extends GetWidget<AuthController> {
  const WelldonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: ShowLoading(
          inAsyncCall: authCont.isLoading.value,
          child: Scaffold(
            backgroundColor: kLightYellow,
            body: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
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
                      height: SizeConfig.heightMultiplier * 8,
                    ),
                    //signup img
                    Image.asset(wellDoneImg),
                    Text(
                      "Well done!",
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 5,
                          color: kTextColor,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    Text(
                      AppLocalizations.of(context)!.everything_ready,
                      //"Everything is ready, so let’s start :)",
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 2.2,
                          color: klightGreen,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 8,
                    ),
                    //GET STARTED BUTTON
                    GestureDetector(
                      onTap: () => _onGetStarted(),
                      child: Container(
                          height: SizeConfig.heightMultiplier * 5.5,
                          width: SizeConfig.widthMultiplier * 90,
                          decoration: BoxDecoration(
                              color: kSecondaryColor,
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                            child: Text(
                                AppLocalizations.of(context)!.get_started,
                                //"Get Started",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    fontWeight: FontWeight.w600)),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onGetStarted() {
    controller.isWeldonePage.value = false;
    Get.offAll(() => Root());
  }
}
