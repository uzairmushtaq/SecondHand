import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/size_config.dart';

class MessageSendButton extends StatelessWidget {
  const MessageSendButton({
    Key? key,
    required this.press,
    required this.icon,
  }) : super(key: key);
  final VoidCallback press;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        height: SizeConfig.heightMultiplier * 6,
        width: SizeConfig.widthMultiplier * 12,
        margin: EdgeInsets.only(
            right: SizeConfig.widthMultiplier * 1,
            top: SizeConfig.heightMultiplier * 0.5,
            bottom: SizeConfig.heightMultiplier * 0.5),
        decoration:
            const BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
        child: Center(
            child: Icon(
          icon,
          size: 17,
          color: Colors.white,
        )),
      ),
    );
  }
}
