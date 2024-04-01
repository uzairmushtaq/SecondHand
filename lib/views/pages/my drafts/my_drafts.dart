import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/order%20summary/order_summary.dart';
import 'package:secondhand/views/widgets/my_profile_email.dart';
import 'package:secondhand/views/widgets/no_data_widget.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../controllers/articles_controller.dart';

import '../../../models/article_model.dart';

class MyDraftsPage extends StatefulWidget {
  const MyDraftsPage({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<MyDraftsPage> createState() => _MyDraftsPageState();
}

class _MyDraftsPageState extends State<MyDraftsPage> {
  List<ArticleModel> draftsItems = [];
  gettingDraftItems() {
    authCont.isLoading.value = true;
    //FOR CHECKING RECENT SEARCH ITEMS
    List<ArticleModel> article = Get.find<ArticlesController>().getMyArticles;
    for (int i = 0; i < article.length; i++) {
      if ( article[i].isDraft == true) {
        draftsItems.add(article[i]);

        //print("Added all");
      }
    }
    authCont.isLoading.value = false;
  }

  @override
  void initState() {
    gettingDraftItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: SizeConfig.heightMultiplier * 2,
                    color: Colors.grey,
                  )),
              const Center(child: MyProfileAndEmailWidget()),
              Center(
                child: Container(
                    // height: SizeConfig.heightMultiplier * 50,
                    width: SizeConfig.widthMultiplier * 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 4,
                        vertical: SizeConfig.heightMultiplier * 2),
                    child: draftsItems.isEmpty
                        ? const NoDataWidget()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            itemCount: draftsItems.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: SizeConfig.heightMultiplier * 6,
                                      width: SizeConfig.widthMultiplier * 13,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  draftsItems[index].images?[0]),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.widthMultiplier * 4,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          draftsItems[index].title ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2.6),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.heightMultiplier * 0.5,
                                        ),
                                        //active widget
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: const Color(0xFFF59E0B),
                                                  borderRadius:
                                                      BorderRadius.circular(50)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: SizeConfig
                                                          .heightMultiplier *
                                                      0.5,
                                                  horizontal:
                                                      SizeConfig.widthMultiplier *
                                                          2),
                                              child: Text(
                                                "Draft",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.6,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  SizeConfig.widthMultiplier * 2,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    InkWell(
                                        onTap: () {
                                          //delete bottom sheet
                                          showModalBottomSheet(
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10))),
                                              context: context,
                                              builder: (_) => SizedBox(
                                                    height: SizeConfig
                                                            .heightMultiplier *
                                                        20,
                                                    width: SizeConfig
                                                            .widthMultiplier *
                                                        100,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .heightMultiplier *
                                                              1,
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            icon: WebsafeSvg.asset(
                                                                cancelIcon,
                                                                color: const Color(
                                                                    0xFF94A3B8))),
                                                        InkWell(
                                                          onTap: () {
                                                            Get.find<
                                                                    GlobalUIController>()
                                                                .articleID
                                                                .value = draftsItems[
                                                                        index]
                                                                    .articleID ??
                                                                "";
                                                            Get.to(() => OrderSummaryPage(
                                                                numberOfPhotos:
                                                                    draftsItems[
                                                                            index]
                                                                        .images!
                                                                        .length,
                                                                isRepost: false));
                                                          },
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        SizeConfig
                                                                                .widthMultiplier *
                                                                            4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Publish Draft",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          SizeConfig.textMultiplier *
                                                                              2.1,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: const Color(
                                                                          0xFF475569)),
                                                                ),
                                                                const Spacer(),
                                                                const Icon(
                                                                  FeatherIcons
                                                                      .upload,
                                                                  color: Color(
                                                                      0xFF94A3B8),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: SizeConfig
                                                                      .widthMultiplier *
                                                                  4),
                                                          child: Divider(
                                                            height: SizeConfig
                                                                    .heightMultiplier *
                                                                3,
                                                            thickness: 1.5,
                                                            color: Colors
                                                                .grey.shade200,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Articles")
                                                                .doc(draftsItems[
                                                                        index]
                                                                    .articleID)
                                                                .delete();
                                                            Get.back();
                                                          },
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        SizeConfig
                                                                                .widthMultiplier *
                                                                            4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Delete Draft",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          SizeConfig.textMultiplier *
                                                                              2.1,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: const Color(
                                                                          0xFF475569)),
                                                                ),
                                                                const Spacer(),
                                                                const Icon(
                                                                  Icons
                                                                      .delete_outline_outlined,
                                                                  color: Color(
                                                                      0xFF94A3B8),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                        },
                                        child: const Icon(Icons.more_horiz))
                                  ],
                                ),
                                index == draftsItems.length - 1
                                    ? const SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.heightMultiplier * 1),
                                        child: Divider(
                                          thickness: 1.5,
                                          color: Colors.grey.shade200,
                                        ),
                                      )
                              ],
                            ),
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
