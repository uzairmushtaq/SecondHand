import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/views/widgets/no_data_widget.dart';
import 'package:websafe_svg/websafe_svg.dart';
import '../../constants/icons.dart';
import '../../controllers/articles_controller.dart';
import '../../controllers/selected_text_controller.dart';
import '../../models/article_model.dart';
import '../../utils/size_config.dart';
import '../pages/item details/items_details.dart';
import '../pages/order summary/order_summary.dart';

class RePostOldAdsBottomSheet extends StatefulWidget {
  const RePostOldAdsBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<RePostOldAdsBottomSheet> createState() =>
      _RePostOldAdsBottomSheetState();
}

class _RePostOldAdsBottomSheetState extends State<RePostOldAdsBottomSheet> {
  final articleCont = Get.put(ArticlesController());
  String? expiryDate;
  String? comingDate;
  final date = DateTime.now();
  final List<ArticleModel> rePostItems = [];
  //SHOWING ONLY NOT EXPIRED ITEMS
  @override
  void initState() {
    List<ArticleModel> article = articleCont.getMyArticles;
    for (int i = 0; i < article.length; i++) {
      final date = DateTime.now();
      final comingDate = DateTime.parse(article[i].expiryDate ?? "");
      final dateInMilliseconds = date.millisecondsSinceEpoch;
      final comingDateMilliseconds = comingDate.millisecondsSinceEpoch;
      if (comingDateMilliseconds < dateInMilliseconds &&
          article[i].isDraft == false) {
        rePostItems.add(article[i]);
      } else {
        //print("This is item is expired ${article[i].title}");
      }
    }
    super.initState();
  }

  final globalCont = Get.find<GlobalUIController>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.heightMultiplier * 80,
      width: SizeConfig.widthMultiplier * 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon:
                  WebsafeSvg.asset(cancelIcon, color: const Color(0xFF94A3B8))),
          rePostItems.isNotEmpty
              ? ListView.builder(
                  itemCount: rePostItems.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    //Article TILE
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.widthMultiplier * 4),
                          child: Row(
                            children: [
                              Container(
                                height: SizeConfig.heightMultiplier * 6,
                                width: SizeConfig.widthMultiplier * 13,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            rePostItems[index].images![0]),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              SizedBox(
                                width: SizeConfig.widthMultiplier * 2,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(
                                      () => ItemDetailsPage(
                                            article: rePostItems[index],
                                          ),
                                      transition: Transition.rightToLeft);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rePostItems[index].title ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              SizeConfig.textMultiplier * 2.6),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 0.5,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.widthMultiplier * 50,
                                      child: Text(
                                        rePostItems[index].description ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  globalCont.rePostAdid.value =
                                      rePostItems[index].articleID ?? "";
                                  Get.to(
                                      () => OrderSummaryPage(
                                            isRepost: true,
                                            numberOfPhotos: rePostItems[index]
                                                .images!
                                                .length,
                                          ),
                                      transition: Transition.leftToRight);
                                },
                                child: Container(
                                  height: SizeConfig.heightMultiplier * 5,
                                  width: SizeConfig.widthMultiplier * 20,
                                  decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                      child: Text(
                                    "Re-post",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.textMultiplier * 2),
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.widthMultiplier * 4),
                          child: Divider(
                            height: SizeConfig.heightMultiplier * 3,
                            thickness: 1.5,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    );
                  })
              : SizedBox(
                  height: SizeConfig.heightMultiplier * 60,
                  child: const NoDataWidget())
        ],
      ),
    );
  }
}
