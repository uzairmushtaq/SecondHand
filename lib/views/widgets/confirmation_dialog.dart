import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/custom_button.dart';
import 'package:secondhand/views/widgets/custom_small_button.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog(
      {required this.title,
      required this.subtitle,
      required this.onContinue,
      this.height});
  final String title, subtitle;
  final VoidCallback onContinue;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: height ?? SizeConfig.heightMultiplier * 35,
          width: SizeConfig.widthMultiplier * 75,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.widthMultiplier * 6,
              vertical: SizeConfig.heightMultiplier * 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.textMultiplier * 2.2),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 3),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.textMultiplier * 1.5),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 3),
              CustomSmallButton(
                  title: 'Continue', color: kPrimaryColor, press: onContinue),
              TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.textMultiplier * 1.8),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
