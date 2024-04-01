import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:secondhand/utils/size_config.dart';

class EnableLocationWidget extends StatelessWidget {
  const EnableLocationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.heightMultiplier*40,
      width: SizeConfig.widthMultiplier*90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Please enable location in your mobile settings'),
          TextButton(onPressed: ()=>Geolocator.openLocationSettings(), child: Text('Enable'))
        ],
      ),
    );
  }
}