import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand/constants/api_constant.dart';

class SendEmailService {
  static Future sendOtpEmail(String email, int code, String recipientName) async {
    try {
    final toEmail=email.trim();

      var post = {
        "app_password": appPassword,
        "upload_data": {
          "to": toEmail,
          "content":  '<html>'
              '<head>'
              '<style>'
              'body {font-family: Arial, sans-serif; margin: 0; padding: 0;}'
              'h1 {font-size: 24px; font-weight: normal;}'
              'p {font-size: 16px; line-height: 1.5;}'
              'strong {font-weight: bold;}'
              '</style>'
              '</head>'
              '<body>'
              '<h1>Dear $recipientName,</h1>'
              '<p>Your One-Time Password (OTP) for the SecondHand App is: <strong>$code</strong></p>'
              '<p>Please use this OTP to complete your login process.</p>'
              '<p>Thank you,<br>The SecondHand Team</p>'
              '</body>'
              '</html>',
        }
      };
      final url = apiURL + "send_otp_mail";

      Response response = await Dio().post(url, data: FormData.fromMap(post));

      print(response.data);
    } catch (e) {
      print(e);
    }
  }
}
