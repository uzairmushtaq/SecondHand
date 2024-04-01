import 'package:flutter/material.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/utils/size_config.dart';

class SearchItemButton extends StatelessWidget {
  const SearchItemButton({
    Key? key,
    required this.title,
    required this.isShuffleButton,
    required this.press,
    required this.isSellerProfile,
  }) : super(key: key);
  final String title;
  final bool isShuffleButton;
  final VoidCallback press;
  final bool isSellerProfile;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: press,
        child: AnimatedContainer(
          duration:const Duration(milliseconds: 100),
          height: SizeConfig.heightMultiplier * 5,
          width: SizeConfig.widthMultiplier * 90,
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8)
              ],
              color: isSellerProfile ? kSecondaryColor : kPrimaryColor,
              borderRadius: BorderRadius.circular(50)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: SizeConfig.textMultiplier * 2.1),
              ),
              isShuffleButton
                  ? Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.widthMultiplier * 1),
                      child: const Icon(
                        Icons.shuffle,
                        size: 18,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
