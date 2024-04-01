import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id, email, password, phone, fullName,profilePic,alias,language;
  bool? showAlias,showNumber;
  List? blockedUsers,blockedFrom;
  UserModel({
    this.password,
    this.email,
    this.id,
    this.blockedUsers,
    this.blockedFrom,
    this.fullName,
    this.phone,
    this.profilePic,
    this.alias,
    this.showAlias,
    this.showNumber,
    this.language
  });
  UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    email = doc["Email"];
    password = doc["Password"];
    blockedFrom=doc['BlockedFrom'];
    blockedUsers=doc['BlockUsers'];
    phone = doc["Phone"];
    profilePic=doc["ProfilePic"];
    fullName = doc["Fullname"];
    alias=doc["Alias"];
    showAlias=doc["ShowAlias"];
    showNumber=doc["ShowNumber"];
    language=doc["Language"];
    ////print("name is $fullName");
  }
}
