import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/utils/size_config.dart';

class AudioLoadingMessage extends StatelessWidget {
  const AudioLoadingMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier * 4.5,
            width: SizeConfig.widthMultiplier * 50,
          child: Lottie.asset("assets/images/audioloading.json",height: SizeConfig.heightMultiplier*4,fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }
}
