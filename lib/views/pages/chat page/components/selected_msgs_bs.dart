import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/user_chat.dart';
import 'package:secondhand/models/chat_model.dart';
import 'package:secondhand/models/user_chat.dart';
import 'package:secondhand/services/database.dart';
import 'package:secondhand/utils/size_config.dart';

class SelectedMsgsBottomSheet extends StatelessWidget {
  SelectedMsgsBottomSheet({
    Key? key,
    required this.chatRoomID,
    required this.chatData,
  }) : super(key: key);
  final String chatRoomID;
  final cont = Get.find<UserChatCont>();
  final List<UserChatModel> chatData;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: cont.selectedDelMsgs.value!.isNotEmpty
            ? SizeConfig.heightMultiplier * 6
            : 0,
        width: SizeConfig.widthMultiplier * 100,
        color: klightGreyText,
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 6),
        child: Row(
          children: [
            Text(
              '${cont.selectedDelMsgs.value!.length} selected',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            cont.selectedDelMsgs.value!.isNotEmpty
                ? IconButton(
                    onPressed: () async {
                      await DataBase().deleteChat(chatRoomID);
                      Future.delayed(Duration(seconds: 2),()async=>await DataBase().updateDeleteMsgsInChatRoom(
                          chatRoomID));
                    },
                    icon: Icon(Icons.delete))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
