import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/controllers/selected_text_controller.dart';
import 'package:secondhand/controllers/your_mode_controller.dart';
import 'package:secondhand/enums/articles_type.dart';
import 'package:secondhand/services/geo_locator.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/create%20an%20ad/create_an_ad.dart';
import 'package:secondhand/views/pages/articles/articles.dart';
import 'package:secondhand/views/pages/my%20drafts/my_drafts.dart';
import 'package:secondhand/views/pages/my%20posts/my_posts.dart';
import 'package:secondhand/views/pages/search_filter/search_filter.dart';
import 'package:secondhand/views/widgets/custom_appbar.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../bottom sheets/re_post_ad_bs.dart';
import 'components/recent_searches_widget.dart';
import 'components/search_item_button.dart';
import 'components/your_mode_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>   {
  final cont = Get.find<AuthController>();
  final yourModeCont = Get.find<YourModeController>();

  @override
  void initState() {
    super.initState();
   
    Future.delayed(Duration.zero, () {
      
     
      getPrice();
    });
  }

//for getting price from the firebase
  Future<void> getPrice() async {
    await FirebaseFirestore.instance
        .collection("PricePerPicture")
        .doc("ePAoFPpEIH2Q1VMrWqs9")
        .get()
        .then((value) {
      Get.find<GlobalUIController>().pricePerPhoto.value =
          value["Price"].toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    return Obx(
      () => MediaQuery(
         data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const CustomAppbar(
                isProfileIcon: true,
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 1.7,
              ),
              AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 150.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      (myLocale.languageCode == 'en')
                          ? Center(
                              child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.widthMultiplier * 4),
                              child: Image.asset(
                                postYouritemsAD,
                              ),
                            ))
                          : SizedBox(),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 1,
                      ),
                      //your mode
                      Padding(
                        padding:
                            EdgeInsets.only(left: SizeConfig.widthMultiplier * 6),
                        child: Text(
                          AppLocalizations.of(context)!.your_mode,
                          //"Your mode",
                          style: TextStyle(
                              color: const Color(0xff475569),
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2.5,
              ),
              AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      //mode select widget
                      YourModeWidget(type: 'home'),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2.5,
                      ),
                      yourModeCont.yourModeIndex.value > 0
                          ? SearchItemButton(
                              title: yourModeCont.yourModeIndex.value == 1
                                  ? AppLocalizations.of(context)!
                                      .search_items // "Search items"
                                  : AppLocalizations.of(context)!
                                      .create_ad, //"Create an ad",
                              press: () {
                                yourModeCont.yourModeIndex.value == 1
                                    ? Get.to(() => const SearchFilterPage(),
                                        transition: Transition.leftToRight)
                                    : Get.to(() => const CreateAnAdPage(),
                                        transition: Transition.leftToRight);
                              },
                              isSellerProfile:
                                  yourModeCont.yourModeIndex.value == 1
                                      ? false
                                      : true,
                              isShuffleButton: false,
                            )
                          : SizedBox(),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      yourModeCont.yourModeIndex.value > 0
                          ? SearchItemButton(
                              title: yourModeCont.yourModeIndex.value == 1
                                  ? AppLocalizations.of(context)!
                                      .shuffle //"Shuffle"
                                  : AppLocalizations.of(context)!
                                      .repost_old_add, //"Re-post old ad",
                              press: () {
                                yourModeCont.yourModeIndex.value == 1
                                    ?
                                    Get.to(
                                        () => ArticlesPage(
                                          shuffleType: ShuffleType.shuffled,
                                            language: myLocale.languageCode),
                                        transition: Transition.leftToRight):
                                  
                                     showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        builder: (context) =>
                                            const RePostOldAdsBottomSheet());
                              },
                              isShuffleButton:
                                  yourModeCont.yourModeIndex.value == 1
                                      ? true
                                      : false,
                              isSellerProfile:
                                  yourModeCont.yourModeIndex.value == 2
                                      ? true
                                      : false,
                            )
                          : SizedBox(),
                      //LIKED ITEMS BUTTON
                      yourModeCont.yourModeIndex.value == 1
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.heightMultiplier * 2),
                              child: SearchItemButton(
                                  title:
                                      AppLocalizations.of(context)!.liked_items,
                                  isShuffleButton: false,
                                  press: () {
                                    Get.to(
                                        () => ArticlesPage(
                                          shuffleType: ShuffleType.liked,
                                            language: myLocale.languageCode),
                                        transition: Transition.leftToRight);
                                  },
                                  isSellerProfile: false),
                            )
                          : SizedBox(),
                      // MY POSTS BUTTON
                      yourModeCont.yourModeIndex.value == 2
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.heightMultiplier * 2),
                              child: SearchItemButton(
                                  title: AppLocalizations.of(context)!.my_posts,
                                  isShuffleButton: false,
                                  press: () {
                                    Get.to(() => MyPostsPage(),
                                        transition: Transition.leftToRight);
                                  },
                                  isSellerProfile: true),
                            )
                          : SizedBox(),
                      //MY DRAFTS OPTION
                      yourModeCont.yourModeIndex.value == 2
                          ? SearchItemButton(
                              title: AppLocalizations.of(context)!.my_drafts,
                              isShuffleButton: false,
                              press: () {
                                Get.to(
                                    () => MyDraftsPage(
                                          uid: Get.find<AuthController>()
                                              .userss!
                                              .uid,
                                        ),
                                    transition: Transition.leftToRight);
                              },
                              isSellerProfile: true)
                          : SizedBox()
                    ],
                  ),
                ),
              ),
              yourModeCont.yourModeIndex.value == 10
                  ? AnimationLimiter(
                      child: RecentSearchesWidget(
                      uid: cont.userInfo?.id ?? "",
                    ))
                  : SizedBox(),
              SizedBox(
                height: SizeConfig.heightMultiplier * 10,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
