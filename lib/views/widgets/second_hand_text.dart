import 'package:flutter/material.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/fontfamilies.dart';
import 'package:secondhand/utils/size_config.dart';

class SecondHandTextWidget extends StatelessWidget {
  const SecondHandTextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "Second",
            style: TextStyle(
                fontFamily: ConstantFontFamily.geckoLunch,
                color: kPrimaryColor,
                fontSize: SizeConfig.textMultiplier * 5)),
        TextSpan(
            text: "Hand",
            style: TextStyle(
                fontFamily: ConstantFontFamily.geckoLunch,
                color: kTextColor,
                fontSize: SizeConfig.textMultiplier * 5))
      ])),
    );
  }
}
