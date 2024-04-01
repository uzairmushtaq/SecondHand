import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask uploadImg(String destination, File file)  {
    try {
      final imgRef = FirebaseStorage.instance.ref(destination);
      return imgRef.putFile(file);
      

      
    // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
}
