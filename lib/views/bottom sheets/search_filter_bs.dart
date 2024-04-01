import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../constants/icons.dart';
import '../../utils/size_config.dart';


class SearchFilterBS extends StatelessWidget {
  const SearchFilterBS({
    Key? key,
    required this.saveFilter,
    required this.deleteFilter,
  }) : super(key: key);
  final VoidCallback saveFilter, deleteFilter;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 22,
      width: SizeConfig.widthMultiplier * 100,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2),
            child: IconButton(
                onPressed: deleteFilter,
                icon: WebsafeSvg.asset(cancelIcon,
                    color: const Color(0xFF94A3B8))),
          ),
          InkWell(
            onTap: saveFilter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 5),
              child: Row(
                children: [
                  Text(
                    "Save search",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569)),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.save,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 0.5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 5),
            child: const Divider(
              color: Color(0xFFE2E8F0),
              thickness: 1,
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 0.5,
          ),
          InkWell(
            onTap:deleteFilter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 5),
              child: Row(
                children: [
                  Text(
                    "Delete and go back",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569)),
                  ),
                  const Spacer(),
                  const Icon(Icons.delete_outline, color: Color(0xFF94A3B8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}