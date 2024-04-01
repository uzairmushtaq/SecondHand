import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:secondhand/controllers/articles_controller.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/enums/articles_type.dart';
import 'package:secondhand/models/article_model.dart';
import 'package:secondhand/views/pages/articles/articles.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'package:translator/translator.dart';

import '../../../../../constants/colors.dart';
import '../../../../../models/categories_model.dart';
import '../../../../../utils/size_config.dart';

class CategoriesWidget extends StatefulWidget {
  CategoriesWidget({Key? key}) : super(key: key);

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  // final String language;
  final globalCont = Get.find<GlobalUIController>();

  getSubCatData() async {
    await FirebaseFirestore.instance
        .collection('Categories')
        .get()
        .then((cat) async {
      for (int c = 0; c < cat.docs.length; c++) {
        List<ArticleModel> article =
            Get.find<ArticlesController>().gettingArticles;
        //print('ARTICLES ');
        for (int i = 0; i < article.length; i++) {
          final date = DateTime.now();
          final comingDate = DateTime.parse(article[i].expiryDate ?? "");
          final dateInMilliseconds = date.millisecondsSinceEpoch;
          final comingDateMilliseconds = comingDate.millisecondsSinceEpoch;
          if (comingDateMilliseconds > dateInMilliseconds &&
              article[i].isDraft == false &&
              !article[i]
                  .likedBy!
                  .contains(Get.find<AuthController>().userss!.uid) &&
              !article[i]
                  .crossedBy!
                  .contains(Get.find<AuthController>().userss!.uid)) {
            ///TODO
            // if(article[i].categories!.contains(widget.catName)){}
            String catName = article[i].language == 'en'
                ? cat.docs[c].get('name')
                : cat.docs[c].get('name_de');
            if (article[i].categories!.contains(catName)) {
              //print('HELLO');
              int count = globalCont.catCount[c] ?? 0;
              count = count + 1;
              globalCont.catCount[c] = count;
            }
          }
        }
      }
    });
    //print(globalCont.catCount.toString());
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => getSubCatData());
  }

  @override
  void dispose() {
    super.dispose();
    globalCont.catCount.value = {};
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("Categories").snapshots(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Loading()
                : GridView.count(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 0.5,
                        right: SizeConfig.widthMultiplier * 6,
                        left: SizeConfig.widthMultiplier * 6),
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    mainAxisSpacing: SizeConfig.heightMultiplier * 1,
                    crossAxisSpacing: SizeConfig.widthMultiplier * 2,
                    shrinkWrap: true,
                    children: List.generate(
                      snapshot.data!.docs.length,
                      (int index) {
                        //getTranslation(snapshot.data?.docs[index]['name_en'], myLocale);
                        return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            columnCount: 12,
                            child: ScaleAnimation(
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: FadeInAnimation(
                                    child: InkWell(
                                  onTap: () {
                                    Get.to(() => ArticlesPage(
                                          shuffleType: ShuffleType.byCategory,
                                          catID:
                                              snapshot.data?.docs[index].id ??
                                                  '',
                                          language: myLocale.languageCode,
                                        ));
                                  },
                                  child: SizedBox(
                                    height: SizeConfig.heightMultiplier * 18,
                                    width: SizeConfig.widthMultiplier * 100,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        (snapshot.data?.docs[index]
                                                    .get("img") !=
                                                '')
                                            ? Positioned.fill(
                                                left: 0,
                                                right: 0,
                                                child: SizedBox(
                                                  height: SizeConfig
                                                          .heightMultiplier *
                                                      18,
                                                  width: SizeConfig
                                                          .widthMultiplier *
                                                      100,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: CachedNetworkImage(
                                                        placeholder: (_, s) => Center(
                                                            child: CircularProgressIndicator(
                                                                strokeWidth:
                                                                    1.5,
                                                                color:
                                                                    kPrimaryColor)),
                                                        fit: BoxFit.fill,
                                                        imageUrl: snapshot
                                                            .data?.docs[index]
                                                            .get("img")),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        // Container(
                                        //   decoration: (snapshot
                                        //               .data?.docs[index]
                                        //               .get("img") !=
                                        //           '')
                                        //       ? BoxDecoration(
                                        //           image: DecorationImage(
                                        //               image: NetworkImage(
                                        //                   ),
                                        //               fit: BoxFit.fill),
                                        //           borderRadius:
                                        //               BorderRadius.circular(12))
                                        //       : null,
                                        // ),
                                        Positioned.fill(
                                          right:
                                              SizeConfig.widthMultiplier * 2.5,
                                          left:
                                              SizeConfig.widthMultiplier * 2.5,
                                          bottom:
                                              SizeConfig.heightMultiplier * 1.3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: kPrimaryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                        ),
                                        Positioned(
                                          left: SizeConfig.widthMultiplier * 5,
                                          right: SizeConfig.widthMultiplier * 5,
                                          child: Column(
                                            children: [
                                              Text(
                                                snapshot.data?.docs[index].get(
                                                    (myLocale.languageCode ==
                                                            'en')
                                                        ? "name"
                                                        : "name_de"),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        2.5,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Obx(
                                                () => Text(
                                                  globalCont.catCount[index] ==
                                                          null
                                                      ? '(0)'
                                                      : '(${globalCont.catCount[index]})'
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          2.5,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))));
                      },
                    ),
                  );
          }),
    );
  }
}
