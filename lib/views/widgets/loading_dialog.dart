import 'package:flutter/material.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import '../../../../utils/size_config.dart';

class LoadingDialog extends StatefulWidget {
  LoadingDialog({
    Key? key,
    required this.text,
  });
  final String text;
  @override
  State<StatefulWidget> createState() => LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            height: 20 * SizeConfig.heightMultiplier,
            width: 70 * SizeConfig.widthMultiplier,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.heightMultiplier * 2,
                horizontal: SizeConfig.widthMultiplier * 10),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1,
                ),
                Text(
                  "${widget.text}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.heightMultiplier * 2),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 3,
                ),
                const Loading()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
