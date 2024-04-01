import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/chat_room.dart';
import 'package:secondhand/models/chat_model.dart';
import 'package:secondhand/models/chat_room.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/messages/components/tile.dart';
import 'package:secondhand/views/widgets/custom_appbar.dart';

import '../../../constants/icons.dart';
import '../../../controllers/all_user_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/size_config.dart';
import '../../widgets/no_data_widget.dart';
import '../../widgets/show_loading.dart';
import '../chat page/chat_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArchieveChat extends StatelessWidget {
  ArchieveChat({Key? key}) : super(key: key);
  final authCont = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppbar(isProfileIcon: false),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: SizeConfig.widthMultiplier * 5),
                    child: Text(
                      AppLocalizations.of(context)!.archived,
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 3.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF475569)),
                    )),
                GetX<ChatRoomCont>(builder: (roomCont) {
                  List<ChatRoomModel>? list = roomCont.getArchievedChat;
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
            )),
      ),
    );
  }
}
