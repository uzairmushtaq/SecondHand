
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/controllers/articles_controller.dart';
import 'package:secondhand/controllers/google_login_controller.dart';

import 'package:secondhand/controllers/user_chat.dart';
import 'package:secondhand/enums/articles_type.dart';
import 'package:secondhand/views/pages/articles/articles.dart';
import 'package:secondhand/views/pages/auth%20flow/welldone/welldone.dart';
import 'package:secondhand/views/pages/register%20or%20signin/register_signin.dart';
import '../controllers/all_user_controller.dart';
import '../controllers/apple_login_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/facebook_controller.dart';
import '../controllers/push_notification_controller.dart';
import '../controllers/search_places_controller.dart';
import '../controllers/selected_text_controller.dart';
import '../controllers/your_mode_controller.dart';
import '../views/pages/bottom nav bar/bottom_nav_bar.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //PERMANENT CONTROLLERS
    Get.put(GoogleLoginController(), permanent: true);
    // Get.put(AuthController(), permanent: true);
    Get.put(FacebookLoginController(), permanent: true);
    Get.put(AppleLoginController(), permanent: true);
    Get.put(PushNotificationsController(), permanent: true);
    Get.put(UserChatCont());
    //ONE TIME INITIALIZE CONTROLLERS
    Get.put(PlacesSearchController());

    Get.put(ArticlesController());
    Get.put(YourModeController());
    Get.put(AllUserController());
    Get.put(GlobalUIController());
    return GetX<AuthController>(
        initState: (_) async {
          // Get.put(AuthController());
        },
        builder: (_) {
          if (Get.find<AuthController>().user != null) {
            return _.isWeldonePage.value
                ? WelldonePage()
                : const BottomNavBar();
            return _.isFirstSignup.value
                ? const ArticlesPage(shuffleType:ShuffleType.shuffled,)
                : const BottomNavBar();
          } else {
            return  RegistorOrSigninPage();
          }
        });
  }
}
