import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/controllers/auth_controller.dart';

import 'package:secondhand/controllers/notification_controller.dart';
import 'package:secondhand/models/article_model.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/chat%20page/chat_page.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'components/custom_appbar.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifyCont = Get.put(NotificationController());
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NotificationsCustomAppBar(),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 6,
                  bottom: SizeConfig.heightMultiplier * 1.5,
                  top: SizeConfig.heightMultiplier * 1),
              child: Text(
                "Notifications",
                style: TextStyle(
                    color: const Color(0xff475569),
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.textMultiplier * 5),
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
            Center(
              child: Obx(
                () => ShowLoading(
                  inAsyncCall: authCont.isLoading.value,
                  child: Container(
                      height: SizeConfig.heightMultiplier * 70,
                      width: SizeConfig.widthMultiplier * 90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.shade200, width: 1),
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 4,
                          vertical: SizeConfig.heightMultiplier * 2),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemCount: notifyCont.gettingNotify.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () async {
                            final article = await FirebaseFirestore.instance
                                .collection('Articles')
                                .doc(notifyCont.gettingNotify[index].articleID)
                                .get();
                            final notifyData = notifyCont.gettingNotify[index];
                            Get.to(
                                () => ChatPage(
                                      articleID: notifyData.articleID!,
                                      otherUserID: notifyData.otherUserID!,
                                      currentUserID: Get.find<AuthController>()
                                          .userss!
                                          .uid,
                                      chatRoomID: notifyData.chatRoomID ?? "",
                                      otherUserName:
                                          notifyData.otherUserName ?? "",
                                      articleImages: article.get('Images'),
                                      articleName: article.get('Title'),
                                    ),
                                transition: Transition.rightToLeft);
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: SizeConfig.heightMultiplier * 6,
                                    width: SizeConfig.widthMultiplier * 12,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        image: isDummyImage(notifyCont
                                                .gettingNotify[index]
                                                .otherUserImg)
                                            ? null
                                            : DecorationImage(
                                                image: NetworkImage(notifyCont
                                                        .gettingNotify[index]
                                                        .otherUserImg ??
                                                    ""),
                                                fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: isDummyImage(notifyCont
                                            .gettingNotify[index].otherUserImg)
                                        ? Icon(Icons.person,
                                            color: kPrimaryColor)
                                        : null,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 4,
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              SizeConfig.widthMultiplier * 65,
                                          child: Text(
                                            notifyCont.gettingNotify[index]
                                                    .title ??
                                                "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  SizeConfig.textMultiplier * 1.8,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.heightMultiplier * 0.5,
                                        ),
                                        Text(
                                          "Tap to go to the message",
                                          style: TextStyle(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      1.5,
                                              color: const Color(0xFF475569)),
                                        ),
                                      ])
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  timeago.format(DateTime.parse(
                                      notifyCont.gettingNotify[index].date!)),
                                  style: TextStyle(
                                      fontSize: SizeConfig.textMultiplier * 1.4,fontWeight: FontWeight.w500,color: Colors.grey.shade600),
                                ),
                              ),
                              index == notifyCont.gettingNotify.length - 1
                                  ? const SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeConfig.heightMultiplier * 1),
                                      child: Divider(
                                        thickness: 1.5,
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isDummyImage(String? image) {
    return image == null || image == '' || image == 'N/A';
  }
}
