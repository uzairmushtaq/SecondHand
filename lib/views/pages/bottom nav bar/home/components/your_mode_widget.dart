import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/your_mode_controller.dart';
import 'package:secondhand/enums/articles_type.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:secondhand/views/pages/articles/articles.dart';

class YourModeWidget extends StatelessWidget {
  YourModeWidget({
    Key? key, this.function, this.type
  }) : super(key: key);
  final Function? function;
  String? type;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<YourModeController>();
    Locale myLocale = Localizations.localeOf(context);
    return Obx(
          () => Center(
        child: Container(
          height: SizeConfig.heightMultiplier * 5.5,
          width: SizeConfig.widthMultiplier * 90,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: controller.yourModeIndex.value == 1
                      ? kPrimaryColor
                      : kSecondaryColor,
                  width: 1.5),
              borderRadius: BorderRadius.circular(50)),
          padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 1),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  if (type == 'home') {
                    Get.to(() => ArticlesPage(
                     shuffleType: ShuffleType.shuffled,
                      language: myLocale.languageCode),
                        transition: Transition.rightToLeft);
                  }
                  controller.yourModeIndex.value = 1;
                  if(function!=null){
                    function!();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Container(
                    height: SizeConfig.heightMultiplier * 4.5,
                    width: SizeConfig.widthMultiplier * 43,
                    decoration: BoxDecoration(
                        color: controller.yourModeIndex.value == 1
                            ? kPrimaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.buy,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: controller.yourModeIndex.value == 1
                                ? Colors.white
                                : Colors.black,
                            fontSize: SizeConfig.textMultiplier * 2.1),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.yourModeIndex.value = 2;
                  if(function!=null){
                    function!();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: SizeConfig.heightMultiplier * 4.5,
                  width: SizeConfig.widthMultiplier * 44,
                  decoration: BoxDecoration(
                      color: controller.yourModeIndex.value == 2
                          ? kSecondaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.sell,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: controller.yourModeIndex.value == 2
                              ? Colors.white
                              : Colors.black,
                          fontSize: SizeConfig.textMultiplier * 2.1),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
