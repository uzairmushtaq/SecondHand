import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectLanguageBS extends StatelessWidget {
   SelectLanguageBS({
    Key? key,
  }) : super(key: key);

  Map<String, Map> languages = {
    'de': {
      'wording': 'Deutsch',
      'flag': "assets/icons/de.svg"
    },
    'en': {
      'wording': 'English',
      'flag': "assets/icons/en.svg"
    },
    'fa': {
      'wording': 'فارسی',
      'flag': "assets/icons/fa.svg"
    },
    'pl': {
      'wording': 'Polski',
      'flag': "assets/icons/pl.svg"
    },
    'pt': {
      'wording': 'Português',
      'flag': "assets/icons/pt.svg"
    },
    'es': {
      'wording': 'Español',
      'flag': "assets/icons/es.svg"
    },
    'ru': {
      'wording': 'Русский',
      'flag': "assets/icons/ru.svg"
    },
    'uk': {
      'wording': 'українська',
      'flag': "assets/icons/uk.svg"
    },
    'th': {
      'wording': 'ไทย',
      'flag': "assets/icons/th.svg"
    },
    'fr': {
      'wording': 'Français',
      'flag': "assets/icons/fr.svg"
    },
    'it': {
      'wording': 'Italiano',
      'flag': "assets/icons/it.svg"
    },
    'he': {
      'wording': 'עִברִית',
      'flag': "assets/icons/he.svg"
    },
  };

  buildLanguages(context) {
    List<Widget> widgetList = <Widget>[];
    languages.forEach((String l, Map d) {
      widgetList.add(Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4),
            child: InkWell(
              onTap: () async {
                Get.updateLocale(Locale(l));
                Navigator.pop(context, true);
                var prefs = await SharedPreferences.getInstance();
                prefs.setString('languageCode', l);
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(Get.find<AuthController>().userss!.uid).update({"Language": l});
              },
              child: Row(
                children: [
                  Text(
                    d['wording'],
                    style: TextStyle(
                        fontSize:
                        SizeConfig.textMultiplier * 2.2,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569)),
                  ),
                  const Spacer(),
                  SizedBox(height: SizeConfig.heightMultiplier*4,width: SizeConfig.widthMultiplier*8,child: WebsafeSvg.asset(
                      d['flag'],
                      fit: BoxFit.cover),)
                ],
              ),
            )));

      widgetList.add(Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 4),
        child: Divider(
          height: SizeConfig.heightMultiplier * 1.3,
          thickness: 1.5,
          color: Colors.grey.shade200,
        ),
      ));
    });
    return Column(children: widgetList);
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
          height: SizeConfig.heightMultiplier * 300,
          width: SizeConfig.widthMultiplier * 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: WebsafeSvg.asset(cancelIcon,
                      color: const Color(0xFF94A3B8))),
              buildLanguages(context)
            ],
          ),
        );
  }
}
