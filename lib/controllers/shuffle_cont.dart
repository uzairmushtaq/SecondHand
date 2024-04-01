import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secondhand/controllers/articles_controller.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/enums/articles_type.dart';
import 'package:secondhand/models/article_model.dart';
import 'package:tcard/tcard.dart';
import 'package:translator/translator.dart';

class ShuffleCont extends GetxController {
  RxBool loading = true.obs;
  RxBool isEndedArticles = false.obs;
  Rxn<List<ArticleModel>> articles = Rxn<List<ArticleModel>>();
  List<ArticleModel>? get getArticles => articles.value;
  TCardController cardCont = TCardController();
  final authCont = Get.find<AuthController>();
  final articlesCont = Get.find<ArticlesController>();
  final translator = GoogleTranslator();

  //GET SHUFFLE ARTICLES
  Future<void> getShuffleArticles({String? language}) async {
    List<ArticleModel> article = articlesCont.gettingArticles;
    for (int i = 0; i < article.length; i++) {
      if (
          !article[i].likedBy!.contains(authCont.userInfo?.id) &&
          !article[i].crossedBy!.contains(authCont.userInfo?.id)) {
        if (article[i].language != language) {
          Translation title = await translator.translate(article[i].title ?? "",
              from: article[i].language ?? "", to: language ?? "");
          article[i].title = title.text;
          Translation description = await translator.translate(
              article[i].description ?? "",
              from: article[i].language ?? "",
              to: language ?? "");
          article[i].description = description.text;
        }
        articles.value!.add(article[i]);
      } else {
        //print("This is item is expired ${article[i].title}");
      }
    }
  }

  //SUB CATEGORY ARTICLES
  Future<void> getSubCatArticles(String catID) async {
    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(catID)
        .get()
        .then((cat) async {
      List<ArticleModel> article = articlesCont.gettingArticles;
      for (int i = 0; i < article.length; i++) {
        if (
            !article[i].likedBy!.contains(authCont.userss!.uid) &&
            !article[i].crossedBy!.contains(authCont.userss!.uid)) {
          String catName = article[i].language == 'en'
              ? cat.get('name')
              : cat.get('name_de');
          if (article[i].categories!.contains(catName)) {
            articles.value!.add(article[i]);
          }
        }
      }
    });
    // List<ArticleModel> article = Get.find<ArticlesController>().gettingArticles;
    // for (int i = 0; i < article.length; i++) {
    //   final date = DateTime.now();
    //   final comingDate = DateTime.parse(article[i].expiryDate ?? "");
    //   final dateInMilliseconds = date.millisecondsSinceEpoch;
    //   final comingDateMilliseconds = comingDate.millisecondsSinceEpoch;
    //   if (article[i].categories!.contains(catName) &&
    //       comingDateMilliseconds > dateInMilliseconds &&
    //       
    //       !article[i]
    //           .likedBy!
    //           .contains(authCont.userss!.uid) &&
    //       !article[i]
    //           .crossedBy!
    //           .contains(authCont.userss!.uid)) {
    //     if (article[i].language != language) {
    //       Translation title = await translator.translate(article[i].title ?? "",
    //           from: article[i].language ?? "", to: language ?? "");
    //       article[i].title = title.text;
    //       Translation description = await translator.translate(
    //           article[i].description ?? "",
    //           from: article[i].language ?? "",
    //           to: language ?? "");
    //       article[i].description = description.text;
    //     }
    //     articles.add(article[i]);
    //   }
    // }
  }

