import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:websafe_svg/websafe_svg.dart';

class CustomAuthSnackBar extends StatelessWidget {
  const CustomAuthSnackBar({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);
  final String title, subTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 17,
      width: SizeConfig.widthMultiplier * 100,
      decoration: BoxDecoration(
          color: title == "Payment successfull" || title=="Successfully sent :)" ? kSecondaryColor : kRedColor,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
              },
              icon: WebsafeSvg.asset(cancelIcon, color: Colors.white)),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.textMultiplier * 2.5,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4),
            child: Text(
              subTitle,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: SizeConfig.textMultiplier * 1.8),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 2,
          ),
        ],
      ),
    );
  }
}

//custom snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar(
      String title, String subtitle) {
    return ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(SnackBar(
        backgroundColor: kLightYellow,
        padding: EdgeInsets.all(0),
        content: CustomAuthSnackBar(title: title, subTitle: subtitle)));
  }