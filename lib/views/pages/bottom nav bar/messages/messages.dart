import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/controllers/chat_room.dart';
import 'package:secondhand/controllers/your_mode_controller.dart';
import 'package:secondhand/models/chat_room.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/archieve%20chat/archieve_chat.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/home/components/your_mode_widget.dart';
import 'package:secondhand/views/widgets/custom_appbar.dart';
import 'package:secondhand/views/widgets/no_data_widget.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'package:translator/translator.dart';
import '../../../../constants/colors.dart';
import '../../../../controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'components/tile.dart';

class MessagesPage extends StatelessWidget {
  final authCont = Get.find<AuthController>();
  final cont = Get.put(ChatRoomCont());
  final globalCont = Get.find<YourModeController>();
  final translator = GoogleTranslator();
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppbar(
                isProfileIcon: false,
                isBNBsection: true,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier*5),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.all_messages,
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 3.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF475569)),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Get.to(() => ArchieveChat(),
                                transition: Transition.leftToRight);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.archived,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: SizeConfig.textMultiplier * 2,
                                color: kTextColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 2,
                        )
                      ],
                    ),
                  ),
                  YourModeWidget(
                    type: 'messages',
                    function: () {
                      print(globalCont.yourModeIndex.value);
    
                      // setState(() {});
                    },
                  ),
                  GetX<ChatRoomCont>(builder: (roomCont) {
                    List<ChatRoomModel>? list =
                        globalCont.yourModeIndex.value == 1
                            ? roomCont.getNormalBuyChat
                            : roomCont.getNormalSellChat;
                    return list == null
                        ? SizedBox(
                            height: SizeConfig.heightMultiplier * 70,
                            child: const Loading())
                        : list.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.only(
                                    bottom: SizeConfig.heightMultiplier * 10,
                                    top: SizeConfig.heightMultiplier * 2),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: list.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return MsgRoomTile(data: list[index]);
                                })
                            : SizedBox(
                                height: SizeConfig.heightMultiplier * 70,
                                child: const NoDataWidget());
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}






































// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_fadein/flutter_fadein.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:get/get.dart';
// import 'package:secondhand/controllers/all_user_controller.dart';
// import 'package:secondhand/controllers/your_mode_controller.dart';
// import 'package:secondhand/utils/size_config.dart';
// import 'package:secondhand/views/pages/archieve%20chat/archieve_chat.dart';
// import 'package:secondhand/views/pages/bottom%20nav%20bar/home/components/your_mode_widget.dart';
// import 'package:secondhand/views/widgets/custom_appbar.dart';
// import 'package:secondhand/views/widgets/no_data_widget.dart';
// import 'package:secondhand/views/widgets/show_loading.dart';
// import 'package:translator/translator.dart';
// import '../../../../constants/colors.dart';
// import '../../../../controllers/auth_controller.dart';
// import '../../chat page/chat_page.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class MessagesPage extends StatefulWidget {
//   @override
//   State<MessagesPage> createState() => _MessagesPageState();
// }

// class _MessagesPageState extends State<MessagesPage> {
//   final authCont = Get.find<AuthController>();

