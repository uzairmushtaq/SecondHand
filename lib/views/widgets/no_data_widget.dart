
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:secondhand/constants/images.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.widthMultiplier * 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(noDataWidget,height: SizeConfig.heightMultiplier*10),
          Text(AppLocalizations.of(context)!.no_data_found)
        ],
      ),
    );
  }
}
