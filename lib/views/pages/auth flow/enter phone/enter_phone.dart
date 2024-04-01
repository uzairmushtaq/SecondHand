// import 'package:country_pickers/country.dart';
// import 'package:country_pickers/country_picker_dialog.dart';
// import 'package:country_pickers/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get.dart';
// import 'package:secondhand/constants/colors.dart';
// import 'package:secondhand/constants/images.dart';
// import 'package:secondhand/controllers/auth_controller.dart';
// 
// import 'package:secondhand/controllers/selected_text_controller.dart';
// import 'package:secondhand/utils/size_config.dart';
// import 'package:secondhand/views/widgets/next_button.dart';
// import 'package:secondhand/views/widgets/second_hand_text.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:secondhand/views/widgets/show_loading.dart';

// class EnterPhonePage extends StatefulWidget {
//   const EnterPhonePage({Key? key}) : super(key: key);
//   @override
//   State<EnterPhonePage> createState() => _EnterPhonePageState();
// }

// class _EnterPhonePageState extends State<EnterPhonePage> {
//   final globalCont = Get.find<GlobalUIController>();
//   final authCont = Get.find<AuthController>();
//   final authCont = Get.find<authController>();
//   Country _selectedDialogCountry =
//       CountryPickerUtils.getCountryByPhoneCode('33');

//   @override
//   void dispose() {
//     super.dispose();
//     globalCont.isPhoneOkay.value = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => ShowLoading(
//         inAsyncCall: authCont.isLoading.value,
//         child: enterPhoneUI(context)));
//   }

//   Widget enterPhoneUI(BuildContext context) {
//     return Scaffold(
//         backgroundColor: kLightYellow,
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(
//               parent: AlwaysScrollableScrollPhysics()),
//           child: SizedBox(
//             width: SizeConfig.widthMultiplier * 100,
//             child: AnimationLimiter(
//               child: Column(
//                 children: AnimationConfiguration.toStaggeredList(
//                   duration: const Duration(milliseconds: 200),
//                   childAnimationBuilder: (widget) => SlideAnimation(
//                     verticalOffset: 50.0,
//                     child: FadeInAnimation(
//                       child: widget,
//                     ),
//                   ),
//                   children: [
//                     SizedBox(
//                       height: SizeConfig.heightMultiplier * 8,
//                     ),
//                     //second hand text widget
//                     const SecondHandTextWidget(),
//                     SizedBox(
//                       height: SizeConfig.heightMultiplier * 1,
//                     ),
//                     //signup img
//                     Image.asset(signUpImg),
//                     Text(
//                       AppLocalizations.of(context)!.registration,
//                       style: TextStyle(
//                           fontSize: SizeConfig.textMultiplier * 5,
//                           color: kTextColor,
//                           fontWeight: FontWeight.w700),
//                     ),
//                     SizedBox(
//                       height: SizeConfig.heightMultiplier * 1,
//                     ),
//                     Text(
//                       AppLocalizations.of(context)!.last_step,
//                       style: TextStyle(
//                           fontSize: SizeConfig.textMultiplier * 2.2,
//                           color: klightGreen,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(
//                       height: SizeConfig.heightMultiplier * 2,
//                     ),
//                     SizedBox(
//                       width: SizeConfig.widthMultiplier * 90,
//                       child: Row(
//                         children: [
//                           TextButton(
//                               onPressed: () {
//                                 _openCountryPickerDialog();
//                               },
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     height: 25,
//                                     width: 40,
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(3),
//                                       child: CountryPickerUtils
//                                           .getDefaultFlagImage(
//                                               _selectedDialogCountry),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 3,
//                                   ),
//                                   Icon(
//                                     Icons.keyboard_arrow_down,
//                                     color: Colors.grey.shade600,
//                                   )
//                                 ],
//                               )),
//                           Expanded(
//                             child: TextField(
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: SizeConfig.textMultiplier * 2.3),
//                               controller: authCont.phoneCont,
//                               decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: AppLocalizations.of(context)!.phone,
//                                   hintStyle: TextStyle(
//                                       fontSize: SizeConfig.textMultiplier * 2.1,
//                                       fontWeight: FontWeight.w400,
//                                       color: const Color(0xFF94A3B8))),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Obx(
//                       () => SizedBox(
//                         width: SizeConfig.widthMultiplier * 90,
//                         child: Divider(
//                           height: 1,
//                           thickness: 1,
//                           color: globalCont.isPhoneOkay.value
//                               ? Colors.red
//                               : kTextColor,
//                         ),
//                       ),
//                     ),
//                     AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 200),
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                             left: SizeConfig.widthMultiplier * 5,
//                             top: SizeConfig.heightMultiplier * 1),
//                         child: Obx(
//                           () => Align(
//                             alignment: Alignment.centerLeft,
//                             child: globalCont.isPhoneOkay.value
//                                 ? Text(
//                                     AppLocalizations.of(context)!
//                                         .wrong_phone_number,
//                                     //"Your phone number is wrong. Try another one.",
//                                     style: TextStyle(
//                                         fontSize:
//                                             SizeConfig.textMultiplier * 1.4,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.red),
//                                   )
//                                 : const SizedBox(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: SizeConfig.heightMultiplier * 4,
//                     ),
//                     NextButton(
//                         title: AppLocalizations.of(context)!.get_sms,
//                         color: kSecondaryColor,
//                         borderColor: kSecondaryColor,
//                         textColor: kWhiteColor,
//                         icon: Icons.arrow_forward_ios_rounded,
//                         press: () => _onNext()),
//                     SizedBox(
//                       height: SizeConfig.heightMultiplier * 2,
//                     ),
//                     NextButton(
//                         title: AppLocalizations.of(context)!.go_back,
//                         color: kLightYellow,
//                         borderColor: kSecondaryColor,
//                         textColor: klightGreen,
//                         icon: Icons.arrow_back_ios_new_rounded,
//                         press: () {
//                           Get.back();
//                         })
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }

//   _onNext() async {
//     authCont.countryCode.value = _selectedDialogCountry.phoneCode;
//     //print(authCont.countryCode.value+authCont.phoneCont.text);
//     await authCont.checkPhoneNumber();

//     authCont.isLoading.value = false;
//   }

//   void _openCountryPickerDialog() => showDialog(
//         context: context,
//         builder: (context) => Theme(
//             data: Theme.of(context).copyWith(primaryColor: kTextColor),
//             child: SizedBox(
//               child: CountryPickerDialog(
//                   titlePadding:
//                       EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 1),
//                   searchCursorColor: Colors.pinkAccent,
//                   searchInputDecoration: const InputDecoration(
//                     hintText: 'Search...',
//                     enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: kTextColor, width: 1)),
//                     focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: kTextColor, width: 1)),
//                   ),
//                   isSearchable: true,
//                   title: Text(AppLocalizations.of(context)!.select_phone_code),
//                   onValuePicked: (Country country) =>
//                       setState(() => _selectedDialogCountry = country),
//                   itemBuilder: _buildDialogItem),
//             )),
//       );
//   Widget _buildDialogItem(Country country) => Row(
//         children: <Widget>[
//           ClipRRect(
//               borderRadius: BorderRadius.circular(3),
//               child: CountryPickerUtils.getDefaultFlagImage(country)),
//           const SizedBox(width: 8.0),
//           Text("+${country.phoneCode}"),
//           const SizedBox(width: 8.0),
//           Flexible(child: Text(country.name))
//         ],
//       );
// }
