import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/push_notification_controller.dart';
import 'package:secondhand/controllers/user_chat.dart';
import 'package:secondhand/models/user_chat.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/loading.dart';
import 'package:secondhand/views/widgets/loading_dialog.dart';
import 'package:secondhand/views/widgets/record_button.dart';
import 'package:websafe_svg/websafe_svg.dart';
import '../../../constants/api_constant.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/selected_text_controller.dart';
import '../../../services/database.dart';
import '../../bottom sheets/chat_bottom_sheets.dart';
import 'components/message_send_button.dart';
import 'components/selected_msgs_bs.dart';
import 'components/user_chat.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.currentUserID,
    required this.chatRoomID,
    required this.otherUserName,
    required this.otherUserID,
    required this.articleName,
    required this.articleImages,
    required this.articleID,
  }) : super(key: key);
  final String currentUserID, chatRoomID, otherUserName, otherUserID;
  final String articleName;
  final List articleImages;
  final String articleID;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final userID = Get.find<AuthController>().userInfo?.id;
  final userChat = Get.find<UserChatCont>();
  final authCont = Get.find<AuthController>();

  sendMessage(String msg, String type) async {
    if (msg.isNotEmpty) {
      sendMsgCont.clear();
      Map<String, dynamic> messageMap = {
        "Message": msg,
        "Images": [""],
        "SendBy": widget.currentUserID,
        "Type": type,
        'DeleteMsgBy': [],
        "Photo": Get.find<AuthController>().userInfo?.profilePic,
        "Seen": false,
        "Time": DateTime.now().toString(),
      };
      if (userChat.isTranslation.value) {
        userChat.transLoad.value = true;
      }

      DataBase().getCoversationMessages(widget.chatRoomID, messageMap);
      await DataBase()
          .setDataInChatRoom(widget.chatRoomID, msg, widget.currentUserID);
      await FirebaseFirestore.instance
          .collection("GetTokens")
          .where("UID", isEqualTo: widget.otherUserID)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          Get.find<PushNotificationsController>().sendPushMessage(
              value.docs[0]["Token"],
              msg,
              Get.find<AuthController>().userInfo?.email!.split("@")[0] ?? '');
        }
      });
      DataBase().sendChatNotification(
          widget.articleID, widget.otherUserID, widget.chatRoomID);
      if (userChat.isTranslation.value) {
        Future.delayed(
            Duration(seconds: 1), () => userChat.transLoad.value = false);
      }
    }
  }

  sendImages(List img, String type) async {
    Get.dialog(
        LoadingDialog(
          text: AppLocalizations.of(context)!.sending,
        ),
        barrierDismissible: false);
    //uploading images in api
    final apiImagesListURL = [];
    //POST METHOD FOR UPLOADING IMAGES
    for (int i = 0; i < img.length; i++) {
      final picture = base64Encode(img[i].readAsBytesSync());
      final pictureName = img[i].path;
      var post = {
        "app_password": appPassword,
        "upload_data": {
          "name": pictureName,
          "user_id": userID,
          "image": picture,
        }
      };
      final url = apiURL + "upload_image";
      Response response = await Dio().post(url, data: FormData.fromMap(post));
      var res = response.data;
      if (response.statusCode == 200) {
        apiImagesListURL.add(res["image_url"]);
      } else {
        //print(res);
      }
    }

    //uplaoding data in firestore
    final DateTime date = DateTime.now();
    final sendTime = date.millisecondsSinceEpoch;
    Map<String, dynamic> messageMap = {
      "Message": "",
      "Images": apiImagesListURL,
      "SendBy": widget.currentUserID,
      "Type": type,
      'DeleteMsgBy': [],
      "Photo": Get.find<AuthController>().userInfo?.profilePic,
      "Seen": false,
      "Time": DateTime.now().toString(),
    };

    DataBase().getCoversationMessages(widget.chatRoomID, messageMap);
    await DataBase().setDataInChatRoom(
        widget.chatRoomID,
        apiImagesListURL.length == 0
            ? '1x image'
            : '${apiImagesListURL.length}x images',
        widget.currentUserID);
    FirebaseFirestore.instance
        .collection("GetTokens")
        .where("UID", isEqualTo: widget.otherUserID)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        Get.find<PushNotificationsController>().sendPushMessage(
            value.docs[0]["Token"],
            "${apiImagesListURL.length} Images",
            authCont.userInfo?.email!.split("@")[0] ?? '');
      } else {
        //print("No User Token Found");
      }
    }).then((value) {
      //print("Notification Send");
    });
    DataBase().sendChatNotification(
        widget.articleID, widget.otherUserID, widget.chatRoomID);
    Get.back();
    globalCont.uploadMessageImages.value = [];
  }

  TextEditingController sendMsgCont = TextEditingController();
  final globalCont = Get.find<GlobalUIController>();
  void selectingImages() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    globalCont.uploadMessageImages.add(File(pickedImage!.path));
  }

  //for recording audio
  String? audioURL;
  void _recordingFinishedCallback(String _filePath) async {
    Get.dialog(
        LoadingDialog(
          text: AppLocalizations.of(context)!.sending,
        ),
        barrierDismissible: false);

    if (_filePath == null) return;

    //print(_filePath);

    File theFile = File.fromUri(Uri.parse(_filePath));

    UploadTask songTask = FirebaseStorage.instance
        .ref('upload-voice-firebase')
        .child(
            _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
        .putFile(theFile);

    //print(songTask);

    if (songTask == null) return;
    final snapshot = await songTask.whenComplete(() {});
    audioURL = await snapshot.ref.getDownloadURL();
    //print(audioURL);

    final DateTime date = DateTime.now();
    final sendTime = date.millisecondsSinceEpoch;
    Map<String, dynamic> messageMap = {
      "Message": audioURL,
      "Images": [""],
      "SendBy": widget.currentUserID,
      "Type": "audio",
      'DeleteMsgBy': [],
      "Photo": Get.find<AuthController>().userInfo?.profilePic,
      "Seen": false,
      "Time": DateTime.now().toString(),
    };

    DataBase().getCoversationMessages(widget.chatRoomID, messageMap);
    await DataBase()
        .setDataInChatRoom(widget.chatRoomID, '1x audio', widget.currentUserID);

    FirebaseFirestore.instance
        .collection("GetTokens")
        .where("UID", isEqualTo: widget.otherUserID)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        Get.find<PushNotificationsController>().sendPushMessage(
            value.docs[0]["Token"],
            "Sent a voice message",
            Get.find<AuthController>().userInfo?.email!.split("@")[0] ?? '');
      } else {
        //print("No User Token Found");
      }
    }).then((value) {
      //print("Notification Send");
    });
    DataBase().sendChatNotification(
        widget.articleID, widget.otherUserID, widget.chatRoomID);
    Get.back();
  }

  //INIT STATE

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      userChat.userChat
          .bindStream(DataBase().streamForUserChat(widget.chatRoomID));

      DataBase().seenQuery(widget.chatRoomID);
    });
  }

  @override
  void dispose() {
    super.dispose();
    userChat.userChat.value = null;
    userChat.transLoad.value = false;
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        bottomSheet: Obx(
          () => authCont.userInfo!.blockedUsers!.contains(widget.otherUserID) ||
                  authCont.userInfo!.blockedFrom!.contains(widget.otherUserID)
              ? SizedBox(
                  height: SizeConfig.heightMultiplier * 10,
                  width: SizeConfig.widthMultiplier * 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Blocked',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        Icons.block,
                        color: Colors.red,
                        size: 18,
                      )
                    ],
                  ),
                )
              : userChat.selectedDelMsgs.value!.isNotEmpty
                  ? SelectedMsgsBottomSheet(
                      chatRoomID: widget.chatRoomID,
                      chatData: userChat.getChat!)
                  : !globalCont.uploadMessageImages.isNotEmpty
                      ? Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.widthMultiplier * 6,
                                vertical: SizeConfig.heightMultiplier * 2),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                TextField(
                                    controller: sendMsgCont,
                                    minLines: 1,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            top: SizeConfig.heightMultiplier *
                                                2.4,
                                            bottom:
                                                SizeConfig.heightMultiplier *
                                                    2.4,
                                            left:
                                                SizeConfig.widthMultiplier * 12,
                                            right: SizeConfig.widthMultiplier *
                                                30),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(26),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                        hintText: AppLocalizations.of(context)!.write_a_message,
                                        hintStyle: TextStyle(color: const Color(0xFF64748B), fontSize: SizeConfig.textMultiplier * 1.6))),
                                Positioned(
                                  left: 0,
                                  child: IconButton(
                                      onPressed: selectingImages,
                                      icon: const Icon(FeatherIcons.image)),
                                ),
                                //recording button

                                Positioned(
                                  right: 0,
                                  child: Row(
                                    children: [
                                      RecordButton(
                                          recordingFinishedCallback:
                                              _recordingFinishedCallback),
                                      //send message button
                                      MessageSendButton(
                                        press: () => sendMessage(
                                            sendMsgCont.text, "text"),
                                        icon: globalCont.isRecorder.value
                                            ? Icons.done
                                            : FeatherIcons.send,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: globalCont.uploadMessageImages.isNotEmpty
                              ? SizeConfig.heightMultiplier * 24
                              : SizeConfig.heightMultiplier * 14,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //uploading images button
                              globalCont.uploadMessageImages.isNotEmpty
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right:
                                                SizeConfig.widthMultiplier * 5,
                                            bottom:
                                                SizeConfig.heightMultiplier *
                                                    2),
                                        child: MessageSendButton(
                                          icon: FeatherIcons.send,
                                          press: () {
                                            sendImages(
                                                globalCont.uploadMessageImages,
                                                "image");
                                          },
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              //add image widget
                              Obx(
                                () => SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              SizeConfig.widthMultiplier * 3),
                                      ...List.generate(
                                          globalCont.uploadMessageImages.length,
                                          (index) => Container(
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    12,
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        24,
                                                margin: EdgeInsets.only(
                                                    right: SizeConfig
                                                            .widthMultiplier *
                                                        2),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFE2E8F0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.file(
                                                        globalCont
                                                                .uploadMessageImages[
                                                            index],
                                                        fit: BoxFit.cover)),
                                              )),
                                      globalCont.uploadMessageImages.isNotEmpty
                                          ? InkWell(
                                              onTap: selectingImages,
                                              child: Container(
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    12,
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        24,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFE2E8F0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Center(
                                                  child: WebsafeSvg.asset(
                                                      "assets/icons/plus.svg",
                                                      height: SizeConfig
                                                              .heightMultiplier *
                                                          6,
                                                      color: const Color(
                                                          0xFF475569)),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 2),
                              //send message textfield
                            ],
                          ),
                        ),
        ),
        //BODY OF THE SCREEN
        body: SizedBox(
          height: SizeConfig.heightMultiplier * 89,
          width: SizeConfig.widthMultiplier * 100,
          child: Stack(
            children: [
              Obx(
                () => SizedBox(
                  height: globalCont.uploadMessageImages.isNotEmpty
                      ? SizeConfig.heightMultiplier * 75
                      : SizeConfig.heightMultiplier * 89,
                  width: SizeConfig.widthMultiplier * 100,
                  child: Stack(
                    children: [
                      FadeIn(
                        child: UserChatWidget(
                          chatRoomID: widget.chatRoomID,
                        ),
                      ),
                      userChat.transLoad.value
                          ? Container(
                              width: SizeConfig.widthMultiplier * 100,
                              color: Colors.white,
                              child: Center(child: LoadingWidget()),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  height: SizeConfig.heightMultiplier * 19,
                  width: SizeConfig.widthMultiplier * 100,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      border: Border.all(color: kLightGrey.withOpacity(0.3)),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 5,
                        left: SizeConfig.widthMultiplier * 2,
                        right: SizeConfig.widthMultiplier * 2),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.arrow_back_ios_new_rounded,
                                    size: SizeConfig.heightMultiplier * 2.5,
                                    color: const Color(0xFF475569))),
                            const Spacer(),
                            Column(
                              children: [
                                //ARTICLE NAME AND PICTURE
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: SizeConfig.widthMultiplier * 5,
                                      backgroundColor: Colors.grey.shade300,
                                      backgroundImage:
                                          NetworkImage(widget.articleImages[0]),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.widthMultiplier * 4,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.widthMultiplier * 30,
                                      child: Text(
                                        widget.articleName,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            color: const Color(0xFF475569),
                                            fontSize:
                                                SizeConfig.textMultiplier * 3.8,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),

                                //USERNAME
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.heightMultiplier * 0.5),
                                  child: Text(
                                    widget.otherUserName,
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.5,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      context: context,
                                      builder: (_) => ChatBottomSheet(
                                            chatID: widget.chatRoomID,
                                            otherUserID: widget.otherUserID,
                                          ));
                                },
                                icon: const Icon(
                                    Icons.arrow_drop_down_circle_outlined))
                          ],
                        ),
                        //TRANSLATION SWITCH
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Translate chat'),
                            Transform.scale(
                                scale: 0.6,
                                child: Obx(
                                  () => CupertinoSwitch(
                                      value: userChat.isTranslation.value,
                                      onChanged: (val) =>
                                          userChat.isTranslation.value = val),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
