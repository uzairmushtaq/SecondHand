import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/services/auth.dart';
import 'package:secondhand/services/database.dart';
import 'package:secondhand/views/bottom%20sheets/report_user_bs.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../constants/icons.dart';
import '../../utils/size_config.dart';
import '../widgets/loading_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatBottomSheet extends StatelessWidget {
  const ChatBottomSheet({
    Key? key,
    required this.chatID,
    required this.otherUserID,
  }) : super(key: key);
  final String chatID, otherUserID;
  @override
  Widget build(BuildContext context) {
    final authCont = Get.find<AuthController>();
    return SizedBox(
      height: 250,
      width: SizeConfig.widthMultiplier * 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon:
                  WebsafeSvg.asset(cancelIcon, color: const Color(0xFF94A3B8))),
          InkWell(
            onTap: () async {
              Get.dialog(
                  LoadingDialog(
                    text: AppLocalizations.of(context)!.archiving,
                  ),
                  barrierDismissible: false);
              await FirebaseFirestore.instance
                  .collection("ChatRoom")
                  .doc(chatID)
                  .update({"archieve": true});
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 4),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.archive_chat,
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.1,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569)),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.archive,
                    color: Color(0xFF94A3B8),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4),
            child: Divider(
              height: SizeConfig.heightMultiplier * 3,
              thickness: 1.5,
              color: Colors.grey.shade200,
            ),
          ),
          InkWell(
            onTap: () =>_onDelete(context),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 4),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.delete_chat,
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.1,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569)),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.delete_outline_outlined,
                    color: Color(0xFF94A3B8),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4),
            child: Divider(
              height: SizeConfig.heightMultiplier * 3,
              thickness: 1.5,
              color: Colors.grey.shade200,
            ),
          ),
          InkWell(
            onTap: () {
              FirebaseFirestore.instance
                  .collection("ChatRoom")
                  .doc(chatID)
                  .get()
                  .then((value) {
                for (int i = 0; i < value["users"].length; i++) {
                  if (value["users"][i] !=
                      Get.find<AuthController>().userss!.uid) {
                    Get.back();
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        context: context,
                        builder: (_) => ReportUserBottomSheet(
                              otherUID: value["users"][i],
                            ));
                    break;
                  }
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 4),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.report_user,
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.1,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569)),
                  ),
                  const Spacer(),
                  const Icon(
                    FeatherIcons.info,
                    color: Color(0xFF94A3B8),
                  )
                ],
              ),
            ),
          ),
       authCont.userInfo!.blockedFrom!.contains(otherUserID)?const SizedBox():   Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4),
            child: Divider(
              height: SizeConfig.heightMultiplier * 3,
              thickness: 1.5,
              color: Colors.grey.shade200,
            ),
          ),
      authCont.userInfo!.blockedFrom!.contains(otherUserID)?const SizedBox():    InkWell(
            onTap: () => AuthService.blockorUnblockUser(otherUserID),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 4),
              child: Row(
                children: [
                  Text(
                    authCont.userInfo?.blockedUsers?.contains(otherUserID)??false
                        ? 'Unblock'
                        : 'Block',
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.1,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569)),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.block,
                    color: Color(0xFF94A3B8),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  _onDelete(BuildContext context)async{
    Get.dialog(LoadingDialog(text: 'Deleting chat....'));
    final authCont=Get.find<AuthController>();
    final data=await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatID).get();
    List deletedMsgBy=data.get('DeletedBy');
    
     deletedMsgBy.add(authCont.userss!.uid);
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatID)
        .update({'DeletedBy': deletedMsgBy});
      Get.back();
      Get.back();
       Get.back();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.deleting)));
  }
}
