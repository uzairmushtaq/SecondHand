// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_image_viewer/easy_image_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:secondhand/constants/colors.dart';
// import 'package:secondhand/constants/icons.dart';
// import 'package:secondhand/controllers/all_user_controller.dart';
// import 'package:secondhand/utils/size_config.dart';
// import 'package:secondhand/views/widgets/custom_auth_snackbar.dart';
// import 'package:secondhand/views/widgets/custom_small_button.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:websafe_svg/websafe_svg.dart';
// import '../../../controllers/articles_controller.dart';
// import '../../../controllers/auth_controller.dart';
// 
// import '../../../models/article_model.dart';
// import '../../../services/database.dart';
// import '../../widgets/show_loading.dart';
// import '../chat page/chat_page.dart';
// import 'components/profile_info.dart';
// import 'components/tag_widget.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class ItemDetailsPage extends StatefulWidget {
//   const ItemDetailsPage({Key? key, required this.article, required this.index})
//       : super(key: key);
//   final List<ArticleModel> article;
//   final int index;

//   @override
//   State<ItemDetailsPage> createState() => _ItemDetailsPageState();
// }

// class _ItemDetailsPageState extends State<ItemDetailsPage> {
//   //for chat section
//   creatingChatRoom(String username, String otherUserId) async {
//     if (cont.userss!.uid != widget.article[widget.index].userID) {
//       //print("This is my Name : $myName");
//       String chatRoomID = getChatRoomID(
//           cont.userInfo?.id ?? "", widget.article[widget.index].articleID ?? "");
//       //print(chatRoomID);
//       List<String> users = [
//         widget.article[widget.index].userID ?? "",
//         Get.find<AuthController>().userInfo?.id ?? ""
//       ];
//       //print(users);
//       Map<String, dynamic> chatRoomMap = {
//         "users": users,
//         "chatRoomID": chatRoomID,
//         "ArticleID": widget.article[widget.index].articleID,
//         "ArticleOwnerID": widget.article[widget.index].userID,
//         "ArticleImages": widget.article[widget.index].images,
//         "ArticleName": widget.article[widget.index].title,
//         "archieve": false,
//       };
//       DataBase().createChatRoom(chatRoomID, chatRoomMap);
//       FirebaseFirestore.instance
//           .collection("Users")
//           .doc(widget.article[widget.index].userID)
//           .collection("Notifications")
//           .add({
//         "Title": "$myName sent you a message",
//         "Date": DateTime.now().toString(),
//         "ArticleID": widget.article[widget.index].articleID,
//         "ChatRoomID": chatRoomID,
//         "OtherUserImg": Get.find<AuthController>().userInfo?.profilePic,
//         "OtherUserName": Get.find<AuthController>().userInfo?.fullName,
//         "OwnerID": widget.article[widget.index].userID,
//         "buyerID": Get.find<AuthController>().userInfo?.id,
//       });

//       FirebaseFirestore.instance
//           .collection("Users")
//           .doc(Get.find<AuthController>().userInfo?.id)
//           .collection("Notifications")
//           .add({
//         "Title": "Check response of $username",
//         "Date": DateTime.now().toString(),
//         "ArticleID": widget.article[widget.index].articleID,
//         "ChatRoomID": chatRoomID,
//         "OtherUserImg": ownerPhotoURL,
//         "OtherUserName": username,
//         "OwnerID": widget.article[widget.index].userID,
//         "buyerID": Get.find<AuthController>().userInfo?.id,
//       });

//       Get.to(
//           () => ChatPage(
//             //  ownerName: username,
//                 articleImages: widget.article[widget.index].images ?? [],
//                 articleName: widget.article[widget.index].title ?? "",
//                 otherUserName: username,
//                 chatRoomID: chatRoomID,
//                 myName: Get.find<AuthController>().userInfo?.id ?? "",
//                 otherUserID: otherUserId,
//               ),
//           transition: Transition.leftToRight);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           padding: EdgeInsets.all(0),
//           backgroundColor: Color(0xFFa6a6a6),
//           content: CustomAuthSnackBar(
//               title: "Error", subTitle: "You cannot chat with yourself")));
//     }
//   }

