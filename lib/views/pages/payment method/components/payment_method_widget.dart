import 'package:flutter/material.dart';
import 'package:secondhand/utils/size_config.dart';

class PaymentMethodsWidget extends StatelessWidget {
  const PaymentMethodsWidget({
    Key? key,
    required this.press,
    required this.icon,
    required this.title,
  }) : super(key: key);
  final VoidCallback press;
  final Widget icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        height: SizeConfig.heightMultiplier * 12,
        width: SizeConfig.widthMultiplier * 90,
        margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 8, offset: Offset(-2, 8))
            ]),
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 5),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 3.3,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B)),
            ),
            const Spacer(),
            icon,
          ],
        ),
      ),
    );
  }
}
