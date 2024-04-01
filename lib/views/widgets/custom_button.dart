import 'package:flutter/material.dart';
import 'package:secondhand/utils/size_config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.title,
    required this.color,
    required this.borderColor,
    required this.textColor,
    required this.press,
    this.widget
  }) : super(key: key);
  final String? title;
  final Color color, borderColor, textColor;
  final VoidCallback press;
  final Widget? widget;
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
        child: Center(
          child: (title != null) ? Text(title!,
              style: TextStyle(
                  color: textColor,
                  fontSize: SizeConfig.textMultiplier * 2.2,
                  fontWeight: FontWeight.w600)) : widget,
        ),
      ),
    );
  }
}
