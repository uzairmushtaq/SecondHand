import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:secondhand/services/database.dart';

import '../models/article_model.dart';
import 'auth_controller.dart';

class ArticlesController extends GetxController {
  
  RxBool loading = false.obs;
  Rxn<List<ArticleModel>> articles = Rxn<List<ArticleModel>>();
  List<ArticleModel> get gettingArticles => articles.value ?? [];
    Rxn<List<ArticleModel>> myArticles = Rxn<List<ArticleModel>>();
  List<ArticleModel> get getMyArticles => myArticles.value ?? [];
  @override
  void onInit() {
    loading.value = true;
    articles.bindStream(DataBase().streamOfAllArticles());
    
    super.onInit();
  }

  Future<void> viewCounter(String articleID) async {
    await FirebaseFirestore.instance
        .collection("Articles")
        .doc(articleID)
        .get()
        .then((value) {
      List views = value.get("Views");
      if (!views.contains(Get.find<AuthController>().userss!.uid)) {
        views.add(Get.find<AuthController>().userss!.uid);
      } else {
        //print("Already Viewed");
      }
      FirebaseFirestore.instance
          .collection("Articles")
          .doc(articleID)
          .update({"Views": views});
    });
  }

  Future<void> deleteArticle(String articleID) async {
    await FirebaseFirestore.instance
        .collection("Articles")
        .doc(articleID)
        .delete();
  }
}
