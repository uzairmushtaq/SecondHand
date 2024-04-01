
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/utils/size_config.dart';

class SelectedCategoriesWidget extends StatelessWidget {
  const SelectedCategoriesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalCont = Get.find<GlobalUIController>();
    return Obx(
      ()=> SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Row(
          children: [
            ...List.generate(
                globalCont.selectedCategory.length,
                (index) => Container(
                      decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      margin: EdgeInsets.only(
                          right: SizeConfig.textMultiplier * 1),
                      padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3,
                        right: SizeConfig.widthMultiplier * 1,
                      ),
                      child: Row(
                        children: [
                          Text(globalCont.selectedCategory[index],
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.textMultiplier *
                                          1.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          SizedBox(
                            width: SizeConfig.widthMultiplier * 1,
                          ),
                          InkWell(
                              onTap: () {
                                globalCont.selectedCategory.remove(globalCont.selectedCategory[index]);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.widthMultiplier *
                                            1,
                                    vertical: SizeConfig
                                            .heightMultiplier *
                                        0.3),
                                child: Icon(Icons.cancel,
                                    color: Colors.white,
                                    size: SizeConfig
                                            .heightMultiplier *
                                        2),
                              ))
                        ],
                      ),
                    ))
          ],
        ),
      ),
    );
  }
}
