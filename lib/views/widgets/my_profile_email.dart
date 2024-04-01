import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/utils/size_config.dart';

import '../../constants/icons.dart';

class MyProfileAndEmailWidget extends StatelessWidget {
  const MyProfileAndEmailWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
        init: Get.put<AuthController>(AuthController()),
        builder: (AuthController snapshot) {
 
          return Column(
            children: [
              //profile image widget
              Container(
                height: SizeConfig.heightMultiplier * 10,
                width: SizeConfig.widthMultiplier * 20,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 12)
                    ],
                    border: Border.all(width: 2, color: kPrimaryColor),
                    shape: BoxShape.circle,
                    image: snapshot.userInfo?.profilePic != "N/A"
                        ? DecorationImage(
                            image: NetworkImage(
                                snapshot.userInfo?.profilePic ?? ""),
                            fit: BoxFit.cover)
                        : null),
                child: snapshot.userInfo?.profilePic != "N/A"
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset(
                          noProfileIcon,
                          color: kPrimaryColor,
                        ),
                      ),
              ),
              //name email and phone widget
              SizedBox(
                height: SizeConfig.heightMultiplier * 1,
              ),
              Text(
                snapshot.userInfo?.fullName ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.textMultiplier * 2.5),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 0.5,
              ),
              Text(
                "${snapshot.userInfo?.email ?? ""}  ${snapshot.userInfo?.phone ?? ""}",
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.5,
                    color: const Color(0xFF94A3B8)),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
            ],
          );
        });
  }
}