//   final globalCont = Get.find<YourModeController>();
//   final translator = GoogleTranslator();
//   @override
//   Widget build(BuildContext context) {
//     Locale myLocale = Localizations.localeOf(context);
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(
//             parent: AlwaysScrollableScrollPhysics()),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const CustomAppbar(
//               isProfileIcon: false,
//               isBNBsection: true,
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                   left: SizeConfig.widthMultiplier * 5,
//                   right: SizeConfig.widthMultiplier * 5),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: SizeConfig.heightMultiplier * 1,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)!.all_messages,
//                         style: TextStyle(
//                             fontSize: SizeConfig.textMultiplier * 3.5,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF475569)),
//                       ),
//                       const Spacer(),
//                       TextButton(
//                         onPressed: () {
//                           Get.to(() => ArchieveChat(),
//                               transition: Transition.leftToRight);
//                         },
//                         child: Text(
//                           AppLocalizations.of(context)!.archived,
//                           style: TextStyle(
//                               decoration: TextDecoration.underline,
//                               fontSize: SizeConfig.textMultiplier * 2,
//                               color: kTextColor,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                       SizedBox(
//                         width: SizeConfig.widthMultiplier * 2,
//                       )
//                     ],
//                   ),
//                   YourModeWidget(
//                     type: 'messages',
//                     function: () {
//                       setState(() {});
//                     },
//                   ),
//                   StreamBuilder<QuerySnapshot>(
//                       stream: globalCont.yourModeIndex.value == 1
//                           ? FirebaseFirestore.instance
//                               .collection("ChatRoom")
//                               .where('archieve', isEqualTo: false)
//                               .where("ArticleOwnerID",
//                                   isNotEqualTo:
//                                       Get.find<AuthController>().userInfo?.id)
//                               .where('users',
//                                   arrayContains:
//                                       Get.find<AuthController>().userInfo?.id)
//                               .snapshots()
//                           : FirebaseFirestore.instance
//                               .collection("ChatRoom")
//                               .where('archieve', isNotEqualTo: true)
//                               .where("ArticleOwnerID",
//                                   isEqualTo:
//                                       Get.find<AuthController>().userInfo?.id)
//                               .where('users',
//                                   arrayContains:
//                                       Get.find<AuthController>().userInfo?.id)
//                               .snapshots(),
//                       builder: (context, chatsnapshot) {
//                         return chatsnapshot.connectionState ==
//                                 ConnectionState.waiting
//                             ? SizedBox(
//                                 height: SizeConfig.heightMultiplier * 70,
//                                 child: const Loading())
//                             : chatsnapshot.data!.docs.isNotEmpty
//                                 ? ListView.builder(
//                                     padding: EdgeInsets.only(
//                                         bottom:
//                                             SizeConfig.heightMultiplier * 10,
//                                         top: SizeConfig.heightMultiplier * 2),
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     itemCount: chatsnapshot.data!.docs.length,
//                                     shrinkWrap: true,
//                                     itemBuilder: (context, index) {
//                                       final data =
//                                           chatsnapshot.data!.docs[index];
//                                       final otherUsername =
//                                           data.get('userData')[0]['id'] ==
//                                                   authCont.userss!.uid
//                                               ? data.get('userData')[1]
//                                                       ['username'] ??
//                                                   'Unknown'
//                                               : data.get('userData')[0]
//                                                       ['username'] ??
//                                                   'Unknown';
//                                       return FadeIn(
//                                         duration:
//                                             const Duration(milliseconds: 400),
//                                         child: Slidable(
//                                           closeOnScroll: true,

//                                           //archeive or delte slidable buttons
//                                           endActionPane: ActionPane(
//                                             motion: ScrollMotion(),
//                                             children: [
//                                               InkWell(
//                                                 onTap: () async {
//                                                   //MAKING ARCHIEVE AND UNARCHIEVE
//                                                   var isArchived =
//                                                       data.get("archieve");

//                                                   if (isArchived is bool) {
//                                                   } else {
//                                                     isArchived =
//                                                         (isArchived.isEmpty)
//                                                             ? false
//                                                             : true;
//                                                   }
//                                                   await FirebaseFirestore
//                                                       .instance
//                                                       .collection("ChatRoom")
//                                                       .doc(data.id)
//                                                       .update({
//                                                     "archieve": (isArchived)
//                                                         ? false
//                                                         : true
//                                                   }).then((value) {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(SnackBar(
//                                                             content: Text(
//                                                       isArchived
//                                                           ? AppLocalizations.of(
//                                                                   context)!
//                                                               .unarchived_successfully
//                                                           : AppLocalizations.of(
//                                                                   context)!
//                                                               .archived_successfully,
//                                                     )));
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   height: SizeConfig
//                                                           .heightMultiplier *
//                                                       12,
//                                                   width: SizeConfig
//                                                           .widthMultiplier *
//                                                       30,
//                                                   color:
//                                                       const Color(0xFF94A3B8),
//                                                   child: Center(
//                                                     child: Text(
//                                                       (chatsnapshot.data
//                                                                       ?.docs[index]
//                                                                       .get(
//                                                                           "archieve")
//                                                                   is bool &&
//                                                               chatsnapshot
//                                                                       .data
//                                                                       ?.docs[
//                                                                           index]
//                                                                       .get(
//                                                                           "archieve") ==
//                                                                   true)
//                                                           ? AppLocalizations.of(
//                                                                   context)!
//                                                               .unarchive
//                                                           : AppLocalizations.of(
//                                                                   context)!
//                                                               .archive,
//                                                       style: TextStyle(
//                                                           fontSize: SizeConfig
//                                                                   .textMultiplier *
//                                                               1.5,
//                                                           color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.w700),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               InkWell(
//                                                 onTap: () async {
//                                                   //DELETING QUERY
//                                                   await FirebaseFirestore
//                                                       .instance
//                                                       .collection("ChatRoom")
//                                                       .doc(chatsnapshot
//                                                           .data?.docs[index].id)
//                                                       .delete()
//                                                       .then((value) async {
//                                                     await FirebaseFirestore
//                                                         .instance
//                                                         .collection("ChatRoom")
//                                                         .doc(data.id)
//                                                         .collection("Chats")
//                                                         .get()
//                                                         .then((value) async {
//                                                       for (int i = 0;
//                                                           i < value.docs.length;
//                                                           i++) {
//                                                         await FirebaseFirestore
//                                                             .instance
//                                                             .collection(
//                                                                 "ChatRoom")
//                                                             .doc(data.id)
//                                                             .collection("Chats")
//                                                             .doc(value
//                                                                 .docs[i].id)
//                                                             .delete();
//                                                       }
//                                                     });
//                                                   }).then((value) {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(SnackBar(
//                                                             content: Text(
//                                                                 AppLocalizations.of(
//                                                                         context)!
//                                                                     .deleting)));
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   height: SizeConfig
//                                                           .heightMultiplier *
//                                                       12,
//                                                   width: SizeConfig
//                                                           .widthMultiplier *
//                                                       30,
//                                                   color:
//                                                       const Color(0xFFDC2626),
//                                                   child: Center(
//                                                     child: Text(
//                                                       AppLocalizations.of(
//                                                               context)!
//                                                           .delete,
//                                                       style: TextStyle(
//                                                           fontSize: SizeConfig
//                                                                   .textMultiplier *
//                                                               1.5,
//                                                           color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.w700),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           child: SizedBox(
//                                               height:
//                                                   SizeConfig.heightMultiplier *
//                                                       12,
//                                               width:
//                                                   SizeConfig.widthMultiplier *
//                                                       100,
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         right: SizeConfig
//                                                                 .widthMultiplier *
//                                                             5),
//                                                     child: Divider(
//                                                       height: 1,
//                                                       thickness: 1,
//                                                       color:
//                                                           Colors.grey.shade200,
//                                                     ),
//                                                   ),
//                                                   //getting the other user data
//                                                   Column(children: [
//                                                     InkWell(
//                                                       onTap: () {
//                                                         Get.to(() => ChatPage(
//                                                               articleID: data.get(
//                                                                   'ArticleID'),
//                                                               // articleOwnerID: chatsnapshot.data!.docs[index].get("ArticleOwnerID"),
//                                                               articleImages:
//                                                                   data.get(
//                                                                       "ArticleImages"),
//                                                               articleName: data.get(
//                                                                   "ArticleName"),
//                                                               chatRoomID: data.get(
//                                                                   "chatRoomID"),
//                                                               currentUserID:
//                                                                   authCont.userInfo
//                                                                           ?.id ??
//                                                                       "",
//                                                               otherUserName:
//                                                                   data.get(
//                                                                           "ArticleName") ??
//                                                                       "",
//                                                               otherUserID: data.get(
//                                                                               'userData')[0]
//                                                                           [
//                                                                           'id'] ==
//                                                                       authCont
//                                                                           .userss!
//                                                                           .uid
//                                                                   ? data.get(
//                                                                           'userData')[
//                                                                       1]['id']
//                                                                   : data.get(
//                                                                           'userData')[
//                                                                       0]['id'],
//                                                             ));
//                                                       },
//                                                       child: Row(
//                                                         children: [
//                                                           Container(
//                                                             height: SizeConfig
//                                                                     .heightMultiplier *
//                                                                 5,
//                                                             width: SizeConfig
//                                                                     .widthMultiplier *
//                                                                 10,
//                                                             decoration: BoxDecoration(
//                                                                 color: Colors
//                                                                     .grey
//                                                                     .shade200,
//                                                                 image: DecorationImage(
//                                                                     image: NetworkImage(chatsnapshot
//                                                                             .data!
//                                                                             .docs[
//                                                                                 index]
//                                                                             .get("ArticleImages")[
//                                                                         0]),
//                                                                     fit: BoxFit
//                                                                         .cover),
//                                                                 shape: BoxShape
//                                                                     .circle),
//                                                           ),
//                                                           SizedBox(
//                                                             width: SizeConfig
//                                                                     .widthMultiplier *
//                                                                 3,
//                                                           ),
//                                                           Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Text(
//                                                                 otherUsername ==
//                                                                         ''
//                                                                     ? 'Unknown'
//                                                                     : otherUsername,
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         SizeConfig.textMultiplier *
//                                                                             2.1,
//                                                                     color: const Color(
//                                                                         0xFF475569),
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700),
//                                                               ),
//                                                               Text(
//                                                                 chatsnapshot
//                                                                     .data!
//                                                                     .docs[index]
//                                                                     .get(
//                                                                         "ArticleName"),
//                                                                 style: TextStyle(
//                                                                     color: const Color(
//                                                                         0xFF475569),
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w500),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: SizeConfig
//                                                                         .heightMultiplier *
//                                                                     0.5,
//                                                               ),
//                                                               //WHERE WE ARE SHOWING LATEST MESSAGE
//                                                               StreamBuilder<
//                                                                       QuerySnapshot>(
//                                                                   stream: FirebaseFirestore
//                                                                       .instance
//                                                                       .collection(
//                                                                           "ChatRoom")
//                                                                       .doc(chatsnapshot
//                                                                           .data!
//                                                                           .docs[
//                                                                               index]
//                                                                           .id)
//                                                                       .collection(
//                                                                           "Chats")
//                                                                       .snapshots(),
//                                                                   builder: (context,
//                                                                       snapshot) {
//                                                                     if (snapshot
//                                                                             .connectionState ==
//                                                                         ConnectionState
//                                                                             .waiting) {
//                                                                       return Text(
//                                                                         "",
//                                                                         maxLines:
//                                                                             1,
//                                                                         overflow:
//                                                                             TextOverflow.ellipsis,
//                                                                         style:
//                                                                             TextStyle(
//                                                                           fontSize:
//                                                                               SizeConfig.textMultiplier * 2,
//                                                                           color:
//                                                                               const Color(0xFF94A3B8),
//                                                                         ),
//                                                                       );
//                                                                     } else if (getLastMsg(
//                                                                             snapshot.data!) ==
//                                                                         null) {
//                                                                       return Text(
//                                                                           'No messages yet!',
//                                                                           style: TextStyle(
//                                                                               fontSize: SizeConfig.textMultiplier * 1.7,
//                                                                               color: const Color(0xFF94A3B8)));
//                                                                     } else {
//                                                                       bool
//                                                                           new_message =
//                                                                           false;
//                                                                       if (snapshot.data!.docs != null &&
//                                                                           snapshot.data!.docs.length >
//                                                                               0 &&
//                                                                           getLastMsg(snapshot.data!)!.get("Seen") ==
//                                                                               false &&
//                                                                           getLastMsg(snapshot.data!)!.get("SendBy") !=
//                                                                               authCont.userInfo?.id) {
//                                                                         new_message =
//                                                                             true;
//                                                                       }
//                                                                       return snapshot
//                                                                               .data!
//                                                                               .docs
//                                                                               .isNotEmpty
//                                                                           ? Row(
//                                                                               children: [
//                                                                                 Icon(
//                                                                                   getLastMsg(snapshot.data!)!.get("SendBy") == authCont.userInfo?.id ? FeatherIcons.arrowUpLeft : FeatherIcons.arrowDownRight,
//                                                                                   size: SizeConfig.heightMultiplier * 2.5,
//                                                                                   color: (!new_message) ? const Color(0xFF94A3B8) : Colors.black,
//                                                                                 ),
//                                                                                 (new_message)
//                                                                                     ? Icon(
//                                                                                         Icons.circle_rounded,
//                                                                                         size: 12,
//                                                                                         color: kPrimaryColor,
//                                                                                       )
//                                                                                     : SizedBox(),
//                                                                                 SizedBox(
//                                                                                   width: SizeConfig.widthMultiplier * 1,
//                                                                                 ),
//                                                                                 SizedBox(
//                                                                                   width: SizeConfig.widthMultiplier * 65,
//                                                                                   child: Text(
//                                                                                     getLastMsg(snapshot.data!)!.get("Type") == "image"
//                                                                                         ? "${getLastMsg(snapshot.data!)!.get("Images").length}x photos"
//                                                                                         : getLastMsg(snapshot.data!)!.get("Type") == "text"
//                                                                                             ? getLastMsg(snapshot.data!)!.get('Message')
//                                                                                             : "audio",
//                                                                                     maxLines: 1,
//                                                                                     overflow: TextOverflow.ellipsis,
//                                                                                     style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.7, color: (!new_message) ? const Color(0xFF94A3B8) : Colors.black),
//                                                                                   ),
//                                                                                 ),
//                                                                               ],
//                                                                             )
//                                                                           : Text(
//                                                                               AppLocalizations.of(context)!.no_data_found,
//                                                                               maxLines: 1,
//                                                                               overflow: TextOverflow.ellipsis,
//                                                                               style: TextStyle(
//                                                                                 fontSize: SizeConfig.textMultiplier * 1.7,
//                                                                                 color: const Color(0xFF94A3B8),
//                                                                               ),
//                                                                             );
//                                                                     }
//                                                                   }),
//                                                             ],
//                                                           )
//                                                         ],
//                                                       ),
//                                                     )
//                                                   ]),

//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         right: SizeConfig
//                                                                 .widthMultiplier *
//                                                             5),
//                                                     child: Divider(
//                                                       height: 1,
//                                                       thickness: 1,
//                                                       color:
//                                                           Colors.grey.shade200,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               )),
//                                         ),
//                                       );
//                                     })
//                                 : SizedBox(
//                                     height: SizeConfig.heightMultiplier * 70,
//                                     child: const NoDataWidget());
//                       })
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   DocumentSnapshot? getLastMsg(QuerySnapshot query) {
//     List<DocumentSnapshot> msgs = [];
//     query.docs.forEach((DocumentSnapshot doc) {
//       if (!doc.get('DeleteMsgBy').contains(authCont.userss!.uid)) {
//         msgs.add(doc);
//       }
//     });
//     return msgs.isEmpty ? null : msgs.last;
//   }
// }
