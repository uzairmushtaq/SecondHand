import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/services/rating.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:secondhand/views/widgets/confirmation_dialog.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../constants/icons.dart';

class ProfileInfoWidget extends StatelessWidget {
  const ProfileInfoWidget({
    Key? key,
    required this.userData,
    required this.onMessage,
    required this.onCall,
  }) : super(key: key);

  final DocumentSnapshot userData;
  final VoidCallback onMessage, onCall;
  @override
  Widget build(BuildContext context) {
    //print(userData['RatedBy']);
    final format = DateFormat("yyyy");
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: SizeConfig.widthMultiplier * 5),
          child: Divider(
              thickness: 2, color: const Color(0xFFCBD5E1).withOpacity(0.6)),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 1),
          child: Row(
            children: [
              GestureDetector(
                onTap: userData.get('ProfilePic') == "N/A" ||
                        userData.get('ProfilePic') == null
                    ? null
                    : () => Get.dialog(Material(
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              Center(
                                child: Hero(
                                    tag: userData.get('ProfilePic'),
                                    child: InteractiveViewer(
                                        child: Image.network(
                                            userData.get('ProfilePic')))),
                              ),
                              Positioned(
                                  top: SizeConfig.heightMultiplier * 2,
                                  left: SizeConfig.widthMultiplier * 3,
                                  child: GestureDetector(
                                    onTap: () => Get.back(),
                                    child: CircleAvatar(
                                      radius: SizeConfig.widthMultiplier * 4,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                  ))
                            ],
                          ),
                        )),
                child: Hero(
                  tag: userData.get('ProfilePic') ?? 'null',
                  child: Container(
                    height: SizeConfig.heightMultiplier * 5,
                    width: SizeConfig.widthMultiplier * 12,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: userData.get('ProfilePic') == "N/A" ||
                                userData.get('ProfilePic') == null ||
                                userData['ProfilePic'] ==
                                    AppLocalizations.of(context)!.not_added_yet
                            ? null
                            : DecorationImage(
                                image: NetworkImage(userData.get('ProfilePic')),
                                fit: BoxFit.cover)),
                    child: userData.get('ProfilePic') == "N/A" ||
                            userData.get('ProfilePic') == null ||
                            userData['ProfilePic'] ==
                                AppLocalizations.of(context)!.not_added_yet
                        ? Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset(
                              noProfileIcon,
                              color: kPrimaryColor,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 40,
                    child: Text(
                      userData["Alias"] != "Optional" &&
                              userData["ShowAlias"] == true
                          ? userData["Alias"]
                          : userData["Fullname"] ?? "Unknown",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 2.8,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.member_since +
                        " ${format.format(DateTime.parse(userData["Date"]))}",
                    style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.5,
                      color: klightGreyText,
                    ),
                  ),
                  SizedBox(height: 5),
                  (userData["Language"] != null)
                      ? SizedBox(
                          height: SizeConfig.heightMultiplier * 3,
                          width: SizeConfig.widthMultiplier * 8,
                          child: WebsafeSvg.asset(
                              "assets/icons/" + userData["Language"]! + ".svg",
                              fit: BoxFit.cover),
                        )
                      : SizedBox(),
                ],
              ),
              const Spacer(),
              userData["ShowNumber"] == true && userData["Phone"] != null
                  ? IconButton(
                      onPressed: onCall,
                      icon: WebsafeSvg.asset(callOwner, color: Colors.white))
                  : const SizedBox(),
            ],
          ),
        ),
        //RATING SECTION
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(userData.id)
                .snapshots(),
            builder: (context, snapshot) {
              final isWaiting =
                  snapshot.connectionState == ConnectionState.waiting;
              final data = snapshot.data;
              return isWaiting?const SizedBox(): Column(
                children: [
                  //CURRENT RATING
                  FadeIn(
                    child: Row(
                      children: [
                        SizedBox(width: SizeConfig.widthMultiplier * 15),
                        for (int i = 0; i < 5; i++) ...[
                          Icon(
                            Icons.star,
                            size: 12,
                            color: isWaiting
                                ? Colors.grey.shade600
                                : i <
                                        RatingsService.calculatingtotalRating(
                                            data!['Ratings'])
                                    ? Colors.amber
                                    : Colors.grey.shade600,
                          ),
                        ],
                      ],
                    ),
                  ),
                  //GIVE RATING
                  data?['RatedBy'].contains(authCont.userss!.uid)
                      ? const SizedBox()
                      : Column(
                          children: [
                            SizedBox(height: SizeConfig.heightMultiplier * 1),
                            //RATING BAR
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Give rating?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier * 1),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                itemSize: SizeConfig.widthMultiplier * 6,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                unratedColor: Colors.grey.shade500,
                                itemPadding: EdgeInsets.only(right: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) => Get.dialog(
                                    ConfirmationDialog(
                                        height:
                                            SizeConfig.heightMultiplier * 30,
                                        title: 'Confirmation Required!',
                                        subtitle:
                                            'Are you sure you want to give a ${rating.toInt()}-star rating to this user?',
                                        onContinue: () =>
                                            RatingsService.doRating(
                                                userData.id,
                                                rating.toInt(),
                                                data?['Ratings'],
                                                data?['RatedBy']))),
                              ),
                            ),
                          ],
                        ),
                ],
              );
            }),
        Padding(
          padding: EdgeInsets.only(right: SizeConfig.widthMultiplier * 5),
          child: Divider(
              thickness: 2, color: const Color(0xFFCBD5E1).withOpacity(0.6)),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 2,
        ),
      ],
    );
  }
}
