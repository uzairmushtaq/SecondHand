import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/api_constant.dart';

class ContactUsService {
  sendMail(String name, String email, String message, context) async {
    var post = {
      "app_password": appPassword,
      "upload_data": {
        "name": name,
        "email": email,
        "message": message,
      }
    };
    final url = apiURL + "user_contact_mail";

    Response response = await Dio().post(url, data: FormData.fromMap(post));
    Get.back();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.thanks_for_contact_us)));
    }
  }
}