//   getChatRoomID(String a, String b) {
//     if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
//       return "$b\_$a";
//     } else {
//       return "$a\_$b";
//     }
//   }

//   Future<void> _makePhoneCall(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   final cont = Get.find<AuthController>();
//   String? ownerPhotoURL;
//   String? myName, myEmail;
//   String? currentUserID;
//   @override
//   void initState() {
  
//     myName = cont.userInfo.fullName != "N/A"
//         ? cont.userInfo.fullName
//         : cont.userInfo.email?.split("@")[0];
//     myEmail = cont.userInfo.email?.split("@")[0];

//     currentUserID = cont.userInfo.id;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetX<authController>(
//         init: authController(),
//         builder: (authController load) {
//           return ShowLoading(
//             child: itemDetailsUI(context),
//             inAsyncCall: load.isLoading.value,
//           );
//         });
//   }

//   Widget itemDetailsUI(BuildContext context) {
//     Locale myLocale = Localizations.localeOf(context);
//     return Scaffold(
//       backgroundColor: const Color(0xFFa6a6a6),
//       body: Padding(
//         padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 5),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 6,
//             ),
//             InkWell(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: WebsafeSvg.asset(cancelIcon, color: Colors.white)),
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 3,
//             ),
//             Text(
//                 AppLocalizations.of(context)!.posted +
//                     " ${timeago.format(DateTime.parse(widget.article[widget.index].postedOn ?? ""), locale: myLocale.languageCode)}",
//                 style: TextStyle(
//                     fontSize: SizeConfig.textMultiplier * 1.6,
//                     color: klightGreyText)),
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 1.5,
//             ),
//             //products images widget
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               physics: const BouncingScrollPhysics(
//                   parent: AlwaysScrollableScrollPhysics()),
//               child: Row(
//                 children: [
//                   ...List.generate(
//                       widget.article[widget.index].images!.length,
//                       (i) => InkWell(
//                             onTap: () {
//                               showImageViewer(
//                                   context,
//                                   Image.network(widget.article[widget.index]
//                                               .images?[i] ??
//                                           "")
//                                       .image,
//                                   swipeDismissible: true);
//                             },
//                             child: Container(
//                               height: SizeConfig.heightMultiplier * 18,
//                               width: SizeConfig.widthMultiplier * 40,
//                               margin: EdgeInsets.only(
//                                   right: SizeConfig.widthMultiplier * 2),
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(5),
//                                   image: DecorationImage(
//                                       image: NetworkImage(widget
//                                               .article[widget.index]
//                                               .images![i] ??
//                                           ""),
//                                       fit: BoxFit.cover),
//                                   boxShadow: const [
//                                     BoxShadow(
//                                         color: Colors.black26, blurRadius: 6)
//                                   ]),
//                             ),
//                           ))
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 3,
//             ),
//             //price and title widget
//             Row(
//               children: [
//                 SizedBox(
//                   width: SizeConfig.widthMultiplier * 45,
//                   child: Text(
//                     widget.article[widget.index].title ?? "",
//                     style: TextStyle(
//                         fontSize: SizeConfig.textMultiplier * 3,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white),
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                       vertical: SizeConfig.heightMultiplier * 0.5,
//                       horizontal: SizeConfig.widthMultiplier * 2),
//                   decoration: BoxDecoration(
//                       color: kSecondaryColor,
//                       borderRadius: BorderRadius.circular(40)),
//                   child: Text(
//                     "${widget.article[widget.index].price ?? ""} €",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: SizeConfig.textMultiplier * 2.1),
//                   ),
//                 ),
//                 SizedBox(
//                   width: SizeConfig.widthMultiplier * 5,
//                 )
//               ],
//             ),
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 1,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 WebsafeSvg.asset(passEyeIcon, color: Colors.white),
//                 SizedBox(
//                   width: SizeConfig.widthMultiplier * 2,
//                 ),
//                 Text(
//                   widget.article[widget.index].views!.length.toString(),
//                   style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                       fontSize: SizeConfig.textMultiplier * 2.1),
//                 ),
//                 SizedBox(
//                   width: SizeConfig.widthMultiplier * 5,
//                 )
//               ],
//             ),
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 1,
//             ),
//             //description
//             SizedBox(
//               width: SizeConfig.widthMultiplier * 90,
//               child: Text(
//                 widget.article[widget.index].description ?? "",
//                 style: TextStyle(
//                     fontSize: SizeConfig.textMultiplier * 1.7,
//                     color: klightGreyText),
//               ),
//             ),
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 4,
//             ),
//             //location
//             Row(
//               children: [
//                 const Icon(Icons.location_on_outlined, color: Colors.white),
//                 SizedBox(
//                   width: SizeConfig.widthMultiplier * 2,
//                 ),
//                 Text(
//                   widget.article[widget.index].location ?? "",
//                   style: TextStyle(
//                       fontSize: SizeConfig.textMultiplier * 1.7,
//                       color: klightGreyText),
//                 )
//               ],
//             ),
//             //tags
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 3,
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               physics: const BouncingScrollPhysics(),
//               child: Row(
//                 children: [
//                   ...List.generate(
//                     widget.article[widget.index].categories!.length,
//                     (i) => TagWidget(
//                       title: widget.article[widget.index].categories![i],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             //profile info widget
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 2,
//             ),
//             StreamBuilder<QuerySnapshot>(
//                 stream:
//                     FirebaseFirestore.instance.collection("Users").snapshots(),
//                 builder: (context, snapshot) {
//                   return ProfileInfoWidget(
//                     uid: widget.article[widget.index].userID ?? "",
//                     onCall: () {
//                       for (int i = 0;
//                           i < Get.find<AllUserController>().gettingUsers.length;
//                           i++) {
//                         if (Get.find<AllUserController>().gettingUsers[i].id ==
//                             widget.article[widget.index].userID) {
//                           final _phone = Get.find<AllUserController>()
//                                   .gettingUsers[i]
//                                   .phone ??
//                               "";
//                           _makePhoneCall("tel:$_phone");
//                         }
//                       }
//                     },
//                     onMessage: () {
//                       for (int i = 0; i < snapshot.data!.docs.length; i++) {
//                         if (snapshot.data!.docs[i].id ==
//                             widget.article[widget.index].userID) {
//                           setState(() {
//                             ownerPhotoURL =
//                                 snapshot.data!.docs[i].get("ProfilePic");
//                           });
//                           creatingChatRoom(
//                               snapshot.data!.docs[i].get("Fullname"),
//                               snapshot.data!.docs[i].id);
//                           break;
//                         }
//                       }
//                     },
//                   );
//                 }),
//             //go back and like buttons
//             Row(
//               children: [
//                 CustomSmallButton(
//                   title: AppLocalizations.of(context)!.go_back,
//                   color: kSecondaryColor,
//                   press: () {
//                     Get.back();
//                   },
//                 ),
//                 SizedBox(
//                   width: SizeConfig.widthMultiplier * 2,
//                 ),
//                 GetX<ArticlesController>(
//                     init: ArticlesController(),
//                     builder: (ArticlesController snapshot) {
//                       return CustomSmallButton(
//                         title: widget.article[widget.index].likedBy!.contains(
//                                 Get.find<AuthController>().userss!.uid)
//                             ? AppLocalizations.of(context)!.unlike
//                             : AppLocalizations.of(context)!.like,
//                         color: kPrimaryColor,
//                         press: () async {
//                           if (!widget.article[widget.index].likedBy!.contains(
//                               Get.find<AuthController>().userss!.uid)) {
//                             widget.article[widget.index].likedBy!
//                                 .add(Get.find<AuthController>().userss!.uid);
//                             await FirebaseFirestore.instance
//                                 .collection("Articles")
//                                 .doc(widget.article[widget.index].articleID)
//                                 .update({
//                               "LikedBy": widget.article[widget.index].likedBy!,
//                             });
//                           } else {
//                             widget.article[widget.index].likedBy!
//                                 .remove(Get.find<AuthController>().userss!.uid);
//                             await FirebaseFirestore.instance
//                                 .collection("Articles")
//                                 .doc(widget.article[widget.index].articleID)
//                                 .update({
//                               "LikedBy": widget.article[widget.index].likedBy!,
//                             });
//                           }
//                           setState(() {});
//                         },
//                       );
//                     })
//               ],
//             ),
//             SizedBox(
//               height: SizeConfig.heightMultiplier * 2,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
