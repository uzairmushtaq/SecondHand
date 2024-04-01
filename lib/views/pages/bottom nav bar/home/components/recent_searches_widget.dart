import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:secondhand/controllers/articles_controller.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import '../../../../../models/article_model.dart';
import '../../../item details/items_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecentSearchesWidget extends StatefulWidget {
  const RecentSearchesWidget({
    Key? key,
    required this.uid,
  }) : super(key: key);
  final String uid;
  @override
  State<RecentSearchesWidget> createState() => _RecentSearchesWidgetState();
}

class _RecentSearchesWidgetState extends State<RecentSearchesWidget> {
  List<ArticleModel> recentSearch = [];
  gettingRecentSearchData() {
    recentSearch = [];
    //FOR CHECKING RECENT SEARCH ITEMS
    List<ArticleModel> article = Get.find<ArticlesController>().gettingArticles;
    for (int i = 0; i < article.length; i++) {
      if (article[i].likedBy!.contains(widget.uid) &&
          article[i].isDraft == false) {
        recentSearch.add(article[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetX<ArticlesController>(
            init: ArticlesController(),
            builder: (article) {
              gettingRecentSearchData();
              if (article.loading.value) {
                return const Loading();
              }
              return recentSearch.isEmpty
                  ? SizedBox()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: recentSearch.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 375),
                                childAnimationBuilder: (widget) =>
                                    SlideAnimation(
                                  horizontalOffset: 150.0,
                                  child: FadeInAnimation(
                                    child: widget,
                                  ),
                                ),
                                children: [
                                  //recent searches
                                  (0 == 1)
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: SizeConfig.widthMultiplier *
                                                  6),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .recent_searches,
                                            //"Recent Searches",
                                            style: TextStyle(
                                                color: const Color(0xff475569),
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        3.5),
                                          ),
                                        )
                                      : SizedBox(height: 15),
                                  Row(
                                    children: [
                                      ...List.generate(recentSearch.length,
                                          (index) {
                                        return InkWell(
                                            onTap: () {
                                              Get.to(
                                                  () => ItemDetailsPage(
                                                        article:
                                                            recentSearch[index],
                                                      ),
                                                  transition:
                                                      Transition.downToUp);
                                            },
                                            child: Container(
                                              height:
                                                  SizeConfig.heightMultiplier *
                                                      20,
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      33,
                                              margin: EdgeInsets.only(
                                                  top: SizeConfig
                                                          .heightMultiplier *
                                                      1,
                                                  bottom: SizeConfig
                                                          .heightMultiplier *
                                                      2,
                                                  left: index == 0
                                                      ? SizeConfig
                                                              .widthMultiplier *
                                                          6
                                                      : SizeConfig
                                                              .widthMultiplier *
                                                          4),
                                              color: Colors.white,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: SizeConfig
                                                            .heightMultiplier *
                                                        20,
                                                    width: SizeConfig
                                                            .widthMultiplier *
                                                        33,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                                0xff475569)
                                                            .withOpacity(0.6),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              blurRadius: 10)
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: ShaderMask(
                                                        shaderCallback: (rect) {
                                                          return const LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                              Colors.black,
                                                              Colors.transparent
                                                            ],
                                                          ).createShader(
                                                              Rect.fromLTRB(
                                                                  0,
                                                                  0,
                                                                  rect.width,
                                                                  rect.height));
                                                        },
                                                        blendMode:
                                                            BlendMode.dstIn,
                                                        child: Image.network(
                                                          recentSearch[index]
                                                              .images?[0],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  //product name and price
                                                  Positioned(
                                                      bottom: 0,
                                                      left: SizeConfig
                                                              .widthMultiplier *
                                                          2,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            width: SizeConfig
                                                                    .widthMultiplier *
                                                                25,
                                                            child: Text(
                                                              recentSearch[
                                                                          index]
                                                                      .title ??
                                                                  "loading...",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .textMultiplier *
                                                                          2.2,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: SizeConfig
                                                                    .heightMultiplier *
                                                                0.5,
                                                          ),
                                                          SizedBox(
                                                            width: SizeConfig
                                                                    .widthMultiplier *
                                                                25,
                                                            child: Text(
                                                              recentSearch[
                                                                          index]
                                                                      .price! +
                                                                  " €",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .textMultiplier *
                                                                          1.8,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: SizeConfig
                                                                    .heightMultiplier *
                                                                1,
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              ),
                                            ));
                                      })
                                    ],
                                  )
                                ],
                              ),
                            )
                          : SizedBox());
            }),
      ],
    );
  }
}
