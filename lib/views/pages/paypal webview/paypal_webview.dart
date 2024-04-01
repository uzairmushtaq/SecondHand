import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/services/paypal_service.dart';
import 'package:secondhand/views/widgets/custom_appbar.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalWebviewPage extends StatefulWidget {
  final Function onFinish;
  const PaypalWebviewPage(
      {Key? key, required this.onFinish, required this.subTotal})
      : super(key: key);
  final double subTotal;
  @override
  State<PaypalWebviewPage> createState() => _PaypalWebviewPageState();
}

class _PaypalWebviewPageState extends State<PaypalWebviewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var checkOutURL;
  var executeURL;
  String? accessToken;
  PaypalServices payPalServices = PaypalServices();
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "EUR ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "EUR"
  };
  bool isEnableShipping = false;
  bool isEnableAddress = false;
  String returnURL = "return.example.com";
  String cancelURl = "cancel.example.com";
  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": "Post item",
        "quantity": "1",
        "price": widget.subTotal.toString(),
        "currency": "EUR"
      }
    ];

    // checkout invoice details
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'First';
    String userLastName = 'Last';
    String addressCity = 'City';
    String addressStreet = 'Street';
    String addressZipCode = '110014';
    String addressCountry = 'Country';
    String addressState = 'State';
    String addressPhoneNumber = '+00000000000';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": widget.subTotal.toString(),
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": widget.subTotal.toString(),
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURl}
    };
    return temp;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await payPalServices.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await payPalServices.createPayment(transactions, accessToken);
        if (res.isNotEmpty) {
          setState(() {
            checkOutURL = res["approvalUrl"];
            executeURL = res["executeUrl"];
          });
        }
      } catch (e) {
        //print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 30000),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
              Navigator.pop(context);
            },
          ),
        );
        // ignore: deprecated_member_use
        //_scaffoldKey.currentState?.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(checkOutURL);

    return Scaffold(
      body: Column(
        children: [
          const CustomAppbar(isProfileIcon: false),
          checkOutURL != null
              ? Expanded(
                  child: WebView(
                    initialUrl: checkOutURL,
                    javascriptMode: JavascriptMode.unrestricted,
                    navigationDelegate: (NavigationRequest request) {
                      if (request.url.contains(returnURL)) {
                        final uri = Uri.parse(request.url);
                        final payerID = uri.queryParameters['PayerID'];
                        if (payerID != null) {
                          payPalServices
                              .executePayment(executeURL, payerID, accessToken)
                              .then((id) {
                            widget.onFinish(id);
                            Navigator.of(context).pop();
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
                        Navigator.of(context).pop();
                      }
                      if (request.url.contains(cancelURl)) {
                        Navigator.of(context).pop();
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
              : const Expanded(child: Loading()),
        ],
      ),
    );
  }
}
