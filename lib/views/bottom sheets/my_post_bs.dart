import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/icons.dart';
import '../../utils/size_config.dart';

class MyPostBottomSheet extends StatelessWidget {
  const MyPostBottomSheet({
    Key? key,required this.onPublish,required this.onDelete,
  }) : super(key: key);
final VoidCallback onPublish,onDelete;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: SizeConfig.heightMultiplier * 20,
          width: SizeConfig.widthMultiplier * 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 1,
              ),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: WebsafeSvg.asset(cancelIcon,
                      color: const Color(0xFF94A3B8))),
              InkWell(
                onTap: onPublish,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          SizeConfig.widthMultiplier * 4),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.publish_again,
                        //"Publish again",
                        style: TextStyle(
                            fontSize:
                                SizeConfig.textMultiplier * 2.1,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569)),
                      ),
                      const Spacer(),
                      const Icon(
                        FeatherIcons.upload,
                        color: Color(0xFF94A3B8),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        SizeConfig.widthMultiplier * 4),
                child: Divider(
                  height: SizeConfig.heightMultiplier * 3,
                  thickness: 1.5,
                  color: Colors.grey.shade200,
                ),
              ),
              InkWell(
                onTap: onDelete,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          SizeConfig.widthMultiplier * 4),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.delete_post,
                        //"Delete Post",
                        style: TextStyle(
                            fontSize:
                                SizeConfig.textMultiplier * 2.1,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569)),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.delete_outline_outlined,
                        color: Color(0xFF94A3B8),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
