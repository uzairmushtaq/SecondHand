import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/utils/dynamic_links.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/image%20viewer/image_viewer.dart';
import 'package:secondhand/views/widgets/custom_auth_snackbar.dart';
import 'package:secondhand/views/widgets/custom_small_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:websafe_svg/websafe_svg.dart';
import '../../../controllers/articles_controller.dart';
import '../../../controllers/auth_controller.dart';

import '../../../models/article_model.dart';
import '../../../services/database.dart';
import '../../widgets/show_loading.dart';
import '../chat page/chat_page.dart';
import 'components/profile_info.dart';
import 'components/tag_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({Key? key, required this.article}) : super(key: key);
  final ArticleModel article;
  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  final authCont = Get.find<AuthController>();
  DocumentSnapshot? userData;
  //for chat section
  creatingChatRoom(String otherusername, String otherUserId) async {
    if (authCont.userss!.uid != widget.article.userID) {
      String chatRoomID = getChatRoomID(
          authCont.userInfo?.id ?? "", widget.article.articleID ?? "");
      ////print(chatRoomID);
      List<String> users = [
        widget.article.userID ?? "",
        Get.find<AuthController>().userInfo?.id ?? ""
      ];
      ////print(users);
      Map<String, dynamic> chatRoomMap = {
        'users': [otherUserId, authCont.userss!.uid],
        "chatRoomID": chatRoomID,
        "ArticleID": widget.article.articleID,
        "ArticleOwnerID": widget.article.userID,
        "ArticleImages": widget.article.images,
        "ArticleName": widget.article.title,
        "archievedBy": [],
        'DeletedBy': [],
        'LatestMsgTime': FieldValue.serverTimestamp(),
        'userData': [
          {
            'username': otherusername,
            'id': otherUserId,
            'msgData': {
              'LatestMsgSeenBy': [authCont.userss!.uid],
              'LatestMsgSendBy': authCont.userInfo?.id,
              'LatestMsg': 'No messages yet!'
            }
          },
          {
            'username': authCont.userInfo?.fullName,
            'id': authCont.userss!.uid,
            'msgData': {
              'LatestMsgSeenBy': [authCont.userss!.uid],
              'LatestMsgSendBy': authCont.userInfo?.id,
              'LatestMsg': 'No messages yet!'
            }
          }
        ],
      };
      DataBase().createChatRoom(chatRoomID, chatRoomMap);
      Get.to(
          () => ChatPage(
                articleID: widget.article.articleID!,
                articleImages: widget.article.images ?? [],
                articleName: widget.article.title ?? "",
                otherUserName: otherusername,
                chatRoomID: chatRoomID,
                currentUserID: authCont.userss!.uid,
                otherUserID: otherUserId,
              ),
          transition: Transition.leftToRight);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          padding: EdgeInsets.all(0),
          backgroundColor: Color(0xFFa6a6a6),
          content: CustomAuthSnackBar(
              title: "Error", subTitle: "You cannot chat with yourself")));
    }
  }

  getChatRoomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String? ownerPhotoURL;
  String? myName, myEmail;
  String? currentUserID;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final userName = authCont.userInfo?.fullName;
      myName = userName != "N/A" || userName != '' || userName != null
          ? authCont.userInfo?.fullName
          : authCont.userss?.email?.split("@")[0];
      myEmail = authCont.userInfo?.email?.split("@")[0];

      currentUserID = authCont.userInfo?.id;
      //print('HELLO ${widget.article.userID}');
      if (widget.article.userID != '') {
        userData = await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.article.userID)
            .get();
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ShowLoading(
        child: itemDetailsUI(context),
        inAsyncCall: authCont.isLoading.value,
      ),
    );
  }

  Widget itemDetailsUI(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: const Color(0xFFa6a6a6),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 6,
                ),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: WebsafeSvg.asset(cancelIcon, color: Colors.white)),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 3,
                ),
                Text(
                    AppLocalizations.of(context)!.posted +
                        " ${timeago.format(DateTime.parse(widget.article.postedOn ?? ""), locale: myLocale.languageCode)}",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.6,
                        color: klightGreyText)),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1.5,
                ),
                //products images widget
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Row(
                    children: [
                      ...List.generate(
                          widget.article.images!.length,
                          (i) => InkWell(
                                onTap: () {
                                  Get.to(() => ImageViewer(
                                      imageLink: widget.article.images![i]));
                                },
                                child: Hero(
                                  tag: widget.article.images![i],
                                  child: Container(
                                    height: SizeConfig.heightMultiplier * 18,
                                    width: SizeConfig.widthMultiplier * 40,
                                    margin: EdgeInsets.only(
                                        right: SizeConfig.widthMultiplier * 2),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 6)
                                        ]),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        placeholder: (_, s) =>
                                            CircularProgressIndicator(
                                                strokeWidth: 1.5,
                                                color: kPrimaryColor),
                                        imageUrl:
                                            widget.article.images![i] ?? "",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 3,
                ),
                //price and title widget
                Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 45,
                      child: Text(
                        widget.article.title ?? "",
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 3,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.heightMultiplier * 0.5,
                          horizontal: SizeConfig.widthMultiplier * 2),
                      decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(40)),
                      child: Text(
                        "${double.parse(widget.article.price!).toStringAsFixed(2)} ${widget.article.currency}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2.1),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 5,
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WebsafeSvg.asset(passEyeIcon, color: Colors.white),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 2,
                    ),
                    Text(
                      widget.article.views!.length.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 2.1),
                    ),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 5,
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1,
                ),
                //description
                SizedBox(
                  width: SizeConfig.widthMultiplier * 90,
                  child: Text(
                    widget.article.description ?? "",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.7,
                        color: klightGreyText),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                //location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.white),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 2,
                    ),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 85,
                      child: Text(
                        widget.article.location ?? "",
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 1.7,
                            color: klightGreyText),
                      ),
                    )
                  ],
                ),
                //tags
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 75,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            ...List.generate(
                              widget.article.categories!.length,
                              (i) => TagWidget(
                                title: widget.article.categories![i],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 20.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(100)),
                        child: InkWell(
                            onTap: () {
                              DynamicLinkHelperClass dynamicLinkHelper =
                                  DynamicLinkHelperClass();
                              dynamicLinkHelper
                                  .createDynamicLink(widget.article.articleID!)
                                  .then((value) {
                                dynamicLinkHelper.shareData(context,
                                    'SecondHand: $value', 'SecondHand: $value');
                              });
                            },
                            child: Icon(
                              Icons.ios_share,
                              color: Colors.white,
                            )))
                  ],
                ),
                //profile info widget
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                userData == null
                    ? SizedBox(
                        height: SizeConfig.heightMultiplier * 15,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: kPrimaryColor,
                          ),
                        ),
                      )
                    : FadeIn(
                        child: ProfileInfoWidget(
                          userData: userData!,
                          onCall: () {
                            // final _phone = userData!.get('Phone') ?? '';
                            // _makePhoneCall("tel:$_phone");
                          },
                          onMessage: () async {},
                        ),
                      ),

                //go back and like buttons
                Row(
                  children: [
                    CustomSmallButton(
                        title: AppLocalizations.of(context)!.contact_seller,
                        color: kSecondaryColor,
                        press: () {
                          ownerPhotoURL = userData!.get("ProfilePic");
                          creatingChatRoom(
                              userData!.get("Fullname") ?? "", userData!.id);
                        }),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 2,
                    ),
                    GetX<ArticlesController>(
                        init: ArticlesController(),
                        builder: (ArticlesController snapshot) {
                          return CustomSmallButton(
                            title: widget.article.likedBy!
                                    .contains(authCont.userss!.uid)
                                ? AppLocalizations.of(context)!.unlike
                                : AppLocalizations.of(context)!.like,
                            color: kPrimaryColor,
                            press: () async {
                              if (!widget.article.likedBy!
                                  .contains(authCont.userss!.uid)) {
                                widget.article.likedBy!
                                    .add(authCont.userss!.uid);
                              } else {
                                widget.article.likedBy!
                                    .remove(authCont.userss!.uid);
                              }
                              setState(() {});
                              if (!widget.article.likedBy!
                                  .contains(authCont.userss!.uid)) {
                                await FirebaseFirestore.instance
                                    .collection("Articles")
                                    .doc(widget.article.articleID)
                                    .update({
                                  "LikedBy": widget.article.likedBy!,
                                });
                              } else {
                                await FirebaseFirestore.instance
                                    .collection("Articles")
                                    .doc(widget.article.articleID)
                                    .update({
                                  "LikedBy": widget.article.likedBy!,
                                });
                              }
                            },
                          );
                        })
                  ],
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
