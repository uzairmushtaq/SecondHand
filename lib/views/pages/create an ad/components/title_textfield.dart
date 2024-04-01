import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class TitleTextFieldWidget extends StatelessWidget {
  const TitleTextFieldWidget({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);
  final String title;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.heightMultiplier * 2.5,
        ),
        Divider(
          color: Colors.grey.shade200,
          thickness: 1.5,
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 3,
        ),
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.heightMultiplier * 3.5,
              color: const Color(0xFF475569)),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 1.5,
        ),
        Container(
         
          decoration: BoxDecoration(
              border: Border.all(color: kSecondaryColor),
              borderRadius: BorderRadius.circular(50)),
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 3),
          child: TextField(
            controller: controller,
            onChanged: (val) {
              if (val.isEmpty) {
                Get.find<GlobalUIController>().progressBarOfArticleData.value =
                    Get.find<GlobalUIController>().progressBarOfArticleData.value -
                        10.0;
              }
            },
            onEditingComplete: () {
              Get.find<GlobalUIController>().progressBarOfArticleData.value =
                  Get.find<GlobalUIController>().progressBarOfArticleData.value +
                      10.0;
              //print("Plusssss");
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: title == AppLocalizations.of(context)!.title
                    ? AppLocalizations.of(context)!
                        .write_short_title // "Write a short title"
                    //
                    : AppLocalizations.of(context)!.set_price, //"Set a price",
                hintStyle: const TextStyle(color: Color(0xFF94A3B8))),
          ),
        )
      ],
    );
  }
}
