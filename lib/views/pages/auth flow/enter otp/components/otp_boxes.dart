import 'package:flutter/material.dart';
import 'package:secondhand/utils/size_config.dart';


class OtpBoxes extends StatelessWidget {
  const OtpBoxes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: SizeConfig.heightMultiplier * 6,
            width: SizeConfig.widthMultiplier * 11,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(13)),
          ),
           Container(
            height: SizeConfig.heightMultiplier * 6,
            width: SizeConfig.widthMultiplier * 11,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(13)),
          ),
           Container(
            height: SizeConfig.heightMultiplier * 6,
            width: SizeConfig.widthMultiplier * 11,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(13)),
          ),
           Container(
            height: SizeConfig.heightMultiplier * 6,
            width: SizeConfig.widthMultiplier * 11,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(13)),
          ),
           Container(
            height: SizeConfig.heightMultiplier * 6,
            width: SizeConfig.widthMultiplier * 11,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(13)),
          ),
           Container(
            height: SizeConfig.heightMultiplier * 6,
            width: SizeConfig.widthMultiplier * 11,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(13)),
          )
        ],
      ),
    );
  }
}
