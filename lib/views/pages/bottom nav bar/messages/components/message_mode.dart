import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/utils/size_config.dart';

class MessageModeWidget extends StatelessWidget {
  const MessageModeWidget({
    Key? key,required this.function,
  }) : super(key: key);
  final Function function;
  @override
  Widget build(BuildContext context) {
    final globalCont = Get.find<GlobalUIController>();
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: SizeConfig.heightMultiplier * 5,
        width: SizeConfig.widthMultiplier * 100,
        margin: EdgeInsets.only(right: SizeConfig.widthMultiplier * 5),
        decoration: BoxDecoration(
            border: Border.all(
              color: globalCont.selectedModeMsg.value == 0
                  ? kPrimaryColor
                  : kSecondaryColor,
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tabWidget("Buy", true, kPrimaryColor, 0),
            tabWidget("Sell", false, kSecondaryColor, 1)
          ],
        ),
      ),
    );
  }

  tabWidget(String text, bool isBuy, Color color, int index) {
    final globalCont = Get.find<GlobalUIController>();
    return Obx(
      () => GestureDetector(
        onTap: () {
          
          globalCont.selectedModeMsg.value = index;
          function();
          //print(globalCont.selectedModeMsg.value);
        },
        child: AnimatedContainer(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 400),
          height: SizeConfig.heightMultiplier * 5,
          width: SizeConfig.widthMultiplier * 44.5,
          decoration: BoxDecoration(
              color: globalCont.selectedModeMsg.value != index
                  ? Colors.transparent
                  : color,
              borderRadius: globalCont.selectedModeMsg.value != index
                  ? null
                  : BorderRadius.only(
                      topRight:
                          isBuy ? Radius.circular(0) : Radius.circular(7.5),
                      bottomRight:
                          isBuy ? Radius.circular(0) : Radius.circular(7.5),
                      topLeft:
                          isBuy ? Radius.circular(7.5) : Radius.circular(0),
                      bottomLeft:
                          isBuy ? Radius.circular(7.5) : Radius.circular(0))),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 2,
                  fontWeight: FontWeight.w600,
                  color: globalCont.selectedModeMsg.value != index
                      ? kTextColor
                      : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
