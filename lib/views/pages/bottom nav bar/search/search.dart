import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/enums/articles_type.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/articles/articles.dart';
import 'package:secondhand/views/widgets/custom_appbar.dart';
import '../../../../controllers/search_controller.dart';
import 'components/categories_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchCont = TextEditingController();
  bool isSearch = false;
  bool isSearching = false;

  DateTime? comingDate;
  int? dateInMilliseconds;
  int? comingDateMilliseconds;
  late QuerySnapshot snapshotData;
  
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: SizeConfig.heightMultiplier * 100,
            width: SizeConfig.widthMultiplier * 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppbar(
                  isProfileIcon: false,
                  isBNBsection: true,
                ),
                //search text
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 6,
                      bottom: SizeConfig.heightMultiplier * 1.5,
                      top: SizeConfig.heightMultiplier * 2),
                  child: Text(
                    AppLocalizations.of(context)!.search,
                    style: TextStyle(
                        color: const Color(0xff475569),
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.textMultiplier * 5),
                  ),
                ),
                //search textfield
                Center(
                  child: Container(
                    width: SizeConfig.widthMultiplier * 90,
                    decoration: BoxDecoration(
                        color: klightGreyText.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(50)),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 5),
                    child: Row(
                      children: [
                        Image.asset(
                          searchIcon,
                          height: SizeConfig.heightMultiplier * 2.5,
                          color: const Color(0xff94A3B8),
                        ),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 2,
                        ),
                        GetBuilder<SearchController>(
                            init: SearchController(),
                            builder: (value) {
                              return Expanded(
                                  child: TextField(
                                controller: searchCont,
                                onChanged: (val) {
                                  if (val.isNotEmpty) {
                                    
                                    isSearch = true;
                                    value
                                        .queryData(searchCont.text, "Price")
                                        .then((value) {
                                      snapshotData = value;
                                      isSearching = true;
                                    });
                                  } else {
                                    isSearch = false;
                                  }
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: AppLocalizations.of(context)!
                                        .enter_keywords,
                                    hintStyle:
                                        TextStyle(color: Color(0xFF94A3B8))),
                              ));
                            })
                      ],
                    ),
                  ),
                ),
                isSearch
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier * 6,
                            bottom: SizeConfig.heightMultiplier * 1,
                            top: SizeConfig.heightMultiplier * 3),
                        child: Text(
                          AppLocalizations.of(context)!.categories,
                          style: TextStyle(
                              color: const Color(0xff475569),
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 3.7),
                        ),
                      ),
                isSearch
                    ? Center(
                        child: InkWell(
                          onTap: () => Get.to(() => ArticlesPage(
                                shuffleType: ShuffleType.search,
                                snapshotData: snapshotData,
                              )),
                          child: Container(
                            height: SizeConfig.heightMultiplier * 5,
                            width: SizeConfig.widthMultiplier * 90,
                            margin: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier * 2),
                            decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                "Search",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                isSearch ? const SizedBox() : CategoriesWidget(),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
