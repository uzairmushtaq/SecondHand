import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../controllers/selected_text_controller.dart';

class CustomRadioPriceButtons extends StatefulWidget {
  const CustomRadioPriceButtons({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomRadioPriceButtons> createState() =>
      _CustomRadioPriceButtonsState();
}

class _CustomRadioPriceButtonsState extends State<CustomRadioPriceButtons> {
  int distanceGroupValue = -1;
  final globalCont = Get.find<GlobalUIController>();
  @override
  Widget build(BuildContext context) {
    //print(globalCont.isFreePrice.value);
    return SizedBox(
      width: SizeConfig.widthMultiplier * 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                distanceGroupValue = 0;
              });
              globalCont.isFreePrice.value = true;
            },
            icon: Container(
              height: SizeConfig.heightMultiplier * 2,
              width: SizeConfig.widthMultiplier * 5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: distanceGroupValue == 0
                          ? kPrimaryColor
                          : const Color(0xFF94A3B8),
                      width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(1.2),
                child: Container(
                  height: SizeConfig.heightMultiplier * 2,
                  width: SizeConfig.widthMultiplier * 5,
                  decoration: BoxDecoration(
                      color: distanceGroupValue == 0
                          ? kPrimaryColor
                          : Colors.white,
                      shape: BoxShape.circle),
                ),
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.for_free,
            //"For free",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.6),
          ),
          SizedBox(
            width: SizeConfig.widthMultiplier * 20,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                distanceGroupValue = 1;
              });
              globalCont.isFreePrice.value = false;
            },
            icon: Container(
              height: SizeConfig.heightMultiplier * 2,
              width: SizeConfig.widthMultiplier * 5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: distanceGroupValue == 1
                          ? kPrimaryColor
                          : const Color(0xFF94A3B8),
                      width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(1.2),
                child: Container(
                  height: SizeConfig.heightMultiplier * 2,
                  width: SizeConfig.widthMultiplier * 5,
                  decoration: BoxDecoration(
                      color: distanceGroupValue == 1
                          ? kPrimaryColor
                          : Colors.white,
                      shape: BoxShape.circle),
                ),
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.for_swapping,
            //"For swapping",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.6),
          ),
        ],
      ),
    );
  }
}
