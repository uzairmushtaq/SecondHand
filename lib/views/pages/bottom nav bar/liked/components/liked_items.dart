import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/like_items_cont.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/no_data_widget.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import '../../../item details/items_details.dart';

class LikedItems extends StatelessWidget {
  const LikedItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<LikedItemsCont>(
        init: LikedItemsCont(),
        builder: (article) {
          return article.isLoading.value
              ? SizedBox(
                  height: SizeConfig.heightMultiplier * 70, child: Loading())
              : article.likedItems.value!.isEmpty
                  ? SizedBox(
                      height: SizeConfig.heightMultiplier * 70,
                      child: NoDataWidget())
                  : article.likedItems.value!.isNotEmpty
                      ? Column(
                          children: [
                            Container(
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: ListView.builder(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            SizeConfig.heightMultiplier * 10,
                                        top: SizeConfig.heightMultiplier * 2),
                                    itemCount: article.likedItems.value!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () {
                                            Get.to(
                                                () => ItemDetailsPage(
                                                      article: article
                                                          .likedItems
                                                          .value![index],
                                                    ),
                                                transition:
                                                    Transition.downToUp);
                                          },
                                          child: Container(
                                            height:
                                                SizeConfig.heightMultiplier *
                                                    30,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                45,
                                            margin: EdgeInsets.only(
                                                top: SizeConfig
                                                        .heightMultiplier *
                                                    1,
                                                bottom: SizeConfig
                                                        .heightMultiplier *
                                                    2,
                                                left:
                                                    SizeConfig.widthMultiplier *
                                                        6),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: SizeConfig
                                                          .heightMultiplier *
                                                      30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      (SizeConfig
                                                              .widthMultiplier *
                                                          12),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                              0xff475569)
                                                          .withOpacity(0.6),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 10)
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
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
                                                        child:
                                                            CachedNetworkImage(
                                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 1.5,color: kPrimaryColor)),
                                                          imageUrl: article
                                                              .likedItems
                                                              .value![index]
                                                              .images?[0],
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                ),
                                                //product name and price
                                                Positioned(
                                                    bottom: 0,
                                                    left: SizeConfig
                                                            .widthMultiplier *
                                                        2,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        //ITEM TITLE
                                                        SizedBox(
                                                          width: SizeConfig
                                                                  .widthMultiplier *
                                                              25,
                                                          child: Text(
                                                            article
                                                                    .likedItems
                                                                    .value![
                                                                        index]
                                                                    .title ??
                                                                "loading...",
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
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
                                                        //ITEM SELLER NAME
                                                        SizedBox(
                                                          width: SizeConfig
                                                                  .widthMultiplier *
                                                              80,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "By",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .textMultiplier *
                                                                          1.1,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: SizeConfig
                                                                          .widthMultiplier *
                                                                      .5),
                                                              //GET USERNAME
                                                              StreamBuilder<
                                                                      DocumentSnapshot>(
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "Users")
                                                                      .doc(article
                                                                          .likedItems
                                                                          .value![
                                                                              index]
                                                                          .userID!)
                                                                      .snapshots(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    final isWaiting = snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting;
                                                                    final user =
                                                                        snapshot
                                                                            .data;
                                                                    return Text(
                                                                      isWaiting
                                                                          ? 'Unknown'
                                                                          : user!['ShowAlias'] &&
                                                                                  user['ShowAlias'] !=
                                                                                      'Optional'
                                                                              ? [
                                                                                  'Alias'
                                                                                ]
                                                                              : user['Fullname'] ?? 'Unknown',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: SizeConfig.textMultiplier *
                                                                              1.4,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    );
                                                                  })
                                                            ],
                                                          ),
                                                        ),
                                                        //PRICE
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
                                                            article
                                                                    .likedItems
                                                                    .value![
                                                                        index]
                                                                    .price! +
                                                                " €",
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
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
                                    }))
                          ],
                        )
                      : SizedBox();
        });
  }
}
