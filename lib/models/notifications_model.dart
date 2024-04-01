import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsMOdel {
  String? id, chatRoomID, date, title,otherUserID, otherUserName, articleID, otherUserImg;
  NotificationsMOdel(
      {required this.chatRoomID,
      required this.otherUserID,
      required this.date,
      required this.id,
      required this.otherUserImg,
      required this.articleID,
      required this.otherUserName,
      required this.title});
  NotificationsMOdel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    chatRoomID = doc["ChatRoomID"];
    otherUserID=doc['OtherUserID'];
    date = doc["Date"];
    title = doc["Title"];
    articleID = doc['ArticleID'];
    otherUserImg = doc["OtherUserImg"];
    otherUserName = doc["OtherUserName"];
  }
}
