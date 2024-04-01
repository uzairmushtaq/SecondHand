import 'package:flutter/material.dart';
import 'package:secondhand/utils/size_config.dart';

class ContactUsTextField extends StatelessWidget {
  const ContactUsTextField({
    Key? key,
    required this.title,
    required this.hintText,
    required this.controller,
  }) : super(key: key);
  final String title, hintText;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: SizeConfig.textMultiplier * 1.6,
              color: const Color(0xFF475569)),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 1,
        ),
        Container(
          height: SizeConfig.heightMultiplier * 6,
          width: SizeConfig.widthMultiplier * 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color(0xFFF1F5F9)),
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 4),
          child: TextField(
          autofocus: title=="Name"?true:false,
            controller: controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.8,
                    color: const Color(0xFF94A3B8))),
          ),
        )
      ],
    );
  }
}
