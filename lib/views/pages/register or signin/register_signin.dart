import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/profile/components/select_language_bs.dart';
import 'package:secondhand/views/pages/auth%20flow/resgister/register.dart';
import 'package:secondhand/views/pages/auth%20flow/signin/signin.dart';
import 'package:secondhand/views/widgets/custom_button.dart';
import 'package:secondhand/views/widgets/second_hand_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:websafe_svg/websafe_svg.dart';

class RegistorOrSigninPage extends StatelessWidget {
   RegistorOrSigninPage({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    Locale appLocale = Localizations.localeOf(context);
    final textFontSize = SizeConfig.textMultiplier * 3.5;
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: kLightYellow,
        body: Column(
          children: [
            SizedBox(
              height: SizeConfig.heightMultiplier * 7,
            ),
            //second hand text
            const SecondHandTextWidget(),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            //register signin png
            Center(
              child: Image.asset(
                registerSigninImg,
                height: SizeConfig.heightMultiplier * 30,
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 3,
            ),
            //sentence
            SizedBox(
              width: SizeConfig.widthMultiplier * 90,
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: AppLocalizations.of(context)!.the + " ",
                        style: TextStyle(
                            fontSize: textFontSize,
                            color: kTextColor,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: AppLocalizations.of(context)!.easiest + " ",
                        style: TextStyle(
                            fontSize: textFontSize,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: AppLocalizations.of(context)!.and + " ",
                        style: TextStyle(
                            fontSize: textFontSize,
                            color: kTextColor,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: AppLocalizations.of(context)!.funniest + " ",
                        style: TextStyle(
                            fontSize: textFontSize,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: AppLocalizations.of(context)!.waytobuy + " ",
                        style: TextStyle(
                            fontSize: textFontSize,
                            color: kTextColor,
                            fontWeight: FontWeight.w700))
                  ])),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 3,
            ),
            //register and sign in buttons
            CustomButton(
                title: AppLocalizations.of(context)!.register,
                color: kSecondaryColor,
                borderColor: kSecondaryColor,
                textColor: Colors.white,
                press: () {
                  Get.to(() =>  RegisterPage(),
                      transition: Transition.leftToRight);
                }),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1.3,
            ),
            CustomButton(
                title: AppLocalizations.of(context)!.sign_in,
                color: kLightYellow,
                borderColor: kSecondaryColor,
                textColor: kTextColor,
                press: () {
                  Get.to(()=>const SignInPage(),transition: Transition.leftToRight);
                }),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1.3,
            ),
            CustomButton(
                widget: Container(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.language,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF475569),
                                fontSize: SizeConfig.textMultiplier * 2.1),
                          ),
                      SizedBox(width: 70, height: 40, child: WebsafeSvg.asset("assets/icons/" + appLocale.languageCode + ".svg", height: 40))
                ]),
                ),
                color: kLightYellow,
                borderColor: kSecondaryColor,
                textColor: kTextColor,
                press: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => SelectLanguageBS());
                }),
          ],
        ),
      ),
    );
  }
}
