import 'package:flutter/material.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/utils/size_config.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.title,
    required this.color,
    required this.borderColor,
    required this.textColor,
    required this.press,
    required this.icon,
  }) : super(key: key);
  final String title;
  final Color color, borderColor, textColor;
  final VoidCallback press;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: SizeConfig.heightMultiplier * 5.5,
        width: SizeConfig.widthMultiplier * 90,
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title == "Next" || title=="Get SMS" || title=="Verify"
                ? Text(title,
                    style: TextStyle(
                        color: textColor,
                        fontSize: SizeConfig.textMultiplier * 2,
                        fontWeight: FontWeight.w600))
                : Icon(
                    icon,
                    color: klightGreen,
                    size: SizeConfig.heightMultiplier * 1.7,
                  ),
            SizedBox(
              width: SizeConfig.widthMultiplier * 2,
            ),
            title == "Next" || title=="Get SMS" || title=="Verify"
                ? Icon(
                    icon,
                    color: Colors.white,
                    size: SizeConfig.heightMultiplier * 1.6,
                  )
                : Text(title,
                    style: TextStyle(
                        color: textColor,
                        fontSize: SizeConfig.textMultiplier * 2,
                        fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
