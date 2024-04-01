
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    required this.passCont,
  }) : super(key: key);

  final TextEditingController passCont;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool showPass=true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.widthMultiplier * 90,
      child: TextField(
        controller: widget.passCont,
        obscureText: showPass,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kTextColor, width: 1)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kTextColor, width: 1)),
            hintText: AppLocalizations.of(context)!.password,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  showPass = !showPass;
                });
              },
              icon: showPass
                  ? WebsafeSvg.asset(passEyeIcon, color: kTextColor)
                  : WebsafeSvg.asset(passEyeOffIcon, color: kTextColor),
              color: const Color(0xFF64748B),
            ),
            hintStyle: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2.1,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF94A3B8))),
      ),
    );
  }
}
