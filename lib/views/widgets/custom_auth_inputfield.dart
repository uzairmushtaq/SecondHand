import 'package:flutter/material.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:websafe_svg/websafe_svg.dart';

class CustomAuthInputField extends StatefulWidget {
  const CustomAuthInputField(
      {Key? key,
      required this.controller,
      required this.validator,
      required this.hintText,
      this.isPassword = false})
      : super(key: key);

  final TextEditingController controller;
  final bool? isPassword;
  final String? Function(String?)? validator;
  final String hintText;

  @override
  State<CustomAuthInputField> createState() => _CustomAuthInputFieldState();
}

class _CustomAuthInputFieldState extends State<CustomAuthInputField> {
  bool showPass = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.widthMultiplier * 90,
      child: TextFormField(
        obscureText: widget.isPassword! ? showPass : false,
        controller: widget.controller,
        //validation
        validator: widget.validator,
        decoration: InputDecoration(
            suffixIcon: widget.isPassword!
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPass = !showPass;
                      });
                    },
                    icon: showPass
                        ? WebsafeSvg.asset(passEyeIcon, color: kTextColor)
                        : WebsafeSvg.asset(passEyeOffIcon, color: kTextColor),
                    color: const Color(0xFF64748B),
                  )
                : SizedBox(),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kTextColor, width: 1)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kTextColor, width: 1)),
            hintText: widget.hintText,
            hintStyle: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2.1,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF94A3B8))),
      ),
    );
  }
}
