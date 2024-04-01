import 'package:cloud_firestore/cloud_firestore.dart';

class UserChatModel {
  String? id, msg, photo, sendby, time, type;
  bool? seen;
  List? images;
  UserChatModel(
      {this.id,
      this.images,
      this.time,
      this.msg,
      this.photo,
      this.seen,
      this.sendby,
      this.type});
  UserChatModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    msg = doc['Message'];
    photo = doc['Photo'];
    seen = doc['Seen'];
    time = doc['Time'];
    type = doc['Type'];
    images = doc['Images'];
    sendby=doc['SendBy'];
  }
   UserChatModel.fromMap(Map<String,dynamic> doc) {
    id = '';
    msg = doc['Message'];
    photo = doc['Photo'];
    seen = doc['Seen'];
    time = doc['Time'];
    type = doc['Type'];
    images = doc['Images'];
    sendby=doc['SendBy'];
  }
}
