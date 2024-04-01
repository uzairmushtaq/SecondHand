import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/size_config.dart';

class ShowFreeItemsWidget extends StatelessWidget {
  const ShowFreeItemsWidget({
    Key? key,
    required this.press,
    required this.changeValue,
    required this.title,
    required this.equalValue,
  }) : super(key: key);
  final VoidCallback press;
  final int changeValue;
  final int equalValue;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 1),
      child: Row(
        children: [
          IconButton(
              onPressed: press,
              icon: SizedBox(
                height: 21,
                width: 22,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 2,
                      child: Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                                color: changeValue == equalValue
                                    ? kPrimaryColor
                                    : const Color(0xFF94A3B8),
                                width: 1.5)),
                      ),
                    ),
                    Positioned(
                      top: 1,
                      left: 1,
                      child: changeValue == equalValue
                          ? Icon(
                        Icons.close,
                        color: kSecondaryColor,
                        size: 16,
                      )
                          : const SizedBox(),
                    )
                  ],
                ),
              )),
          SizedBox(
            width: SizeConfig.widthMultiplier * 0.3,
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 0.8),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.textMultiplier * 1.6),
            ),
          )
        ],
      ),
    );
  }
}