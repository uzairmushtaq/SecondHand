import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../utils/size_config.dart';
import '../../bottom nav bar/home/components/search_item_button.dart';

class AddNameDialog extends StatefulWidget {
  AddNameDialog(
      {Key? key,
      required this.onAdd,
      required this.hintText,
      required this.controller,
      this.addButtonText = "Add"});
  final VoidCallback onAdd;
  final String hintText;
  final TextEditingController controller;
  final String addButtonText;
  @override
  State<StatefulWidget> createState() => AddNameDialogState();
}

class AddNameDialogState extends State<AddNameDialog>
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
            width: 90 * SizeConfig.widthMultiplier,
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
                Container(
                  height: SizeConfig.heightMultiplier * 6,
                  width: SizeConfig.widthMultiplier * 90,
                  decoration: BoxDecoration(
                    color: klightGreyText.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 5),
                  child: TextField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your ${widget.hintText}",
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8))),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 3,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 20),
                  child: SearchItemButton(
                      title: widget.addButtonText,
                      isShuffleButton: false,
                      press: widget.onAdd,
                      isSellerProfile: false),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
