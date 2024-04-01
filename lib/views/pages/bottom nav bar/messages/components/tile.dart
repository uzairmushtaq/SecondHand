import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/models/chat_room.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:secondhand/views/pages/chat%20page/chat_page.dart';

class MsgRoomTile extends StatelessWidget {
  MsgRoomTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ChatRoomModel data;
  final authCont = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final new_message = !data.msgSendBy!.contains(authCont.userss!.uid) &&
        !data.msgSeenBy!.contains(authCont.userss!.uid);
    final otherUsername = data.userData![0]['id'] == authCont.userss!.uid
        ? data.userData![1]['username'] ?? 'Unknown'
        : data.userData![0]['username'] ?? 'Unknown';

    return FadeIn(
      duration: const Duration(milliseconds: 400),
      child: Slidable(
        key:  ValueKey(data.id),
        closeOnScroll: true,

        //archeive or delte slidable buttons
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            InkWell(
              onTap: () => _onArchieve(context),
              child: Container(
                height: SizeConfig.heightMultiplier * 12,
                width: SizeConfig.widthMultiplier * 25,
                color: const Color(0xFF94A3B8),
                child: Center(
                  child: Text(
                    (data.archievedBy!.contains(authCont.userss!.uid))
                        ? AppLocalizations.of(context)!.unarchive
                        : AppLocalizations.of(context)!.archive,
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => _onDeleteChat(context),
              child: Container(
                height: SizeConfig.heightMultiplier * 12,
                width: SizeConfig.widthMultiplier * 25,
                color: const Color(0xFFDC2626),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.delete,
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Padding(
         padding:  EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier*5),
          child: SizedBox(
              height: SizeConfig.heightMultiplier * 12,
              width: SizeConfig.widthMultiplier * 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.widthMultiplier * 5),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  //getting the other user data
                  Column(children: [
                    InkWell(
                      onTap: () => Get.to(() => ChatPage(
                            articleID: data.articleID!,
                            articleImages: data.articleImages!,
                            articleName: data.articleName!,
                            chatRoomID: data.id!,
                            currentUserID: authCont.userss!.uid,
                            otherUserName: data.userData![0]['username'] == authCont.userss!.uid
                                    ? data.userData![1]['username']
                                    : data.userData![0]['username'],
                            otherUserID:
                                data.userData![0]['id'] == authCont.userss!.uid
                                    ? data.userData![1]['id']
                                    : data.userData![0]['id'],
                          )),
                      child: Row(
                        children: [
                          Container(
                            height: SizeConfig.heightMultiplier * 5,
                            width: SizeConfig.widthMultiplier * 10,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                image: DecorationImage(
                                    image: NetworkImage(data.articleImages![0]),
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle),
                          ),
                          SizedBox(
                            width: SizeConfig.widthMultiplier * 3,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                otherUsername == '' ? 'Unknown' : otherUsername,
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2.1,
                                    color: const Color(0xFF475569),
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                data.articleName!,
                                style: TextStyle(
                                    color: const Color(0xFF475569),
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 0.5,
                              ),
                              //WHERE WE ARE SHOWING LATEST MESSAGE

                              Row(
                                children: [
                                  Icon(
                                    data.msgSendBy == authCont.userInfo?.id
                                        ? FeatherIcons.arrowUpLeft
                                        : FeatherIcons.arrowDownRight,
                                    size: SizeConfig.heightMultiplier * 2.5,
                                    color: (!new_message)
                                        ? const Color(0xFF94A3B8)
                                        : Colors.black,
                                  ),
                                  (new_message)
                                      ? Icon(
                                          Icons.circle_rounded,
                                          size: 12,
                                          color: kPrimaryColor,
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 1,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 65,
                                    child: Text(
                                      data.msg!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.7,
                                          color: (!new_message)
                                              ? const Color(0xFF94A3B8)
                                              : Colors.black),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ]),

                  Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.widthMultiplier * 5),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  _onArchieve(BuildContext context) async {
    bool isArchived;
    if (data.archievedBy!.contains(authCont.userss!.uid)) {
      data.archievedBy!.remove(authCont.userss!.uid);
      isArchived = false;
    } else {
      data.archievedBy!.add(authCont.userss!.uid);
      isArchived = true;
    }
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(data.id)
        .update({'archievedBy': data.archievedBy});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      isArchived
          ? AppLocalizations.of(context)!.archived_successfully
          : AppLocalizations.of(context)!.unarchived_successfully,
    )));
  }

  _onDeleteChat(BuildContext context) async {
    data.deletedBy!.add(authCont.userss!.uid);
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(data.id)
        .update({'DeletedBy': data.deletedBy});
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.deleting)));
  }
}


