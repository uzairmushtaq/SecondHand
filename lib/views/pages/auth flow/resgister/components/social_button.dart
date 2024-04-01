import 'package:flutter/material.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SocialSignUpButton extends StatelessWidget {
  const SocialSignUpButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);
  final String title, icon;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: SizeConfig.heightMultiplier * 5.3,
        width: SizeConfig.widthMultiplier * 90,
        margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 2),
        decoration: BoxDecoration(
            color: kWhiteColor,
            border: Border.all(color: kLightGrey, width: 1.5),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
            ],
            borderRadius: BorderRadius.circular(40)),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 4,
            vertical: SizeConfig.heightMultiplier * 0.8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WebsafeSvg.asset(
              icon,
              height: SizeConfig.heightMultiplier * 3.5,
              width: SizeConfig.widthMultiplier * 11,
            ),
            SizedBox(
              width: SizeConfig.widthMultiplier * 5,
            ),
            Text(AppLocalizations.of(context)!.sign_up_with + " $title",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.textMultiplier * 1.9,
                    fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