  //CALCULATE DISTANCE FORMULA
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  //FOR SEARCH DATA
  Future<void> getSearchArticles(QuerySnapshot snapshotData) async {
    if (snapshotData.docs.length > 0) {
      for (int i = 0; i < snapshotData.docs.length; i++) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(authCont.userInfo?.id)
            .collection("SearchFilter")
            .doc("K7IIzI764EOiqSakEYXJ")
            .get()
            .then((value) {
          //FOR NOT SHOWING DRAFT AND EXPIRE ITEMS
          if (snapshotData.docs[i]["isDraft"] == false) {
            //IF SEARCH FILTER IS

            if (value.exists) {
              var contains = value["Categories"]
                  .toSet()
                  .intersection(snapshotData.docs[i]["Categories"].toSet());
              //print("These contains are $contains");
              if (calculateDistance(
                          value["LocationLat"],
                          value["LocationLng"],
                          snapshotData.docs[i]["Latitude"],
                          snapshotData.docs[i]["Longitude"])
                      .toInt() <
                  value["DistanceFilter"]) {
                if (int.parse(value["MaxPrice"]) == 0
                    ? 0 < int.parse(snapshotData.docs[i]["Price"])
                    : int.parse(value["MaxPrice"]) >
                            int.parse(snapshotData.docs[i]["Price"]) &&
                        value["ShowFree"] == snapshotData.docs[i]["isFree"] &&
                        value["Categories"]
                            .toSet()
                            .intersection(
                                snapshotData.docs[i]["Categories"].toSet())
                            .isNotEmpty) {
                  final article =
                      Get.find<ArticlesController>().gettingArticles;
                  for (int a = 0; a < article.length; a++) {
                    if (article[a].articleID ==
                        snapshotData.docs[i].id.toString()) {
                      articles.value!.add(article[a]);
                    }
                  }
                  value["LowestToHighestPrice"]
                      ? articles.value!.sort(((a, b) =>
                          int.parse(a.price!).compareTo(int.parse(b.price!))))
                      : articles.value!.sort(((a, b) =>
                          int.parse(b.price!).compareTo(int.parse(a.price!))));
                } else {}
              } else {}
            } else {
              articles.value = [];
              final article = Get.find<ArticlesController>().gettingArticles;
              for (int a = 0; a < article.length; a++) {
                for (int j = 0; j < snapshotData.docs.length; j++) {
                  if (article[a].articleID == snapshotData.docs[j].id &&
                      DateTime.parse(snapshotData.docs[j]["ExpiryDate"])
                              .millisecondsSinceEpoch >
                          DateTime.now().millisecondsSinceEpoch &&
                      snapshotData.docs[j]["isDraft"] == false) {
                    articles.value!.add(article[a]);
                  }
                }
              }
            }
          }
        });
      }
    }
  }

  //GET LIKED ARTICLES
  getLikedarticles({String? language}) async {
    List<ArticleModel> article = articlesCont.gettingArticles;
    for (int i = 0; i < article.length; i++) {
      if (article[i]
              .likedBy!
              .contains(Get.find<AuthController>().userss!.uid) &&
          
          !article[i]
              .crossedBy!
              .contains(Get.find<AuthController>().userss!.uid)) {
        if (article[i].language != language) {
          Translation title = await translator.translate(article[i].title ?? "",
              from: article[i].language ?? "", to: language ?? '');
          article[i].title = title.text;
          Translation description = await translator.translate(
              article[i].description ?? "",
              from: article[i].language ?? "",
              to: language ?? '');
          article[i].description = description.text;
        }

        articles.value!.add(article[i]);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    articles.value = [];
  }

  @override
  void dispose() {
    super.dispose();
    cardCont.dispose();
  }

  getShuffledArticles(String language, ShuffleType shuffleType,
      QuerySnapshot? snapshotData, String catID) async {
    if (shuffleType == ShuffleType.liked) {
      await getLikedarticles(language: language);
    }
    if (shuffleType == ShuffleType.shuffled) {
      await getShuffleArticles(language: language);
    }
    if (shuffleType == ShuffleType.byCategory) {
      await getSubCatArticles(catID);
    }
    if (shuffleType == ShuffleType.search) {
      await getSearchArticles(snapshotData!);
    }
    loading.value = false;
  }

}
