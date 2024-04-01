import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../controllers/selected_text_controller.dart';

class CategoriesBottomSheet extends StatefulWidget {
  const CategoriesBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoriesBottomSheet> createState() => _CategoriesBottomSheetState();
}

class _CategoriesBottomSheetState extends State<CategoriesBottomSheet> {
 

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    String nameVariable =  (myLocale.languageCode == 'en') ? "name" : "name_de";
    final globalCont = Get.find<GlobalUIController>();

    return Container(
      height: SizeConfig.heightMultiplier * 95,
      width: SizeConfig.widthMultiplier * 100,
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: WebsafeSvg.asset(cancelIcon,
                  color: const Color(0xFF94A3B8))),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 5),
            child: Text(
              AppLocalizations.of(context)!.select_a_category,
              //"Select a category",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.heightMultiplier * 3.5,
                  color: const Color(0xFF475569)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 5),
            child: Divider(
              color: Colors.grey.shade200,
              thickness: 1.5,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Categories").snapshots(),
            builder: (context, snapshot) {
              return snapshot.connectionState==ConnectionState.waiting? Loading():
              GridView.count(
                  physics: const BouncingScrollPhysics(),
                  childAspectRatio: 4,
                  //itemCount: snapshot.data?.docs.length,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: List.generate(snapshot.data?.docs.length ?? 0, (index) => Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: IconButton(
                                  onPressed: () {
                                    if (!globalCont.selectedCategory.contains(snapshot.data?.docs[index].get(nameVariable))) {
                                      globalCont.selectedCategory.add(snapshot.data?.docs[index].get(nameVariable));
                                    } else {
                                      globalCont.selectedCategory.remove(snapshot.data?.docs[index].get(nameVariable));
                                    }
                                  },
                                  icon: Obx(
                                    () => Container(
                                      height: 20,
                                      width: 18,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            bottom: 2,
                                            child: Container(
                                              height: 18,
                                              width: 18,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  border: Border.all(
                                                      color: globalCont
                                                              .selectedCategory
                                                              .contains(
                                                                  snapshot.data?.docs[index].get(nameVariable))
                                                          ? kPrimaryColor
                                                          : Color(0xFF94A3B8),
                                                      width: 1.5)),
                                            ),
                                          ),
                                          Positioned(
                                            top: 1,
                                            left: 1,
                                            child: globalCont.selectedCategory
                                                    .contains(snapshot.data?.docs[index].get(nameVariable))
                                                ? Icon(
                                                    Icons.close,
                                                    color: kSecondaryColor,
                                                    size: 16,
                                                  )
                                                : const SizedBox(),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            Flexible(
                                child: Text(
                             snapshot.data?.docs[index].get(nameVariable),
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 1.9),
                            ))
                          ],
                        ),
                      )));
            }
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 5),
          Center(
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: SizeConfig.heightMultiplier * 4.8,
                width: SizeConfig.widthMultiplier * 90,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.next,
                        //"Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 2,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 12,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
