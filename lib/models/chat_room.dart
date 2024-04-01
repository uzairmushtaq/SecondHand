import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secondhand/controllers/auth_controller.dart';

class ChatRoomModel {
  String? id, articleID, articleName, articleOwnerID, msg, msgSendBy,latestMsgTime;
  List? articleImages, msgSeenBy, userData, chatUsers, archievedBy, deletedBy;
  
  ChatRoomModel(
      {this.archievedBy,
      this.id,
      this.articleID,
      this.articleImages,
      this.articleName,
      this.deletedBy,
      this.articleOwnerID,
      this.chatUsers,
      this.msg,
      this.msgSeenBy,
      this.latestMsgTime,
      this.msgSendBy,
      this.userData});
  ChatRoomModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    int myIndex =
        doc['userData'][0]['id'] == Get.find<AuthController>().userss!.uid
            ? 0
            : 1;
    id = doc.id;
    articleID = doc['ArticleID'];
    latestMsgTime=doc['LatestMsgTime'].toString();
    articleName = doc['ArticleName'];
    articleOwnerID = doc['ArticleOwnerID'];

    deletedBy = doc['DeletedBy'];
    articleImages = doc['ArticleImages'];
    archievedBy = doc['archievedBy'];
    userData = doc['userData'];
    msg = doc['userData'][myIndex]['msgData']['LatestMsg'];
    msgSeenBy = doc['userData'][myIndex]['msgData']['LatestMsgSeenBy'];
    msgSendBy = doc['userData'][myIndex]['msgData']['LatestMsgSendBy'];
    chatUsers = doc['users'];
  }
}
