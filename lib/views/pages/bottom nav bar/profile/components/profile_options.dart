import 'package:flutter/material.dart';
import 'package:secondhand/utils/size_config.dart';

class ProfileOptionsWidget extends StatelessWidget {
  const ProfileOptionsWidget({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);
  final String title;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: press,
          child: SizedBox(
            height: SizeConfig.heightMultiplier * 6,
            width: SizeConfig.widthMultiplier * 100,
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                      fontSize: SizeConfig.textMultiplier * 2.1),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: SizeConfig.heightMultiplier * 2,
                    color: const Color(0xFF94A3B8)),
                SizedBox(
                  width: SizeConfig.widthMultiplier * 5,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: SizeConfig.widthMultiplier * 5),
          child: Divider(
            height: SizeConfig.heightMultiplier * 0.7,
            thickness: 1,
            color: const Color(0xFFE2E8F0),
          ),
        )
      ],
    );
  }
}
