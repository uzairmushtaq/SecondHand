import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  Future queryData(String queryString, String orderBy) async {
    //print('####');
    //print(queryString);
    return FirebaseFirestore.instance
        .collection("Articles")
        .where("searchKey", isEqualTo: queryString.toLowerCase())
        // .orderBy('Price', descending: true)
        .get();
  }
}
