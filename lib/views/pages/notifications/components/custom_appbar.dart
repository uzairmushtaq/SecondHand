import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/fontfamilies.dart';
import 'package:secondhand/utils/size_config.dart';

class NotificationsCustomAppBar extends StatelessWidget {
  const NotificationsCustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 13,
      width: SizeConfig.widthMultiplier * 100,
      decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          border: Border.all(color: kLightGrey.withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
       bottomLeft: Radius.circular(25),
       bottomRight: Radius.circular(25))),
      child: Padding(
        padding: EdgeInsets.only(
     top: SizeConfig.heightMultiplier * 5,
     left:SizeConfig.widthMultiplier*2,
     right: SizeConfig.widthMultiplier * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
    IconButton(
             onPressed: () {
               Get.back();
             },
             icon:  Icon(Icons.arrow_back_ios_new_rounded,
             size: SizeConfig.heightMultiplier*2.5,
                 color:const Color(0xFF475569))),
     RichText(
         text: TextSpan(children: [
       TextSpan(
           text: "Second",
           style: TextStyle(
               fontFamily: ConstantFontFamily.geckoLunch,
               color: kPrimaryColor,
               fontSize: SizeConfig.textMultiplier * 3.7)),
       TextSpan(
           text: "Hand",
           style: TextStyle(
               fontFamily: ConstantFontFamily.geckoLunch,
               color: kTextColor,
               fontSize: SizeConfig.textMultiplier * 3.7))
     ])),
     SizedBox(width: SizeConfig.widthMultiplier*10,)
          ],
        ),
      ),
    );
  }
}
