import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:secondhand/constants/colors.dart';

import '../../utils/size_config.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const spinKit = SpinKitChasingDots(
      color: kPrimaryColor,
    );
    return Center(
        child:
            SizedBox(height: SizeConfig.heightMultiplier * 8, child: spinKit));
  }
}
