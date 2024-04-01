import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/controllers/articles_controller.dart';
import 'package:secondhand/controllers/auth_controller.dart';

import 'package:secondhand/services/database.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/home/home.dart';
import 'package:secondhand/views/pages/notifications/components/custom_appbar.dart';
import 'package:secondhand/views/pages/payment%20details/payment_details.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand/views/pages/paypal%20webview/paypal_webview.dart';
import 'package:secondhand/views/widgets/custom_auth_snackbar.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import '../../../controllers/selected_text_controller.dart';
import 'components/payment_method_widget.dart';
import 'package:pay/pay.dart' as pay;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage(
      {Key? key, required this.subTotal, required this.isRepostAd})
      : super(key: key);
  final int subTotal;
  final bool isRepostAd;
  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ShowLoading(
          child: paymentUI(context), inAsyncCall: authCont.isLoading.value),
    );
  }

  Widget paymentUI(BuildContext context) {
    var _paymentItems = [
      pay.PaymentItem(
        label: 'Total',
        amount: (widget.subTotal / 100).toString(),
        status: pay.PaymentItemStatus.final_price,
      )
    ];

    final textData = Get.find<GlobalUIController>();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Column(
          children: [
            const NotificationsCustomAppBar(),
            Center(
              child: Image.asset(
                wellDoneImg,
                height: SizeConfig.heightMultiplier * 20,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.choose_payment_method,
              //"Choose your\npayment method :)",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.textMultiplier * 4.4,
                  color: const Color(0xFF475569)),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 5),
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 100.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    PaymentMethodsWidget(
                      title: AppLocalizations.of(context)!
                          .credit_card, //"Credit/Debit Card",
                      press: () async {
                        await makePaymentForRepostAd();
                        // Get.to(() => const PaymentDetailsPage(),
                        //     transition: Transition.leftToRight);
                      },
                      icon: Row(
                        children: [
                          Image.asset(
                            visaCard,
                            height: SizeConfig.imageSizeMultiplier * 8,
                          ),
                          SizedBox(
                            width: SizeConfig.widthMultiplier * 1,
                          ),
                          Container(
                            height: SizeConfig.heightMultiplier * 3,
                            width: SizeConfig.widthMultiplier * 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.shade100,
                              image: const DecorationImage(
                                  image: AssetImage(masterCard)),
                            ),
                          )
                        ],
                      ),
                    ),
                    PaymentMethodsWidget(
                      press: () {
                        Get.to(() => PaypalWebviewPage(
                            subTotal: widget.subTotal.toDouble() / 100,
                            onFinish: (val) {
                              widget.isRepostAd
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
                                          AppLocalizations.of(context)!
                                              .upload_successfull, // "Payment successfull",
                                          AppLocalizations.of(
                                                  Get.overlayContext!)!
                                              .successfully_posted //"Your article is successfully posted"
                                          );

                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    })
                                  : FirebaseFirestore.instance
                                      .collection("Articles")
                                      .doc(textData.articleID.value)
                                      .update({"isDraft": false}).then((value) {
                                      // Get.put(ArticlesController());
                                      Get.snackbar(
                                          AppLocalizations.of(context)!
                                              .payment_successfull, // "Payment successfull",
                                          AppLocalizations.of(
                                                  Get.overlayContext!)!
                                              .successfully_posted //"Your article is successfully posted"
                                          );

                                      Get.to(() => HomePage(),
                                          transition: Transition.leftToRight);
                                    });
                              //print("This is id : $val");
                            }));
                      },
                      title: "PayPal",
                      icon: Image.asset(
                        paypal,
                        height: SizeConfig.imageSizeMultiplier * 11,
                      ),
                    ),
                    pay.ApplePayButton(
                      paymentConfigurationAsset: 'applepay.json',
                      paymentItems: _paymentItems,
                      //style: ApplePayButtonStyle.black,
                      type: pay.ApplePayButtonType.checkout,
                      width: 200,
                      height: 50,
                      margin: const EdgeInsets.only(top: 15.0),
                      onPaymentResult: (value) {
                        //print('### !!!');
                        widget.isRepostAd
                            ? FirebaseFirestore.instance
                                .collection("Articles")
                                .doc(textData.rePostAdid.value)
                                .update({
                                "ExpiryDate": DateTime.now()
                                    .add(const Duration(days: 30))
                                    .toString()
                              }).then((value) {
                                Get.snackbar(
                                    AppLocalizations.of(context)!
                                        .payment_successfull, // "Payment successfull",
                                    AppLocalizations.of(Get.overlayContext!)!
                                        .successfully_posted //"Your article is successfully posted"
                                    );

                                Get.to(() => HomePage(),
                                    transition: Transition.leftToRight);
                              })
                            : FirebaseFirestore.instance
                                .collection("Articles")
                                .doc(textData.articleID.value)
                                .update({"isDraft": false}).then((value) {
                                Get.snackbar(
                                    AppLocalizations.of(context)!
                                        .payment_successfull, // "Payment successfull",
                                    AppLocalizations.of(Get.overlayContext!)!
                                        .successfully_posted //"Your article is successfully posted"
                                    );

                                Get.to(() => HomePage(),
                                    transition: Transition.leftToRight);
                              });
                        //print("This is id : $value");
                      },
                      onError: (error) {
                        //print('!!!');
                        //print(error);
                      },
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    /*
                    PaymentMethodsWidget(
                      press: () {
    
                      },
                      title: "Apple Pay",
                      icon: Image.asset(
                        applePay,
                        height: SizeConfig.imageSizeMultiplier * 15,
                      ),
                    )
    
                     */
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePaymentForRepostAd() async {
    try {
      paymentIntentData =
          await createPaymentIntent(widget.subTotal.toString(), "EUR");
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData!["client_secret"],
        //applePay: true,
        //googlePay: true,
        //testEnv: true,
        style: ThemeMode.dark,
        //merchantCountryCode: "DE",
        merchantDisplayName: "SecondHand",
      ));
      //print(paymentIntentData);
      displayPaymentSheet();
      //print("Pressed");
    } catch (e) {
      //print(e.toString());
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": amount,
        "currency": currency,
        "payment_method_types[]": "card"
      };
      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization":
              "Bearer sk_test_51KmjD2JvwIBAKlBVrpPuKFZbFwRbYHpYaLbEJ19hS73TKUycEtSPESib6U5xBE9zRJL7HmddlHiBzPS1lb4CEyOv00bk8tTqrn",
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      return jsonDecode(response.body.toString());
    } catch (e) {
      //print(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      final textData = Get.find<GlobalUIController>();
      await Stripe.instance
          .presentPaymentSheet(
              //parameters: PresentPaymentSheetParameters(
              //  clientSecret: paymentIntentData?["client_secret"],
              //  confirmPayment: true)
              )
          .then((value) {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
      });
      setState(() {
        paymentIntentData = null;
      });
      widget.isRepostAd
          ? FirebaseFirestore.instance
              .collection("Articles")
              .doc(textData.rePostAdid.value)
              .update({
              "ExpiryDate":
                  DateTime.now().add(const Duration(days: 30)).toString()
            }).then((value) {
              Get.snackbar(
                  AppLocalizations.of(context)!
                      .payment_successfull, // "Payment successfull",
                  AppLocalizations.of(Get.overlayContext!)!
                      .successfully_posted //"Your article is successfully posted"
                  );

              Get.to(() => HomePage(), transition: Transition.leftToRight);
            })
          : FirebaseFirestore.instance
              .collection("Articles")
              .doc(textData.articleID.value)
              .update({"isDraft": false}).then((value) {
              Get.snackbar(
                  AppLocalizations.of(context)!
                      .payment_successfull, // "Payment successfull",
                  AppLocalizations.of(Get.overlayContext!)!
                      .successfully_posted //"Your article is successfully posted"
                  );

              Get.to(() => HomePage(), transition: Transition.leftToRight);
            });

      Get.snackbar(
          AppLocalizations.of(context)!
              .payment_successfull, // "Payment successfull",
          AppLocalizations.of(Get.overlayContext!)!
              .successfully_posted //"Your article is successfully posted"
          );

      Get.to(() => HomePage(), transition: Transition.leftToRight);
    } on StripeException catch (e) {
      //print(e.toString());

      Get.snackbar(
          AppLocalizations.of(context)!
              .payment_cancelled, // "Payment Cancelled",
          AppLocalizations.of(Get.overlayContext!)!
              .article_not_posted //"Your article was not posted
          );
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
