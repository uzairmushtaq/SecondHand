import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/fontfamilies.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/notifications/notifications.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/profile/profile.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    Key? key,
    required this.isProfileIcon,
    this.isBNBsection = false,
  }) : super(key: key);
  final bool isProfileIcon;
  final bool? isBNBsection;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 13,
      width: SizeConfig.widthMultiplier * 100,
      decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          border: Border.all(color: kLightGrey.withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25))),
      child: Padding(
        padding: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 5,
            left: isProfileIcon
                ? SizeConfig.widthMultiplier * 5
                : SizeConfig.widthMultiplier * 2,
            right: SizeConfig.widthMultiplier * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  Get.to(() => ProfilePage(), transition: Transition.downToUp);
                },
                child: isProfileIcon
                    ? GetX<AuthController>(
                        init: AuthController(),
                        builder: (AuthController snapshot) {
                        
                          return Container(
                            height: SizeConfig.heightMultiplier * 5,
                            width: SizeConfig.widthMultiplier * 8.5,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                image: snapshot.userInfo?.profilePic != "N/A"
                                    ? snapshot.userInfo?.profilePic != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                snapshot.userInfo?.profilePic??''),
                                            fit: BoxFit.cover)
                                        : null
                                    : null,
                                border:
                                    Border.all(color: kPrimaryColor, width: 1),
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.asset(
                                noProfileIcon,
                                color: kPrimaryColor,
                              ),
                            ),
                          );
                        })
                    : IconButton(
                        onPressed: () {
                          final cont = Get.find<GlobalUIController>();
                          if (isBNBsection == true) {
                            cont.bnbSelectedIndex.value = 0;
                          }
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back_ios_new_rounded,
                            size: SizeConfig.heightMultiplier * 2.5,
                            color: const Color(0xFF475569)))),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "Second",
                  style: TextStyle(
                      fontFamily: ConstantFontFamily.geckoLunch,
                      color: kPrimaryColor,
                      fontSize: SizeConfig.textMultiplier * 3.7)),
              TextSpan(
                  text: "Hand",
                  style: TextStyle(
                      fontFamily: ConstantFontFamily.geckoLunch,
                      color: kTextColor,
                      fontSize: SizeConfig.textMultiplier * 3.7))
            ])),
            IconButton(
                onPressed: () {
                  Get.to(() => const NotificationsPage(),
                      transition: Transition.downToUp);
                },
                icon: Stack(
                  children: [
                    Image.asset(
                      notificationIcon,
                      height: SizeConfig.heightMultiplier * 3,
                    ),
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 2,
                        backgroundColor: Colors.red,
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
