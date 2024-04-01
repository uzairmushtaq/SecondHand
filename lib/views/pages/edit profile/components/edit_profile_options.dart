import 'package:flutter/material.dart';
import 'package:secondhand/utils/size_config.dart';

class EditProfileOptionsWidget extends StatelessWidget {
  const EditProfileOptionsWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    this.isDivider = true
  }) : super(key: key);
  final String title, subtitle;
  final bool isDivider;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
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
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.6,
                    color: const Color(0xFF94A3B8)),
              )
            ],
          ),
        ),
       isDivider
            ? Divider(
                height: SizeConfig.heightMultiplier * 0.7,
                thickness: 1,
                color: const Color(0xFFE2E8F0),
              )
            : const SizedBox()
      ],
    );
  }
}
