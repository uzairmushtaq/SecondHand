import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/controllers/user_chat.dart';
import 'package:secondhand/models/user_chat.dart';
import 'package:secondhand/views/pages/image%20viewer/image_viewer.dart';
import 'package:secondhand/views/widgets/audio_player.dart';
import 'package:secondhand/views/widgets/no_data_widget.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'package:translator/translator.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/icons.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../utils/size_config.dart';
import 'custom_sender_shape.dart';
import 'custom_shape.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserChatWidget extends StatefulWidget {
  const UserChatWidget({
    Key? key,
    required this.chatRoomID,
  }) : super(key: key);
  final String chatRoomID;

  @override
  State<UserChatWidget> createState() => _UserChatWidgetState();
}

class _UserChatWidgetState extends State<UserChatWidget> {
  final userChat = Get.find<UserChatCont>();
  final userID = Get.find<AuthController>().userss!.uid;

  @override
  void dispose() {
    Get.find<GlobalUIController>().isRecorder.value = false;
    userChat.selectedDelMsgs.value = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // //print(Get.height);
    //making seen message query
    FirebaseFirestore.instance.collection("ChatRoom").get().then((value) {
      //print(value.docs.length);
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].get("users").contains(userID)) {
          //print(value.docs[i]);
          FirebaseFirestore.instance
              .collection("ChatRoom")
              .doc(value.docs[i].get("chatRoomID"))
              .collection("Chats")
              .get()
              .then((valuee) {
            for (int a = 0; a < valuee.docs.length; a++) {
              if (userID != valuee.docs[a].get("SendBy")) {
                //doing seen true
                FirebaseFirestore.instance
                    .collection("ChatRoom")
                    .doc(value.docs[i].get("chatRoomID"))
                    .collection("Chats")
                    .doc(valuee.docs[a].id)
                    .update({"Seen": true});
              }
            }
          });
        }
      }
    });
    ////////////////////////////////
    final formattedTime = DateFormat("dd.MM.y HH:mm");
    _onDeletMsgAddorRemove(String chatid) {
      if (userChat.selectedDelMsgs.value!.contains(chatid)) {
        userChat.selectedDelMsgs.value!.remove(chatid);
      } else {
        userChat.selectedDelMsgs.value!.add(chatid);
      }
      userChat.selectedDelMsgs.refresh();
    }

    return Obx(
      () => userChat.getChat == null
          ? SizedBox(
              height: SizeConfig.heightMultiplier * 70,
              child: Loading(),
            )
          : userChat.getChat!.isEmpty
              ? SizedBox(
                  height: SizeConfig.heightMultiplier * 70,
                  child: NoDataWidget(),
                )
              : ListView.builder(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 3),
                  itemCount: userChat.getChat!.length,
                  shrinkWrap: true,
                  itemBuilder: (_, i) {
                    final chat = userChat.getChat![i];
                    return ChatTile(
                        formattedTime: formattedTime,
                        chat: chat,
                        onDelMsg: () => _onDeletMsgAddorRemove(chat.id!),
                        i: i);
                  },
                ),
    );
  }
}

class ChatTile extends StatefulWidget {
  const ChatTile({
    Key? key,
    required this.formattedTime,
    required this.chat,
    required this.i,
    required this.onDelMsg,
  }) : super(key: key);

  final DateFormat formattedTime;
  final UserChatModel chat;
  final int i;
  final VoidCallback onDelMsg;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  final userChat = Get.find<UserChatCont>();
  final translator = GoogleTranslator();

