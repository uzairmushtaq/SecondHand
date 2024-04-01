import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/fontfamilies.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/home/components/search_item_button.dart';
import 'package:secondhand/views/pages/create%20an%20ad/create_an_ad.dart';
import 'package:secondhand/views/pages/notifications/components/custom_appbar.dart';

class PublishSuccessfullyItemPage extends StatefulWidget {
  const PublishSuccessfullyItemPage({Key? key}) : super(key: key);

  @override
  State<PublishSuccessfullyItemPage> createState() =>
      _PublishSuccessfullyItemPageState();
}

class _PublishSuccessfullyItemPageState
    extends State<PublishSuccessfullyItemPage> {
  //switcher value
  bool switcherValue = false;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          body: AnimationLimiter(
              child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 100.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                      children: [
            Container(
              height: SizeConfig.heightMultiplier * 13,
              width: SizeConfig.widthMultiplier * 100,
              decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  border: Border.all(color: kLightGrey.withOpacity(0.3)),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 5,
                    left: SizeConfig.widthMultiplier * 2,
                    right: SizeConfig.widthMultiplier * 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Second",
                          style: TextStyle(
                              fontFamily: ConstantFontFamily.geckoLunch,
                              color: kPrimaryColor,
                              fontSize: SizeConfig.textMultiplier * 3.7)),
                      TextSpan(
                          text: "Hand",
                          style: TextStyle(
                              fontFamily: ConstantFontFamily.geckoLunch,
                              color: kTextColor,
                              fontSize: SizeConfig.textMultiplier * 3.7))
                    ])),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            Image.asset(
              publishItemImage,
              height: SizeConfig.heightMultiplier * 35,
            ),
            Text(
              "Your item was\npublished successfully!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 3.7,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569)),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1,
            ),
            Text(
              "We will notify you when\nyour ad is online :D",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 2.2,
                  color: const Color(0xFF475569)),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 10,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 5,
                  right: SizeConfig.widthMultiplier * 2),
              child: Row(
                children: [
                  Text(
                    "Notify me once my item expires",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.textMultiplier * 1.6,
                        color: const Color(0xFF475569)),
                  ),
                  const Spacer(),
                  Transform.scale(
                      scale: 0.75,
                      child: CupertinoSwitch(
                          value: switcherValue,
                          onChanged: (value) {
                            setState(() {
                              switcherValue = value;
                            });
                          })),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            //pay now button
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            SearchItemButton(
                title: "Publish Another Item",
                isShuffleButton: false,
                press: () {
                  Get.offAll(() => const CreateAnAdPage(),
                      transition: Transition.rightToLeft);
                },
                isSellerProfile: true),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.offAll(() => const BottomNavBar(),
                      transition: Transition.rightToLeft);
                },
                child: Text(
                  "Go Back to Dashboard",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: kSecondaryColor,
                      fontSize: SizeConfig.textMultiplier * 2.1),
                ),
              ),
            )
          ])))),
    );
  }
}
