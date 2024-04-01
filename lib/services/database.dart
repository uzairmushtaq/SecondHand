import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:secondhand/controllers/articles_controller.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/controllers/user_chat.dart';
import 'package:secondhand/models/all_user_model.dart';
import 'package:secondhand/models/article_model.dart';
import 'package:secondhand/models/chat_room.dart';
import 'package:secondhand/models/notifications_model.dart';
import 'package:secondhand/views/widgets/loading_dialog.dart';
import '../constants/api_constant.dart';
import '../constants/colors.dart';

import '../models/user_chat.dart';
import '../models/user_model.dart';
import '../views/widgets/custom_auth_snackbar.dart';

class DataBase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final globalCont = Get.put(GlobalUIController());
  final authCont = Get.find<AuthController>();

  ///for creating user data

  //adding user article
  Future<void> addingArticle(
      String userID,
      String title,
      List categories,
      String description,
      String price,
      bool isFree,
      String locationName,
      double locationLat,
      double locationLng,
      List images,
      bool industrialSupplier,
      String language) async {
    try {
      authCont.isLoading.value = true;
      final apiImagesListURL = [];
      //POST METHOD FOR UPLOADING IMAGES
      for (int i = 0; i < images.length; i++) {
        final picture = base64Encode(images[i].readAsBytesSync());
        final pictureName = images[i].path;
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

      //FIRESTORE DATA SAVE
      await _firestore.collection("Articles").add({
        "UploadedBy": userID,
        "Title": title,
        'Owner': {
          'Name': authCont.userInfo?.fullName ?? '',
          'Phone': authCont.userInfo?.phone ?? '',
          'Email': authCont.userInfo?.email ?? ''
        },
        "Categories": categories,
        'searchKey': title.toLowerCase(),
        "Description": description,
        "Price": price,
        "isFree": isFree,
        "isDraft": true,
        "Location": locationName,
        'Currency': Get.find<GlobalUIController>().selectedCurrency.value,
        "Latitude": locationLat,
        "Longitude": locationLng,
        "Images": apiImagesListURL,
        "ExpiryDate": DateTime.now().add(const Duration(days: 30)).toString(),
        "PostedOn": DateTime.now().toString(),
        "Language": language,
        "LikedBy": [],
        "SearchBy": [],
        "Views": [],
        "CrossedBy": [],
        "IndustrialSupplier": industrialSupplier,
      }).then((value) {
        //print('CAT ${categories}');
        globalCont.articleID.value = value.id;
        globalCont.industrialSupplierCheckBox.value = false;
      });
      authCont.isLoading.value = false;
    } catch (e) {
      authCont.isLoading.value = false;
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(SnackBar(
          backgroundColor: kLightYellow,
          padding: const EdgeInsets.all(0),
          content: CustomAuthSnackBar(
            title: "$e",
            subTitle: "Please, try again :)",
          )));
    }
  }

  //stream for showing Articles
  Stream<List<ArticleModel>> streamOfAllArticles() {
    authCont.isLoading.value = true;
    final nowDate = DateTime.now().toString();
    return _firestore
        .collection("Articles")
        .orderBy("ExpiryDate", descending: true)
        .where('ExpiryDate', isGreaterThan: nowDate)
        .where('isDraft', isEqualTo: false)
        .snapshots()
        .map((QuerySnapshot query) {
      //print(query);
      List<ArticleModel> articles = [];
      query.docs.forEach((element) {
        articles.add(ArticleModel.fromDocumentSnapshot(element));
      });
      authCont.isLoading.value = false;
      Get.find<ArticlesController>().loading.value = false;

      return articles;
    });
  }

  Stream<List<ArticleModel>> streamOfMyArticles() {
    authCont.isLoading.value = true;
    final nowDate = DateTime.now().toString();
    return _firestore
        .collection("Articles")
        .where('UploadedBy', isEqualTo: authCont.userss!.uid)
        .snapshots()
        .map((QuerySnapshot query) {
      //print(query);
      List<ArticleModel> articles = [];
      query.docs.forEach((element) {
        articles.add(ArticleModel.fromDocumentSnapshot(element));
      });
      authCont.isLoading.value = false;
      Get.find<ArticlesController>().loading.value = false;

      return articles;
    });
  }

  //for chat secondaryActions
  createChatRoom(String chatRoomID, chatRoomMap) {
    try {
      _firestore.collection("ChatRoom").doc(chatRoomID).set(chatRoomMap);
    } catch (e) {
      //print(e.toString());
    }
  }

  getCoversationMessages(String chatRoomID, messageMap) {
    try {
      _firestore
          .collection("ChatRoom")
          .doc(chatRoomID)
          .collection("Chats")
          .add(messageMap);
    } catch (e) {
      //print(e.toString());
    }
  }

  ///FOR SHOWING NOTIFICATIONS
  Stream<List<NotificationsMOdel>> streamOfNotifications(String uid) {
    // authCont.isLoading.value = true;
    return _firestore
        .collection("Users")
        .doc(uid)
        .collection("Notifications")
        .orderBy('Date', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<NotificationsMOdel> notify = [];
      query.docs.forEach((element) {
        notify.add(NotificationsMOdel.fromDocumentSnapshot(element));
      });
      //  authCont.isLoading.value = false;
      return notify;
    });
  }

  //FOR GETTING ALL THE USERS
  Stream<List<AllUserModel>> streamForUSers() {
    return _firestore
        .collection("Users")
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllUserModel> allUsers = [];
      query.docs.forEach((element) {
        allUsers.add(AllUserModel.fromDocumentSnapshot(element));
      });
      return allUsers;
    });
  }

  //STREAM FOR NORMAL CHATROOMS
  Stream<List<ChatRoomModel>> streamForNormalChatRoom(bool isBuy) {
    if (isBuy) {
      return _firestore
          .collection('ChatRoom')
          .orderBy('ArticleOwnerID')
          .where('users', arrayContains: authCont.userss!.uid)
          .where("ArticleOwnerID", isNotEqualTo: authCont.userss!.uid)
          .snapshots()
          .map((QuerySnapshot query) {
        List<ChatRoomModel> room = [];
        query.docs.forEach((element) {
          if (!element.get('archievedBy').contains(authCont.userss!.uid) &&
              !element.get('DeletedBy').contains(authCont.userss!.uid)) {
            room.add(ChatRoomModel.fromDocumentSnapshot(element));
          }
        });
        room.sort((a, b) => b.latestMsgTime!.compareTo(a.latestMsgTime!));

        return room;
      });
    } else {
      return _firestore
          .collection('ChatRoom')
          .where('users', arrayContains: authCont.userss!.uid)
          .where("ArticleOwnerID", isEqualTo: authCont.userss!.uid)
          .snapshots()
          .map((QuerySnapshot query) {
        List<ChatRoomModel> room = [];
        query.docs.forEach((element) {
          if (!element.get('archievedBy').contains(authCont.userss!.uid) &&
              !element.get('DeletedBy').contains(authCont.userss!.uid)) {
            room.add(ChatRoomModel.fromDocumentSnapshot(element));
          }
        });
        room.sort((a, b) => b.latestMsgTime!.compareTo(a.latestMsgTime!));
        return room;
      });
    }
  }

  //STREAM FOR NORMAL CHATROOMS
  Stream<List<ChatRoomModel>> streamForArchievedChatRoom() {
    return _firestore
        .collection('ChatRoom')
        .where('users', arrayContains: authCont.userss!.uid)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ChatRoomModel> room = [];
      query.docs.forEach((element) {
        if (element.get('archievedBy').contains(authCont.userss!.uid) &&
            !element.get('DeletedBy').contains(authCont.userss!.uid)) {
          room.add(ChatRoomModel.fromDocumentSnapshot(element));
        }
      });
      return room;
    });
  }

  //STREAM FOR CHAT
  Stream<List<UserChatModel>> streamForUserChat(String chatRoomID) {
    return _firestore
        .collection('ChatRoom')
        .doc(chatRoomID)
        .collection('Chats')
        .orderBy("Time", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserChatModel> chat = [];
      query.docs.forEach((element) {
        if (!element.get('DeleteMsgBy').contains(authCont.userss!.uid)) {
          chat.add(UserChatModel.fromDocumentSnapshot(element));
        }
      });
      return chat;
    });
  }

  Future<List<UserChatModel>> getUserChat(String chatRoomID) async {
    final querySnapshot = await _firestore
        .collection('ChatRoom')
        .doc(chatRoomID)
        .collection('Chats')
        .orderBy("Time", descending: true)
        .get();
    List<UserChatModel> chat = [];
    querySnapshot.docs.forEach((element) {
      if (!element.get('DeleteMsgBy').contains(authCont.userss!.uid)) {
        chat.add(UserChatModel.fromDocumentSnapshot(element));
      }
    });
    return chat;
  }

  //ADDING LATEST MESSAGE IN THE CHATROOMID
  setDataInChatRoom(String chatRoomID, String msg, String sendBy) async {
    final data = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .get();
    List userData = data['userData'];
    userData[0]['msgData'] = {
      'LatestMsgSendBy': sendBy,
      'LatestMsg': msg,
      'LatestMsgSeenBy': [authCont.userss!.uid]
    };
    userData[1]['msgData'] = {
      'LatestMsgSendBy': sendBy,
      'LatestMsg': msg,
      'LatestMsgSeenBy': [authCont.userss!.uid]
    };
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .update({
      'userData': userData,
      'LatestMsgTime': FieldValue.serverTimestamp(),
    });
  }

  //DELETE CHAT MULTIPLE
  Future<void> deleteChat(String chatRoomID) async {
    final cont = Get.find<UserChatCont>();
    //DELETING LIST OF CHATS
    Get.dialog(
        LoadingDialog(
          text: 'Deleting Messages',
        ),
        barrierDismissible: false);

    cont.selectedDelMsgs.value!.forEach((element) async {
      final data = await _firestore
          .collection('ChatRoom')
          .doc(chatRoomID)
          .collection('Chats')
          .doc(element)
          .get();
      List deletedMsgBy = data.get('DeleteMsgBy');
      deletedMsgBy.add(authCont.userss!.uid);
      await _firestore
          .collection('ChatRoom')
          .doc(chatRoomID)
          .collection('Chats')
          .doc(element)
          .update({'DeleteMsgBy': deletedMsgBy});
    });

    cont.selectedDelMsgs.value = [];
    cont.selectedDelMsgs.refresh();
    Get.back();
  }

  updateDeleteMsgsInChatRoom(String chatRoomID) async {
    DocumentSnapshot? lastMsg;
    List<DocumentSnapshot> finalData = [];
    //GETTING LAST MSG FROM CHATS
    final chatData = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .collection('Chats')
        .orderBy("Time", descending: false)
        .get();

    if (chatData.docs.isNotEmpty) {
      for (int i = 0; i < chatData.docs.length; i++) {
        if (!chatData.docs[i]
            .get('DeleteMsgBy')
            .contains(authCont.userss!.uid)) {
          finalData.add(chatData.docs[i]);
        }
      }
      finalData.sort((a, b) => a['Time'].compareTo(b['Time']));
      finalData.reversed;
    }
    if (finalData.isNotEmpty) {
      lastMsg = finalData[finalData.length - 1];
      print(lastMsg.id);
    }

    //GETTING CHATROOMDATA
    final chatRoomData = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .get();
    int myIndex = chatRoomData['userData'][0]['id'] ==
            Get.find<AuthController>().userss!.uid
        ? 0
        : 1;
    List userData = chatRoomData['userData'];
    if (lastMsg != null) {
      userData[myIndex]['msgData'] = {
        'LatestMsgSendBy': lastMsg.get('SendBy'),
        'LatestMsg': lastMsg.get('Type') == 'audio'
            ? '1x audio'
            : lastMsg.get('Message'),
        'LatestMsgSeenBy': chatRoomData['users']
      };
    } else {
      userData[myIndex]['msgData'] = {
        'LatestMsgSendBy': authCont.userss!.uid,
        'LatestMsg': 'You deleted messages',
        'LatestMsgSeenBy': chatRoomData['users']
      };
    }
    //SAVING IN CHATROOM COLLECTION

    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .update({
      'userData': userData,
    });
  }

  Future<void> sendChatNotification(
      String articleID, String otherUserId, String chatRoomID) async {
    final userName = authCont.userInfo?.fullName ?? '';
    String myName = userName != "N/A" || userName != ''
        ? userName
        : authCont.userss!.email!.split("@")[0];

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(otherUserId)
        .collection("Notifications")
        .add({
      "Title": "$myName sent you a message",
      "Date": DateTime.now().toString(),
      "ArticleID": articleID,
      "ChatRoomID": chatRoomID,
      'OtherUserID': authCont.userss!.uid,
      "OtherUserImg": authCont.userInfo?.profilePic,
      "OtherUserName": authCont.userInfo?.fullName,
    });
  }

  seenQuery(String chatRoomID) async {
    final chatRoomData = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .get();
    List userData = chatRoomData['userData'];

    if (!userData[0]['msgData']['LatestMsgSeenBy']
        .contains(authCont.userss!.uid)) {
      userData[0]['msgData']['LatestMsgSeenBy'].add(authCont.userss!.uid);
    }
    if (!userData[1]['msgData']['LatestMsgSeenBy']
        .contains(authCont.userss!.uid)) {
      userData[1]['msgData']['LatestMsgSeenBy'].add(authCont.userss!.uid);
    }
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .update({'userData': userData});
  }
}
