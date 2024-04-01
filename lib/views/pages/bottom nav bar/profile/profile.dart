import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/services/contact_us.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/home/components/search_item_button.dart';
import 'package:secondhand/views/pages/edit%20profile/edit_profile.dart';
import 'package:secondhand/views/widgets/custom_appbar.dart';
import 'package:secondhand/views/widgets/my_profile_email.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'components/contact_us_textfield.dart';
import 'components/profile_options.dart';
import 'components/select_language_bs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController msgCont = TextEditingController();
  bool agreeTerms = false;
  ContactUsService contactService = ContactUsService();

  @override
  Widget build(BuildContext context) {
    Locale appLocale = Localizations.localeOf(context);
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppbar(
                isProfileIcon: false,
                isBNBsection: true,
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 7,
              ),
              const MyProfileAndEmailWidget(),
              SizedBox(height: SizeConfig.heightMultiplier*2,),
              Container(
                width: SizeConfig.widthMultiplier * 90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200, width: 1.5),
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4,
                    bottom: SizeConfig.heightMultiplier * 0.5,
                    top: SizeConfig.heightMultiplier * 0.8),
                child: Column(
                  children: [
                    ProfileOptionsWidget(
                        title: AppLocalizations.of(context)!.account,
                        press: () {
                          Get.to(() => const EditProfilePage(),
                              transition: Transition.rightToLeft);
                        }),
                   
                    /*
                    ProfileOptionsWidget(
                        title: AppLocalizations.of(context)!.saved_searches,
                        press: () {
                          final authCont = Get.find<AuthController>();
        
                          Get.to(
                              () => SavedSearchesPage(
                                    uid: authCont.userInfo.id ?? "",
                                  ),
                              transition: Transition.rightToLeft);
                        }),
    
                     */
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => SelectLanguageBS());
                      },
                      child: SizedBox(
                        height: SizeConfig.heightMultiplier * 6,
                        width: SizeConfig.widthMultiplier * 100,
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.language,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF475569),
                                  fontSize: SizeConfig.textMultiplier * 2.1),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 3,
                              width: SizeConfig.widthMultiplier * 8,
                              child: WebsafeSvg.asset(
                                  "assets/icons/" + appLocale.languageCode + ".svg",
                                  fit: BoxFit.cover),
                            ),
                            SizedBox(
                              width: SizeConfig.widthMultiplier * 3,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             SizedBox(height: SizeConfig.heightMultiplier*5,),
              //contact us widget
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      builder: (context) => Container(
                            height: SizeConfig.heightMultiplier * 90,
                            width: SizeConfig.widthMultiplier * 100,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.widthMultiplier * 5),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 5,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.send_us_a_message,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeConfig.textMultiplier * 3,
                                        color: const Color(0xFF475569)),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 2,
                                  ),
                                  ContactUsTextField(
                                      title: AppLocalizations.of(context)!.name,
                                      hintText: AppLocalizations.of(context)!.your_name,
                                      controller: nameCont),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 2,
                                  ),
                                  ContactUsTextField(
                                      title: AppLocalizations.of(context)!.email,
                                      hintText: AppLocalizations.of(context)!.your_email,
                                      controller: emailCont),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 2,
                                  ),
                                  ContactUsTextField(
                                      title: AppLocalizations.of(context)!.message,
                                      hintText: AppLocalizations.of(context)!.write_something_here,
                                      controller: msgCont),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 1,
                                  ),
                                  Row(
                                    children: [
                                      StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Checkbox(
                                              activeColor: kPrimaryColor,
                                              value: agreeTerms,
                                              onChanged: (value) {
                                                setState(() {
                                                  agreeTerms = value ?? false;
                                                });
                                              });
                                        },
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.agree_terms_and_conditions,
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.textMultiplier * 1.6),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 1,
                                  ),
                                  SearchItemButton(
                                      title: AppLocalizations.of(context)!.send,
                                      isShuffleButton: false,
                                      press: () {
                                        if (agreeTerms) {
                                          contactService.sendMail(nameCont.text,
                                              emailCont.text, msgCont.text, context);
                                        }
                                      },
                                      isSellerProfile: false)
                                ],
                              ),
                            ),
                          ));
                },
                child: Container(
                  width: SizeConfig.widthMultiplier * 90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200, width: 1.5),
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 4,
                      bottom: SizeConfig.heightMultiplier * 0.6,
                      top: SizeConfig.heightMultiplier * 0.6),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.contact_us,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                            fontSize: SizeConfig.textMultiplier * 2.1),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios_rounded,
                              size: SizeConfig.heightMultiplier * 2,
                              color: const Color(0xFF94A3B8)))
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   height: SizeConfig.heightMultiplier * 1.5,
              // ),
              //logout widget
              InkWell(
                onTap: () {
                  Get.find<AuthController>().onSignOut();
                },
                child: Container(
                  width: SizeConfig.widthMultiplier * 90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200, width: 1.5),
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 4,
                      bottom: SizeConfig.heightMultiplier * 0.6,
                      top: SizeConfig.heightMultiplier * 0.6),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.logout,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                            fontSize: SizeConfig.textMultiplier * 2.1),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(FeatherIcons.logOut,
                              size: SizeConfig.heightMultiplier * 2,
                              color: const Color(0xFF94A3B8)))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 11,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