  final userID = Get.find<AuthController>().userss!.uid;
  bool showTranslatedMsg = true;
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return Column(
      children: [
        widget.i == userChat.getChat!.length - 1
            ? Center(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.heightMultiplier * 18),
                  child: Text(
                    "${widget.formattedTime.format(DateTime.parse(userChat.getChat![userChat.getChat!.length - 1].time!))}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                        fontSize: SizeConfig.textMultiplier * 1.3),
                  ),
                ),
              )
            : const SizedBox(),
        widget.i == userChat.getChat!.length - 1
            ? SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              )
            : const SizedBox(),
        Padding(
          padding: EdgeInsets.only(
              bottom: widget.i == 0
                  ? SizeConfig.heightMultiplier * 16
                  : SizeConfig.heightMultiplier * 1),
          child: InkWell(
            //SELECT FOR DELETE MSG
            onTap: widget.onDelMsg,
            onLongPress: widget.onDelMsg,
            child: Obx(
              () => Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: widget.chat.sendby != userID
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      widget.chat.sendby != userID
                          ? userChat.selectedDelMsgs.value!.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      right: SizeConfig.widthMultiplier * 3),
                                  child: InkWell(
                                    onTap: widget.onDelMsg,
                                    child: CircleAvatar(
                                      backgroundColor: userChat
                                              .selectedDelMsgs.value!
                                              .contains(widget.chat.id)
                                          ? kPrimaryColor
                                          : Colors.grey.shade200,
                                      radius: SizeConfig.widthMultiplier * 3,
                                      child: userChat.selectedDelMsgs.value!
                                              .contains(widget.chat.id)
                                          ? Icon(Icons.done,
                                              size: 16, color: Colors.white)
                                          : null,
                                    ),
                                  ),
                                )
                              : const SizedBox()
                          : const SizedBox(),
                      //OTHER USER PROFILE IMAGE WIDGET
                      widget.chat.sendby != userID
                          ? Container(
                              height: SizeConfig.heightMultiplier * 3.5,
                              width: SizeConfig.widthMultiplier * 7,
                              decoration: BoxDecoration(
                                  image: widget.chat.photo != "N/A"
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              widget.chat.photo ?? ''),
                                          fit: BoxFit.cover)
                                      : null,
                                  border: Border.all(
                                      width: 1.5, color: kSecondaryColor),
                                  shape: BoxShape.circle),
                              child: widget.chat.photo != "N/A"
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                        noProfileIcon,
                                        color: kSecondaryColor,
                                      ),
                                    ),
                            )
                          : SizedBox(width: SizeConfig.widthMultiplier * 7),
                      SizedBox(
                        width: widget.chat.sendby != userID
                            ? SizeConfig.widthMultiplier * 1
                            : 0,
                      ),

                      Stack(
                        children: [
                          //custom shape of chat
                          Positioned(
                            right: widget.chat.sendby != userID ? null : 0,
                            left: widget.chat.sendby != userID ? 0 : null,
                            child: CustomPaint(
                              size: Size(SizeConfig.widthMultiplier * 15,
                                  (SizeConfig.widthMultiplier * 10).toDouble()),
                              painter: widget.chat.sendby != userID
                                  ? CustomSenderShape()
                                  : RPSCustomPainter(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: widget.chat.sendby != userID
                                    ? 0
                                    : SizeConfig.widthMultiplier * 3,
                                left: widget.chat.sendby != userID
                                    ? SizeConfig.widthMultiplier * 3
                                    : 0),
                            padding: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier * 0.5,
                                bottom: SizeConfig.heightMultiplier * 0.4,
                                left: SizeConfig.widthMultiplier * 2),
                            decoration: BoxDecoration(
                                color: widget.chat.sendby != userID
                                    ? const Color(0xFF779EA3)
                                    : kPrimaryColor,
                                borderRadius: BorderRadius.circular(6)),
                            //OTHER USER FULL NAME
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        minHeight: Get.height * 0.035,
                                        minWidth: Get.width * 0.3,
                                        maxHeight: Get.height * 0.9,
                                        maxWidth: Get.width * 0.7,
                                      ),
                                      margin: EdgeInsets.only(
                                          bottom:
                                              SizeConfig.heightMultiplier * 2),
                                      //checing the message is text or image
                                      child: widget.chat.type == "image"
                                          ?
                                          //SHOWING IMAGES LIST
                                          Wrap(children: [
                                              ...List.generate(
                                                  widget.chat.images!.length,
                                                  (indexOfImages) => InkWell(
                                                        onTap: () => Get.to(
                                                            () => ImageViewer(
                                                                imageLink: widget
                                                                        .chat
                                                                        .images![
                                                                    indexOfImages])),
                                                        child: Hero(
                                                          tag: widget
                                                                  .chat.images![
                                                              indexOfImages],
                                                          child: Container(
                                                              height: SizeConfig
                                                                      .heightMultiplier *
                                                                  7,
                                                              width: SizeConfig
                                                                      .widthMultiplier *
                                                                  14,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              margin: EdgeInsets.only(
                                                                  bottom: SizeConfig
                                                                          .heightMultiplier *
                                                                      1.5,
                                                                  right: SizeConfig
                                                                          .widthMultiplier *
                                                                      1),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: widget
                                                                            .chat
                                                                            .images![
                                                                        indexOfImages],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ))),
                                                        ),
                                                      ))
                                            ])
                                          :
                                          //Text Message
                                          FutureBuilder<Translation>(
                                              future: translator.translate(
                                                  widget.chat.msg!,
                                                  from: 'auto',
                                                  to: myLocale.languageCode),
                                              builder: (context, snapshot) {
                                                final isWaiting =
                                                    snapshot.connectionState ==
                                                        ConnectionState.waiting;

                                                return widget.chat.type ==
                                                        "text"
                                                    ?
                                                    //CHECK IF CONTAINS PHONE NUMBER
                                                    Obx(() {
                                                        return widget.chat
                                                                    .type !=
                                                                'text'
                                                            ? SizedBox()
                                                            : userChat.containsPhoneNumber(
                                                                    widget.chat
                                                                        .msg!)
                                                                ? Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                6),
                                                                    child: SelectableText.rich(TextSpan(
                                                                        children: userChat.extractPhoneNumberText(
                                                                            !userChat.isTranslation.value
                                                                                ? widget.chat.msg!
                                                                                : snapshot.data?.text ?? widget.chat.msg!,
                                                                            widget.chat.sendby != userID ? const Color(0xFFE2E8F0) : const Color(0xFF475569)))),
                                                                  )
                                                                :
                                                                //CHECK IF TEXT IS SIMPLE
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                6),
                                                                    child:
                                                                        SelectableText(
                                                                      !userChat
                                                                              .isTranslation
                                                                              .value
                                                                          ? widget
                                                                              .chat
                                                                              .msg!
                                                                          : snapshot.data?.text ??
                                                                              widget.chat.msg!,
                                                                      style: TextStyle(
                                                                          color: widget.chat.sendby != userID
                                                                              ? const Color(0xFFE2E8F0)
                                                                              : const Color(0xFF475569),
                                                                          fontSize: SizeConfig.textMultiplier * 2),
                                                                    ),
                                                                  );
                                                      })
                                                    : AudioPlayerMessage(
                                                        color: widget.chat
                                                                    .sendby !=
                                                                userID
                                                            ? kPrimaryColor
                                                            : kSecondaryColor,
                                                        source: AudioSource.uri(
                                                            Uri.parse(widget
                                                                .chat.msg!)),
                                                        id: "audio");
                                              }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                            right: widget.chat.sendby != userID
                                ? SizeConfig.widthMultiplier * 2
                                : SizeConfig.widthMultiplier * 4,
                            bottom: SizeConfig.heightMultiplier * 0.1,
                            child: //TIME OF MESSAGE
                                Text(
                              widget.formattedTime
                                  .format(DateTime.parse(widget.chat.time!)),
                              style: TextStyle(
                                  color: widget.chat.sendby != userID
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF64748B),
                                  fontSize: SizeConfig.textMultiplier * 1.4),
                            ),
                          ),
                        ],
                      ),
                      userChat.selectedDelMsgs.value!.isNotEmpty
                          ? widget.chat.sendby != userID
                              ? const SizedBox()
                              : InkWell(
                                  onTap: widget.onDelMsg,
                                  child: CircleAvatar(
                                    backgroundColor: userChat
                                            .selectedDelMsgs.value!
                                            .contains(widget.chat.id)
                                        ? kPrimaryColor
                                        : Colors.grey.shade200,
                                    radius: SizeConfig.widthMultiplier * 3,
                                    child: userChat.selectedDelMsgs.value!
                                            .contains(widget.chat.id)
                                        ? Icon(Icons.done,
                                            size: 16, color: Colors.white)
                                        : null,
                                  ),
                                )
                          : SizedBox(),
                    ],
                  ),
                  Positioned(
                      bottom: 10,
                      right: widget.chat.sendby != userID ? 0 : null,
                      child: Icon(
                        FeatherIcons.trash2,
                        color: Colors.grey,
                        size: 15,
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
