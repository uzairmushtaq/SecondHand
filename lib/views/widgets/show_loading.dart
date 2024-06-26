import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:secondhand/views/widgets/loading_dialog.dart';

import '../../constants/colors.dart';
import '../../utils/size_config.dart';

class ShowLoading extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color>? valueColor;

  const ShowLoading({
    Key? key,
    required this.child,
    required this.inAsyncCall,
    this.opacity = 0.1,
    this.color = Colors.black,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          // ignore: prefer_const_constructors
          Loading(),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}




class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const spinKit = SpinKitChasingDots(
      color: kPrimaryColor,
    );
    return Center(
      child: SizedBox(height: SizeConfig.heightMultiplier * 8, child: spinKit),
    );
  }
}
