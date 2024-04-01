import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:secondhand/controllers/articles_controller.dart';
import 'package:secondhand/models/article_model.dart';
import 'package:translator/translator.dart';

import 'auth_controller.dart';

class LikedItemsCont extends GetxController {
  RxBool isLoading = true.obs;
  Rxn<List<ArticleModel>> likedItems = Rxn<List<ArticleModel>>();
  
  Future gettingLikedItemsData() async {
    likedItems.value = [];
    final translator = GoogleTranslator();
    final articleCont = Get.find<ArticlesController>();
    final uid = Get.find<AuthController>().userss?.uid;
    Locale myLocale = Localizations.localeOf(Get.overlayContext!);

    //FOR CHECKING RECENT SEARCH ITEMS
    List<ArticleModel> article = articleCont.gettingArticles;
    for (int i = 0; i < article.length; i++) {
      if (article[i].likedBy!.contains(uid) && article[i].isDraft == false) {
        if (article[i].language != myLocale.languageCode) {
          Translation title = await translator.translate(article[i].title ?? "",
              from: article[i].language ?? "", to: myLocale.languageCode);
          article[i].title = title.text;
          Translation description = await translator.translate(
              article[i].description ?? "",
              from: article[i].language ?? "",
              to: myLocale.languageCode);
          article[i].description = description.text;
        }
        likedItems.value!.add(article[i]);
      }
    }
    isLoading.value=false;
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero,
        () => gettingLikedItemsData());
  }
}
