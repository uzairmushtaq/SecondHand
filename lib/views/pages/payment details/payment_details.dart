// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get.dart';
// import 'package:secondhand/constants/colors.dart';
// import 'package:secondhand/utils/size_config.dart';
// import 'package:secondhand/views/pages/bottom%20nav%20bar/home/components/search_item_button.dart';
// import 'package:secondhand/views/pages/notifications/components/custom_appbar.dart';
// import 'package:secondhand/views/pages/published%20successfully/publish_succesfully.dart';

// import 'components/textfield.dart';

// class PaymentDetailsPage extends StatefulWidget {
//   const PaymentDetailsPage({Key? key}) : super(key: key);

//   @override
//   State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
// }

// class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
//   TextEditingController nameOnCard = TextEditingController();
//   TextEditingController cardNumber = TextEditingController();
//   TextEditingController expiry = TextEditingController();
//   TextEditingController cvv = TextEditingController();
//   TextEditingController streetDetails = TextEditingController();
//   TextEditingController city = TextEditingController();
//   TextEditingController province = TextEditingController();
//   TextEditingController zipCode = TextEditingController();
//   //switcher value
//   bool switcherValue = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(
//             parent: AlwaysScrollableScrollPhysics()),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const NotificationsCustomAppBar(),
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 4,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: SizeConfig.widthMultiplier * 5),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Payment Details",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: SizeConfig.textMultiplier * 4.4,
//                         color: const Color(0xFF475569)),
//                   ),
//                   SizedBox(
//                     height: SizeConfig.heightMultiplier * 2,
//                   ),
//                   Row(children: [
//                     Text(
//                       "Payment amount",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: SizeConfig.textMultiplier * 2.5,
//                           color: const Color(0xFF64748B)),
//                     ),
//                     const Spacer(),
//                     Text(
//                       "\$1.50",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: SizeConfig.textMultiplier * 2.5,
//                           color: const Color(0xFF64748B)),
//                     )
//                   ]),
//                   Divider(
//                     height: SizeConfig.heightMultiplier * 6,
//                     thickness: 2,
//                     color: Colors.grey.shade200,
//                   ),
//                   Text(
//                     "Card details",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: SizeConfig.textMultiplier * 2.5,
//                         color: const Color(0xFF64748B)),
//                   ),
//                   SizedBox(
//                     height: SizeConfig.heightMultiplier * 1.5,
//                   ),
//                   PaymentDetailsTextField(
//                     hintText: "Name on card",
//                     width: SizeConfig.widthMultiplier * 100,
//                     controller: nameOnCard,
//                     keyboardType: TextInputType.text,
//                   ),
//                   PaymentDetailsTextField(
//                     hintText: "Card Number",
//                     width: SizeConfig.widthMultiplier * 100,
//                     controller: cardNumber,
//                     keyboardType: TextInputType.number,
//                   ),
//                   Row(
//                     children: [
//                       PaymentDetailsTextField(
//                         hintText: " Expiry",
//                         width: SizeConfig.widthMultiplier * 25,
//                         controller: cardNumber,
//                         keyboardType: TextInputType.datetime,
//                       ),
//                       SizedBox(
//                         width: SizeConfig.widthMultiplier * 3,
//                       ),
//                       PaymentDetailsTextField(
//                         hintText: "   CVV",
//                         width: SizeConfig.widthMultiplier * 25,
//                         controller: cardNumber,
//                         keyboardType: TextInputType.number,
//                       )
//                     ],
//                   ),
//                   Divider(
//                     height: SizeConfig.heightMultiplier * 5,
//                     thickness: 2,
//                     color: Colors.grey.shade200,
//                   ),
//                   Row(
//                     children: [
//                       Transform.scale(
//                           scale: 0.75,
//                           child: CupertinoSwitch(
//                               value: switcherValue,
//                               onChanged: (value) {
//                                 setState(() {
//                                   switcherValue = value;
//                                 });
//                               })),
//                       SizedBox(
//                         width: SizeConfig.widthMultiplier * 4,
//                       ),
//                       switcherValue
//                           ? const SizedBox()
//                           : Text(
//                               "I would like to get the receipt",
//                               style: TextStyle(
//                                   color: const Color(0xFF64748B),
//                                   fontSize: SizeConfig.textMultiplier * 2,
//                                   fontWeight: FontWeight.w600),
//                             )
//                     ],
//                   ),
//                   SizedBox(
//                     height: SizeConfig.heightMultiplier * 2,
//                   ),
//                   //if switch to get reciept
//                   switcherValue
//                       ? AnimationLimiter(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: AnimationConfiguration.toStaggeredList(
//                               duration: const Duration(milliseconds: 375),
//                               childAnimationBuilder: (widget) => SlideAnimation(
//                                 verticalOffset: 100.0,
//                                 child: FadeInAnimation(
//                                   child: widget,
//                                 ),
//                               ),
//                               children: [
//                                 Text(
//                                   "Billing address",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: SizeConfig.textMultiplier * 2.5,
//                                       color: const Color(0xFF64748B)),
//                                 ),
//                                 SizedBox(
//                                   height: SizeConfig.heightMultiplier * 1.5,
//                                 ),
//                                 PaymentDetailsTextField(
//                                   hintText: "Street, street number",
//                                   width: SizeConfig.widthMultiplier * 100,
//                                   controller: streetDetails,
//                                   keyboardType: TextInputType.text,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     PaymentDetailsTextField(
//                                       hintText: "City",
//                                       width: SizeConfig.widthMultiplier * 44,
//                                       controller: city,
//                                       keyboardType: TextInputType.text,
//                                     ),
//                                     PaymentDetailsTextField(
//                                       hintText: "State/Province",
//                                       width: SizeConfig.widthMultiplier * 44,
//                                       controller: province,
//                                       keyboardType: TextInputType.text,
//                                     ),
//                                   ],
//                                 ),
//                                 PaymentDetailsTextField(
//                                   hintText: "Zip code",
//                                   width: SizeConfig.widthMultiplier * 44,
//                                   controller: streetDetails,
//                                   keyboardType: TextInputType.number,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//                   //pay now button
//                   SizedBox(
//                     height: SizeConfig.heightMultiplier * 2,
//                   ),
//                   SearchItemButton(
//                       title: "Pay Now \$1.50",
//                       isShuffleButton: false,
//                       press: () {
//                         Get.to(() => const PublishSuccessfullyItemPage(),
//                           transition: Transition.leftToRight);
//                       },
//                       isSellerProfile: true),
//                   Center(
//                     child: TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Go Back",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: kSecondaryColor,
//                             fontSize: SizeConfig.textMultiplier * 2.1),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
