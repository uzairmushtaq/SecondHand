import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../utils/size_config.dart';
import '../pages/bottom nav bar/home/components/search_item_button.dart';

class ReportUserBottomSheet extends StatelessWidget {
  const ReportUserBottomSheet({
    Key? key,
    required this.otherUID,
  }) : super(key: key);
  final String otherUID;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.heightMultiplier * 37,
      width: SizeConfig.widthMultiplier * 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier * 2,
          ),
          CircleAvatar(
            radius: SizeConfig.widthMultiplier * 7,
            backgroundColor: kPrimaryColor.withOpacity(0.2),
            child: const Icon(FeatherIcons.save, color: kPrimaryColor),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 2,
          ),
          Text(
            "Are you sure you want to report\nthis user?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2.2,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 3,
          ),
          Container(
            height: SizeConfig.heightMultiplier * 17,
            width: SizeConfig.widthMultiplier * 100,
            color: Colors.grey.shade100,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                SearchItemButton(
                    title: "Yes, I'm sure",
                    isShuffleButton: false,
                    press: () async {
                      await FirebaseFirestore.instance
                          .collection("ReportedUsers")
                          .add({"UserID": otherUID}).then((value) {
                        Get.back();
                      });
                    },
                    isSellerProfile: false),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1,
                ),
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "No, It was a mistake",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                          fontSize: SizeConfig.textMultiplier * 2.1),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
