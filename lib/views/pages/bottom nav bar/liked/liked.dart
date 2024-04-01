
import 'package:flutter/material.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/liked/components/liked_items.dart';

class LikedPage extends StatelessWidget {
  LikedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppbar(
              isProfileIcon: false,
              isBNBsection: true,
            ),
            //search text
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 6,
                  bottom: SizeConfig.heightMultiplier * 1.5,
                  top: SizeConfig.heightMultiplier * 2),
              child: Text(
                AppLocalizations.of(context)!.liked_items,
                style: TextStyle(
                    color: const Color(0xff475569),
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.textMultiplier * 5),
              ),
            ),
            LikedItems(),
          ],
        ),
      ),
    );
  }
}
