import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PushNotificationsController extends GetxController {
  void sendPushMessage(String token, String body, String title) async {
    try {
      //POST METHOD FOR PUSH NOTIFICATIONS (FIREBASE CLOUD MESSAGING)
      //THE AUTHORIZATION KEY IS FROM FIREBASE CLOUD MESSAGING SECTION (SERVER KEY)
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAyS0K4M8:APA91bFAmeRASCUFxVBWL7Z1accUhAxKkvWKIyqB-QhVI6HkHczDVl3v2zkPRWNs2nlK_F2iIM6cbbIyOylHtgVCebs5705gOgYkfX-dNtq44v1C7dpBQcB9GbJBvAjXvkVjcR5XU_DZ',
        },
        //IT IS GIVING THE NOTIFICATION THE BODY AND TITLE
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'sound':true
            },
            //TOKEN IS UNIQUE FOR EVERY USER DEVICE THROUGH WHICH THE NOTIFICATION COMES
            "to": token,
          },
        ),
      )
          .then((value) {
        //print("Successfully Send ${value.body}");
      });
    } catch (e) {
      //print("error push notification");
    }
  }
}
