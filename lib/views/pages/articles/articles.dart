import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:secondhand/controllers/articles_controller.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/controllers/shuffle_cont.dart';
import 'package:secondhand/enums/articles_type.dart';
import 'package:secondhand/utils/dynamic_links.dart';
import 'package:secondhand/views/pages/item%20details/items_details.dart';
import 'package:secondhand/views/widgets/custom_appbar.dart';
import 'package:secondhand/views/widgets/custom_auth_snackbar.dart';
import 'package:secondhand/views/widgets/no_data_widget.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'package:tcard/tcard.dart';
import 'package:websafe_svg/websafe_svg.dart';
import '../../../constants/colors.dart';
import '../../../constants/icons.dart';
import '../../../utils/size_config.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage(
      {Key? key,
      this.language,
      required this.shuffleType,
      this.catID = '',
      this.snapshotData})
      : super(key: key);
  final String? language;
  final ShuffleType shuffleType;
  final String catID;
  final QuerySnapshot? snapshotData;
  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final cont = Get.put(ShuffleCont());

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero,
        () => cont.getShuffledArticles(widget.language ?? '',
            widget.shuffleType, widget.snapshotData, widget.catID));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Column(
          children: [
            const CustomAppbar(isProfileIcon: false),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1,
            ),
            Obx(
              () => cont.loading.value
                  ? SizedBox(height: Get.height * 0.8, child: Loading())
                  : cont.getArticles!.length > 0
                      ? Obx(
                          () => SizedBox(
                            height: SizeConfig.heightMultiplier * 85,
                            child: cont.getArticles!.isEmpty ||
                                    cont.isEndedArticles.value
                                ? SizedBox(
                                    height: Get.height * 0.8,
                                    child: NoDataWidget())
                                : TCard(
                                    cards: [
                                      for (int i = 0;
                                          i < cont.getArticles!.length;
                                          i++) ...[ArticleCard(i: i)]
                                    ],

                                    ///CARD SETTINGS
                                    size: Size(SizeConfig.heightMultiplier * 80,
                                        SizeConfig.widthMultiplier * 100),
                                    controller: cont.cardCont,
                                    onForward: (index, info) async {
                                      if (index > 0) {
                                        int i = index - 1;
                                        if (cont.getArticles![i] != null) {
                                          if (info.direction ==
                                              SwipDirection.Left) {
                                            if (!cont.getArticles![i].likedBy!
                                                .contains(
                                                    Get.find<AuthController>()
                                                        .userss!
                                                        .uid)) {
                                              cont.getArticles![i].likedBy!.add(
                                                  Get.find<AuthController>()
                                                      .userss!
                                                      .uid);
                                              await FirebaseFirestore.instance
                                                  .collection("Articles")
                                                  .doc(cont.getArticles![i]
                                                      .articleID)
                                                  .update({
                                                "LikedBy": cont
                                                    .getArticles![i].likedBy!,
                                              });
                                            }
                                          } else if (info.direction ==
                                              SwipDirection.Right) {
                                            if (!cont.getArticles![i].crossedBy!
                                                .contains(
                                                    Get.find<AuthController>()
                                                        .userss!
                                                        .uid)) {
                                              cont.getArticles![i].crossedBy!
                                                  .add(
                                                      Get.find<AuthController>()
                                                          .userss!
                                                          .uid);
                                              await FirebaseFirestore.instance
                                                  .collection("Articles")
                                                  .doc(cont.getArticles![i]
                                                      .articleID)
                                                  .update({
                                                "CrossedBy": cont
                                                    .getArticles![i].crossedBy!,
                                              });
                                            }
                                          }
                                        }
                                      }
                                    },
                                    onBack: (index, info) {
                                      //print(index);
                                    },
                                    onEnd: () {
                                      cont.isEndedArticles.value = true;
                                    },
                                  ),
                          ),
                        )
                      : SizedBox(
                          height: Get.height * 0.8, child: NoDataWidget()),
            )
          ],
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  ArticleCard({
    Key? key,
    required this.i,
  }) : super(key: key);

  final int i;
  final cont = Get.find<ShuffleCont>();
  final defaultSwipeIconSize = SizeConfig.heightMultiplier * 8;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //product image widget
        Container(
          height: SizeConfig.heightMultiplier * 78,
          width: SizeConfig.widthMultiplier * 100,
          margin:
              EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 2),
          
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
             
              borderRadius: BorderRadius.circular(30)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CachedNetworkImage(
                placeholder: (_, s) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: kPrimaryColor,
                      ),
                    ),
                imageUrl: cont.getArticles![i].images![0] ?? '',
                fit: BoxFit.cover),
          ),
        ),
        Positioned(
          right: SizeConfig.widthMultiplier * 10,
          left: SizeConfig.widthMultiplier * 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 4,
              ),
              //product title with price tag
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cont.getArticles![i].title ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.textMultiplier * 3.7,
                              color: Colors.black),
                        ),
                        Text(
                          cont.getArticles![i].owner?.name == '' ||
                                  cont.getArticles![i].owner?.name ==
                                      'Not added yet'
                              ? 'Unknown user'
                              : cont.getArticles![i].owner?.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: SizeConfig.textMultiplier * 1.5,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        DynamicLinkHelperClass dynamicLinkHelper =
                            DynamicLinkHelperClass();
                        dynamicLinkHelper
                            .createDynamicLink(cont.getArticles![i].articleID!)
                            .then((value) {
                          dynamicLinkHelper.shareData(
                              context,
                              cont.getArticles![i].title! + ": $value",
                              cont.getArticles![i].description!);
                        });
                      },
                      icon:
                          const Icon(FeatherIcons.upload, color: Colors.white))
                ],
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 1,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.heightMultiplier * 0.3,
                        horizontal: SizeConfig.widthMultiplier * 2),
                    decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(40)),
                    child: Text(
                      "${cont.getArticles![i].currency} ${double.parse(cont.getArticles![i].price!).toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 2.1),
                    ),
                  ),
                  SizedBox(width: 10),
                  (cont.getArticles![i].language != null)
                      ? SizedBox(
                          height: SizeConfig.heightMultiplier * 3,
                          width: SizeConfig.widthMultiplier * 8,
                          child: WebsafeSvg.asset(
                              "assets/icons/" +
                                  cont.getArticles![i].language! +
                                  ".svg",
                              fit: BoxFit.cover),
                        )
                      : SizedBox(),
                  const Spacer(),
                  WebsafeSvg.asset(passEyeIcon, color: Colors.white),
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 2,
                  ),
                  Text(
                    cont.getArticles![i].views!.length.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: SizeConfig.textMultiplier * 2.1),
                  )
                ],
              ),
              SizedBox(
                height: i == 0
                    ? SizeConfig.heightMultiplier * 44
                    : SizeConfig.heightMultiplier * 46,
              ),
              //info,etc buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      if (!cont.getArticles![i].crossedBy!
                          .contains(Get.find<AuthController>().userss!.uid)) {
                        cont.getArticles![i].crossedBy!
                            .add(Get.find<AuthController>().userss!.uid);
                        cont.cardCont.forward(direction: SwipDirection.Left);
                        await FirebaseFirestore.instance
                            .collection("Articles")
                            .doc(cont.getArticles![i].articleID)
                            .update({
                          "CrossedBy": cont.getArticles![i].crossedBy!,
                        });
                      } else {
                        cont.cardCont.forward(direction: SwipDirection.Left);
                      }
                    },
                    child: Container(
                      height: SizeConfig.heightMultiplier * 7.5,
                      width: SizeConfig.widthMultiplier * 14.5,
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor, width: 2),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(crossSwipeICon))),
                    ),
                  ),
                  /*
        InkWell(
          onTap: () {
            _controller.back();
          },
          child: WebsafeSvg.asset(leftSwipeIcon,
              height: defaultSwipeIconSize),
        ),
    
         */
                  InkWell(
                      onTap: () {
                        Get.find<ArticlesController>()
                            .viewCounter(cont.getArticles![i].articleID ?? "");
                        Get.to(
                            () => ItemDetailsPage(
                                  article: cont.getArticles![i],
                                ),
                            transition: Transition.rightToLeft);
                      },
                      child: WebsafeSvg.asset(infoSwipeICon,
                          height: defaultSwipeIconSize)),
                  cont.getArticles![i].userID ==
                          Get.find<AuthController>().userss!.uid
                      ?
                      //DELETE BUTTON IF ARTICLE IS USER ARTICLE
                      IconButton(
                          onPressed: () async {
                            Get.find<ArticlesController>()
                                .deleteArticle(
                                    cont.getArticles![i].articleID ?? "")
                                .then((value) => cont.cardCont.forward())
                                .then((value) => ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        padding: EdgeInsets.all(0),
                                        content: CustomAuthSnackBar(
                                            title: "Deleted Successfully :)",
                                            subTitle:
                                                "Your article will no longer available in this app"))));
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))
                      :
                      //LIKE BUTTON IF ARTICLE IS NOT USER ARTICLE
                      InkWell(
                          onTap: () async {
                            if (!cont.getArticles![i].likedBy!.contains(
                                Get.find<AuthController>().userss!.uid)) {
                              cont.getArticles![i].likedBy!
                                  .add(Get.find<AuthController>().userss!.uid);
                              cont.cardCont
                                  .forward(direction: SwipDirection.Right);
                              await FirebaseFirestore.instance
                                  .collection("Articles")
                                  .doc(cont.getArticles![i].articleID)
                                  .update({
                                "LikedBy": cont.getArticles![i].likedBy!,
                              });
                            } else {
                              cont.cardCont
                                  .forward(direction: SwipDirection.Right);
                            }
                          },
                          child: Container(
                            height: SizeConfig.heightMultiplier * 7.5,
                            width: SizeConfig.widthMultiplier * 14.5,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: kPrimaryColor, width: 2),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(tickSwipeICon))),
                          ),
                        ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
