import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/size_config.dart';

class RadioButtonDistanceOrPrice extends StatelessWidget {
  const RadioButtonDistanceOrPrice({
    Key? key,
    required this.press,
    required this.changeValue,
    required this.equalValue,
    required this.title,
  }) : super(key: key);

  final VoidCallback press;
  final int changeValue, equalValue;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: press,
          icon: Container(
            height: SizeConfig.heightMultiplier * 2,
            width: SizeConfig.widthMultiplier * 5,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                    color: changeValue == equalValue
                        ? kPrimaryColor
                        : const Color(0xFF94A3B8),
                    width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(1.2),
              child: Container(
                height: SizeConfig.heightMultiplier * 2,
                width: SizeConfig.widthMultiplier * 5,
                decoration: BoxDecoration(
                    color: changeValue == equalValue
                        ? kPrimaryColor
                        : Colors.white,
                    shape: BoxShape.circle),
              ),
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.6),
        ),
      ],
    );
  }
}

