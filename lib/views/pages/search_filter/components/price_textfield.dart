import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../utils/size_config.dart';

class PriceTextField extends StatelessWidget {
  const PriceTextField({
    Key? key,
    required this.maxPriceCont,
  }) : super(key: key);

  final TextEditingController maxPriceCont;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthMultiplier * 35,
      margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: const Color(0xff475569),
          )),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 3),
      child: TextField(
        controller: maxPriceCont,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context)!.set_max_price,
            hintStyle: TextStyle(
              color: Color(0xFF94A3B8),
            )),
      ),
    );
  }
}
