import 'package:flutter/material.dart';
import 'package:secondhand/utils/size_config.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.heightMultiplier * 0.6,
          horizontal: SizeConfig.widthMultiplier * 3),
      margin: EdgeInsets.only(right: SizeConfig.widthMultiplier * 3),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
          borderRadius: BorderRadius.circular(40)),
      child: Text(
        title,
        style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.7),
      ),
    );
  }
}
