import 'package:flutter/material.dart';
import 'package:secondhand/utils/size_config.dart';

class CustomSmallButton extends StatelessWidget {
  CustomSmallButton({
    Key? key,
    required this.title,
    required this.color,
    required this.press,
    this.width
  }) : super(key: key);
  final String title;
  final Color color;
  final VoidCallback press;
  double? width = SizeConfig.widthMultiplier * 43;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        height: SizeConfig.heightMultiplier * 5,
        width: width ?? SizeConfig.widthMultiplier * 43,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}