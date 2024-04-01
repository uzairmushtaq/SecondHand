import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/my_profile_email.dart';
import 'package:secondhand/views/widgets/no_data_widget.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../controllers/articles_controller.dart';

import '../../../models/article_model.dart';

class SavedSearchesPage extends StatefulWidget {
  const SavedSearchesPage({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<SavedSearchesPage> createState() => _SavedSearchesPageState();
}

class _SavedSearchesPageState extends State<SavedSearchesPage> {
  List<ArticleModel> savedSearches = [];
  gettingRecentSearchData() {
    authCont.isLoading.value = true;
    //FOR CHECKING RECENT SEARCH ITEMS
    List<ArticleModel> article = Get.find<ArticlesController>().gettingArticles;
    for (int i = 0; i < article.length; i++) {
      if (article[i].searchBy!.contains(widget.uid) &&
          article[i].isDraft == false) {
        savedSearches.add(article[i]);

        //print("Added all");
      }
    }
    authCont.isLoading.value = false;
  }

  @override
  void initState() {
    gettingRecentSearchData();
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
                    child: Obx(
                      () => ShowLoading(
                        inAsyncCall: authCont.isLoading.value,
                        child: savedSearches.isNotEmpty
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemCount: savedSearches.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: SizeConfig.heightMultiplier * 6,
                                          width: SizeConfig.widthMultiplier * 13,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      savedSearches[index]
                                                              .images?[0] ??
                                                          ""),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.widthMultiplier * 4,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: SizeConfig.heightMultiplier *
                                                  1.5),
                                          child: Text(
                                            savedSearches[index].title ?? "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        2.6),
                                          ),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                            onTap: () {
                                              //delete bottom sheet
                                              showModalBottomSheet(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10))),
                                                  context: context,
                                                  builder: (_) => SizedBox(
                                                        height: SizeConfig
                                                                .heightMultiplier *
                                                            13,
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
                                                                onPressed: () {},
                                                                icon: WebsafeSvg.asset(
                                                                    cancelIcon,
                                                                    color: const Color(
                                                                        0xFF94A3B8))),
                                                            InkWell(
                                                              onTap: () async {
                                                                final savedList =
                                                                    savedSearches[
                                                                            index]
                                                                        .searchBy;
                                                                savedList!.remove(
                                                                    widget.uid);
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "Articles")
                                                                    .doc(savedSearches[
                                                                            index]
                                                                        .articleID)
                                                                    .update({
                                                                  "SearchBy":
                                                                      savedList
                                                                }).then((value) {
                                                                  Get.back();
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            SizeConfig.widthMultiplier *
                                                                                4),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Delete Search",
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
                                                            )
                                                          ],
                                                        ),
                                                      ));
                                            },
                                            child: const Icon(Icons.more_horiz))
                                      ],
                                    ),
                                    index == savedSearches.length - 1
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    SizeConfig.heightMultiplier *
                                                        1),
                                            child: Divider(
                                              thickness: 1.5,
                                              color: Colors.grey.shade200,
                                            ),
                                          )
                                  ],
                                ),
                              )
                            : NoDataWidget(),
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
