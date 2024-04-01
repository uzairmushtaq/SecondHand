import 'package:cloud_firestore/cloud_firestore.dart';

class AllUserModel {
  String? id, email, password, phone, fullName,profilePic,alias;
  AllUserModel({
    this.password,
    this.email,
    this.id,
    this.fullName,
    this.phone,
    this.profilePic,
    this.alias,
  });
  AllUserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    email = doc["Email"];
    password = doc["Password"];
    phone = doc["Phone"];
    profilePic=doc["ProfilePic"];
    fullName = doc["Fullname"];
    alias = doc["Alias"];
  }
}
