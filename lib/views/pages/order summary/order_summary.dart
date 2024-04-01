import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/controllers/articles_controller.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/home/components/search_item_button.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/home/home.dart';
import 'package:secondhand/views/pages/notifications/components/custom_appbar.dart';
import 'package:secondhand/views/pages/payment%20method/payment_method.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage(
      {Key? key, required this.numberOfPhotos, required this.isRepost})
      : super(key: key);
  final int numberOfPhotos;
  final bool isRepost;

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final priceCont = Get.find<GlobalUIController>();
  final textData = Get.find<GlobalUIController>();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NotificationsCustomAppBar(),
            Center(
              child: Image.asset(
                wellDoneImg,
                height: SizeConfig.heightMultiplier * 20,
              ),
            ),
            Center(
              child: Text(
                AppLocalizations.of(context)!.order_summary,
                //"Order Summary",
                style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 4,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 3,
            ),
            Center(
              child: Container(
                width: SizeConfig.widthMultiplier * 90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(6, 12))
                    ]),
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.heightMultiplier * 4,
                    horizontal: SizeConfig.widthMultiplier * 5),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeConfig.heightMultiplier * 2),
                      child: Row(
                        children: [
                          Text(
                            "${widget.numberOfPhotos} " + AppLocalizations.of(context)!.photo,
                            style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                          const Spacer(),
                          Text(
                            (priceCont.pricePerPhoto.value * widget.numberOfPhotos).toStringAsFixed(2) + " €",
                            style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: SizeConfig.textMultiplier * 2),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1,
                    ),
                    Divider(
                      color: Colors.grey.shade200,
                      thickness: 1.5,
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1,
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.subtotal,
                          style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 2.5),
                        ),
                        const Spacer(),
                        Text(
                          (priceCont.pricePerPhoto.value * widget.numberOfPhotos).toStringAsFixed(2) + " €",
                          style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: SizeConfig.textMultiplier * 2),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 6,
            ),
            (priceCont.pricePerPhoto.value > 0) ?
            SearchItemButton(
                title: AppLocalizations.of(context)!.pay_now, //"Pay Now",
                isShuffleButton: false,
                press: () {
                  double currentPrice =
                      priceCont.pricePerPhoto.value * widget.numberOfPhotos;
                  Get.to(
                      () => PaymentMethodPage(
                          isRepostAd: widget.isRepost,
                          subTotal: (currentPrice*100).toInt()),
                      transition: Transition.leftToRight);
                },
                isSellerProfile: true) : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Center(child: Text(AppLocalizations.of(context)!.no_costs_for_article)),
                SizedBox(height: 20),
                SearchItemButton(
                    title: AppLocalizations.of(context)!.upload_now, //"Pay Now",
                    isShuffleButton: false,
                    press: () {
                      widget.isRepost
                          ? FirebaseFirestore.instance
                          .collection("Articles")
                          .doc(textData.rePostAdid.value)
                          .update({
                            "ExpiryDate": DateTime.now()
                            .add(const Duration(days: 30))
                            .toString()
                      }).then((value) {
                        // Get.put(ArticlesController());
                        Get.snackbar(
                            AppLocalizations.of(context)!.upload_successfull,// "Payment successfull",
                            AppLocalizations.of(Get.overlayContext!)!.successfully_posted //"Your article is successfully posted"
                        );
    
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      })
                          : FirebaseFirestore.instance
                          .collection("Articles")
                          .doc(textData.articleID.value)
                          .update({"isDraft": false}).then((value) {
                        // Get.put(ArticlesController());
                        Get.snackbar(
                            AppLocalizations.of(context)!.upload_successfull,// "Payment successfull",
                            AppLocalizations.of(Get.overlayContext!)!.successfully_posted //"Your article is successfully posted"
                        );
    
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      });
                    },
                    isSellerProfile: true)
            ],),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                    AppLocalizations.of(context)!.go_back,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: kSecondaryColor,
                      fontSize: SizeConfig.textMultiplier * 2.1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
