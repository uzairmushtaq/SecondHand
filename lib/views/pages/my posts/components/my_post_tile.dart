import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/views/pages/order%20summary/order_summary.dart';
import '../../../../models/article_model.dart';
import '../../../../utils/size_config.dart';
import '../../../bottom sheets/my_post_bs.dart';
import '../../item details/items_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MYPostTile extends StatelessWidget {
  const MYPostTile({
    Key? key,
    required this.index,
    required this.article,
  }) : super(key: key);
  final int index;
  final List<ArticleModel> article;
  @override
  Widget build(BuildContext context) {
    final globalCont = Get.find<GlobalUIController>();
    final Color colorOfTag;
    final String expiryDate;
    final date = DateTime.now();
    final comingDate = DateTime.parse(article[index].expiryDate ?? "");
    final dateInMilliseconds = date.millisecondsSinceEpoch;
    final comingDateMilliseconds = comingDate.millisecondsSinceEpoch;
    if (comingDateMilliseconds > dateInMilliseconds) {
      expiryDate = AppLocalizations.of(context)!.expires_in +
          " ${date.difference(comingDate).inDays.toString().split("-")[1]} " +
          AppLocalizations.of(context)!.days;
      colorOfTag = const Color(0xFF10B981);
    } else {
      expiryDate = AppLocalizations.of(context)!.expired;
      colorOfTag = Colors.grey.shade200;
    }
    //print(expiryDate);
    return InkWell(
      onTap: () {
        Get.to(
            () => ItemDetailsPage(
                  article: article[index],
                ),
            transition: Transition.rightToLeft);
      },
      child: Column(
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
                        image: NetworkImage(article[index].images![0]),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(12)),
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article[index].title ??
                        AppLocalizations.of(context)!.loading,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.textMultiplier * 2.6),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 0.5,
                  ),
                  //active widget
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: colorOfTag,
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.heightMultiplier * 0.5,
                            horizontal: SizeConfig.widthMultiplier * 2),
                        child: Text(
                          colorOfTag == const Color(0xFF10B981)
                              ? AppLocalizations.of(context)!.active
                              : AppLocalizations.of(context)!.inactive,
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.6,
                              color: colorOfTag == const Color(0xFF10B981)
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 2,
                      ),
                      Text(
                        expiryDate,
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 1.6,
                            color: const Color(0xFF94A3B8)),
                      )
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
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        context: context,
                        builder: (_) => MyPostBottomSheet(
                              onDelete: () async {
                                await FirebaseFirestore.instance
                                    .collection("Articles")
                                    .doc(article[index].articleID)
                                    .delete()
                                    .then((value) {
                                  Get.back();
                                });
                              },
                              onPublish: () {
                                globalCont.rePostAdid.value =
                                    article[index].articleID ?? "";
                                Get.to(() => OrderSummaryPage(
                                    numberOfPhotos:
                                        article[index].images!.length,
                                    isRepost: true));
                              },
                            ));
                  },
                  child: const Icon(Icons.more_horiz))
            ],
          ),
          index == article.length - 1
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.heightMultiplier * 1),
                  child: Divider(
                    thickness: 1.5,
                    color: Colors.grey.shade200,
                  ),
                )
        ],
      ),
    );
  }
}
