import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/controllers/articles_controller.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/services/database.dart';
import 'package:secondhand/services/geo_locator.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/home/home.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/liked/liked.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/messages/messages.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/profile/profile.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/search/search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/push_notification_controller.dart';
import '../../../controllers/selected_text_controller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar>
    with WidgetsBindingObserver {
  final articleCont = Get.find<ArticlesController>();
  //icons for bottomnavbar
  List<String> listOfIcons = [
    homeIcon,
    searchIcon,
    shoppingCartIcon,
    messagesIcon,
    profileIcon
  ];
  //names of icons for bottomnavbar
  List<String> namesOfIcons = [];
  List<bool> show_badge = [false, false, false, true];
  bool has_new_messages2 = false;
  //list of classes which calls on currentindex
  List<Widget> classes = [
    HomePage(),
    SearchPage(),
    LikedPage(),
    MessagesPage(),
    ProfilePage(),
  ];
  final cont = Get.find<AuthController>();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Future.delayed(
          Duration.zero, () => GeoLocatorService.getCurrentLocation());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () async {
      cont.userModel.bindStream(cont.streamCurrentUser());
      articleCont.myArticles.bindStream(DataBase().streamOfMyArticles());
      await GeoLocatorService.getCurrentLocation();
      await setArticlesData();
   
      await generatingTokenForUser();
      has_new_messages = await checkForNewMessages();
    });
  }

  setArticlesData() async {
    await FirebaseFirestore.instance.collection('Articles').get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('Articles')
            .doc(element.id)
            .update({'searchKey': element.get('Title').toLowerCase()});
      });
    });
  }

  //FOR PUSH NOTIFICATIONS TOKEN
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  generatingTokenForUser() async {
    //GENERATING A TOKEN FROM FIREBASE MESSAGING
    final fcmToken = await _fcm.getToken();
    //GETTING CURRENTUSER ID
    final uid = Get.find<AuthController>().userss?.uid ?? "Null";
    //print("This is the user $uid");
    /*STORING THAT TOKEN DATA IN FIREBASE FOR EACH OFFICER
    FIELD VALUE IS THE SERVER TIME WHICH IS COMING FROM FIREBASE*/
    await FirebaseFirestore.instance.collection("GetTokens").doc(uid).set({
      "CreatedAt": FieldValue.serverTimestamp(),
      "Token": fcmToken,
      "UID": uid
    }).then((value) {
      //print("Token successfully");
    });
  }

  var has_new_messages;

  Future checkForNewMessages() async {
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where('archieve', isNotEqualTo: true)
        .where('users', arrayContains: cont.userss!.uid)
        .get()
        .then((value) {
      for (final d in value.docs) {
        FirebaseFirestore.instance
            .collection("ChatRoom")
            .doc(d.id)
            .collection("Chats")
            .where("Seen", isEqualTo: false)
            .where("SendBy", isNotEqualTo: cont.userss!.uid)
            .get()
            .then((value) {
          if (value.docs.length > 0) {
            has_new_messages2 = true;
            setState(() {});
            return true;
          }
        });
      }
    });
    setState(() {});
    has_new_messages2 = false;
    return false;
  }

  // _addBlockArray() async {
  //   await FirebaseFirestore.instance.collection('Users').get().then((value) {
  //     value.docs.forEach((element) async {
  //       await FirebaseFirestore.instance
  //           .collection('Users')
  //           .doc(element.id)
  //           .update({'BlockUsers': [],'BlockedFrom':[]});
  //     });
  //   });
  // }
  // setNewUserData() async {
  //   await FirebaseFirestore.instance.collection('Users').get().then((value) {
  //     value.docs.forEach((element) async {
  //       await FirebaseFirestore.instance
  //           .collection('Users')
  //           .doc(element.id)
  //           .update({
  //         'RatedBy': [],
  //         'Ratings': {"5": 0, "4": 0, "3": 0, "2": 0, "1": 0}
  //       }).then((value) => print(element.id));
  //     });
  //   });
  // }

  final bnbIndexCont = Get.find<GlobalUIController>();
  @override
  Widget build(BuildContext context) {
    namesOfIcons = [
      AppLocalizations.of(context)!.home,
      AppLocalizations.of(context)!.search,
      AppLocalizations.of(context)!.liked_items,
      AppLocalizations.of(context)!.messages,
      //AppLocalizations.of(context)!.my_profile
    ];

    return Obx(
      () => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            extendBody: true,
            body: classes.elementAt(bnbIndexCont.bnbSelectedIndex.value),
            bottomNavigationBar: Container(
              height: SizeConfig.heightMultiplier * 9,
              width: SizeConfig.widthMultiplier * 100,
              decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  border: Border.all(color: kLightGrey.withOpacity(0.3)),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: Get.width * .015),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    has_new_messages = checkForNewMessages();
                    bnbIndexCont.bnbSelectedIndex.value = index;
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: SizedBox(
                    width: SizeConfig.widthMultiplier * 25,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.widthMultiplier * 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            margin: EdgeInsets.only(
                              bottom:
                                  index == bnbIndexCont.bnbSelectedIndex.value
                                      ? 0
                                      : Get.width * .029,
                              right: Get.width * .0422,
                              left: Get.width * .0422,
                            ),
                            width: Get.width * .11,
                            height: index == bnbIndexCont.bnbSelectedIndex.value
                                ? Get.width * .014
                                : 0,
                            decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                            ),
                          ),
                          Stack(children: <Widget>[
                            Image.asset(listOfIcons[index],
                                color:
                                    bnbIndexCont.bnbSelectedIndex.value == index
                                        ? kPrimaryColor
                                        : const Color(0xFF475569),
                                height: SizeConfig.heightMultiplier * 3.8),
                            (show_badge[index])
                                ? (has_new_messages2)
                                    ? Positioned(
                                        // draw a red marble
                                        top: 0.0,
                                        right: 0.0,
                                        child: new Icon(Icons.brightness_1,
                                            size: 15.0, color: Colors.red),
                                      )
                                    : SizedBox()
                                : SizedBox(),
                          ]),
                          Center(
                            child: Text(
                              namesOfIcons[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 1.3,
                                  color: bnbIndexCont.bnbSelectedIndex.value ==
                                          index
                                      ? kPrimaryColor
                                      : const Color(0xFF475569)),
                            ),
                          ),
                          SizedBox(height: Get.width * .005),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
