import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:secondhand/utils/size_config.dart';

class TestList extends StatelessWidget {
  const TestList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      reverse: true,
      shrinkWrap: true,
      itemBuilder: (_, i) => Container(
        height: SizeConfig.heightMultiplier * 10,
        width: SizeConfig.widthMultiplier * 40,
        color: Colors.red,
        margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 2),
        child: Center(
            child: Text(
          i.toString(),
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
