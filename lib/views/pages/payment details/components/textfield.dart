// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:secondhand/constants/colors.dart';
// import 'package:secondhand/utils/size_config.dart';

// class PaymentDetailsTextField extends StatelessWidget {
//   const PaymentDetailsTextField({
//     Key? key,
//     required this.hintText,
//     this.scanPress,
//     required this.width,
//     required this.controller,
//     required this.keyboardType,
//   }) : super(key: key);
//   final String hintText;
//   final VoidCallback? scanPress;
//   final double width;
//   final TextEditingController controller;
//   final TextInputType keyboardType;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: SizeConfig.heightMultiplier * 5.7,
//       width: width,
//       margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 1.2),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(50),
//           border: Border.all(color: kSecondaryColor, width: 1.5)),
//       padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 5),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               keyboardType: keyboardType,
//               decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: hintText,
//                   hintStyle: TextStyle(
//                       color: const Color(0xFF94A3B8),
//                       fontSize: SizeConfig.textMultiplier * 2)),
//             ),
//           ),
//           hintText == "Name on card"
//               ? InkWell(
//                   onTap: scanPress,
//                   child: Icon(
//                     FeatherIcons.camera,
//                     color: kSecondaryColor,
//                     size: SizeConfig.heightMultiplier * 2.7,
//                   ))
//               : const SizedBox(),
//         ],
//       ),
//     );
//   }
// }
