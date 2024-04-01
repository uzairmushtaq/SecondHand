import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:secondhand/models/user_chat.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

class UserChatCont extends GetxController {
  Rxn<List<UserChatModel>> userChat = Rxn<List<UserChatModel>>();
  List<UserChatModel>? get getChat => userChat.value;
  Rxn<List<String>> selectedDelMsgs = Rxn<List<String>>();
  RxBool isTranslation = false.obs;
  RxBool transLoad = false.obs;
  @override
  void onInit() {
    super.onInit();
    selectedDelMsgs.value = [];
  }

  bool containsPhoneNumber(String text) {
    return phoneRegExp.hasMatch(text);
  }

  Future<void> _makePhoneCall(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  RegExp phoneRegExp = RegExp(
      r'(?:(?:\+|0{0,2})[1-9]\d{0,2})?[ -]?\(?(?:\d{1,3})\)?[ -]?\d{1,4}[ -]?\d{1,4}[ -]?\d{1,9}\b');
  List<TextSpan> extractPhoneNumberText(String rawString, Color textColor) {
    List<TextSpan> textSpan = [];

    String getPhoneNumber(String phoneString) {
      textSpan.add(
        TextSpan(
          text: phoneString,
          style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontSize: SizeConfig.textMultiplier * 2),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _makePhoneCall('tel:$phoneString');
            },
        ),
      );
      return phoneString;
    }

    getNormalText(String normalText) {
      textSpan.add(
        TextSpan(
          text: normalText,
          style: new TextStyle(
              color: textColor, fontSize: SizeConfig.textMultiplier * 2),
        ),
      );
      return normalText;
    }

    rawString.splitMapJoin(
      phoneRegExp,
      onMatch: (m) => getPhoneNumber("${m.group(0)}"),
      onNonMatch: (n) => getNormalText("${n.substring(0)}"),
    );

    return textSpan;
  }

  //GET TRANSLATED TEXT
  Future<Translation> getTranslation(String text, Locale locale) async {
    transLoad.value = true;
    final translator = GoogleTranslator();
    Translation translation =
        await translator.translate(text, from: 'auto', to: locale.languageCode);
    transLoad.value = false;

    return translation;
  }
}
