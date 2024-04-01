import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/controllers/search_controller.dart';
import 'package:secondhand/enums/articles_type.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/articles/articles.dart';
import 'package:secondhand/views/pages/bottom%20nav%20bar/home/components/search_item_button.dart';
import 'package:secondhand/views/widgets/custom_appbar.dart';
import 'package:secondhand/views/widgets/enable_location.dart';
import '../../../controllers/auth_controller.dart';

import '../../../controllers/search_places_controller.dart';
import '../../../controllers/selected_text_controller.dart';
import '../../../models/place.dart';
import '../../../services/places_service.dart';
import '../../widgets/show_loading.dart';
import 'components/price_textfield.dart';
import 'components/radio_button_distance.dart';
import 'components/show_free_items.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchFilterPage extends StatefulWidget {
  const SearchFilterPage({Key? key}) : super(key: key);

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  final allbuttonCont = Get.put(GlobalUIController());
  final authCont = Get.find<AuthController>();
  final avgWidth = SizeConfig.widthMultiplier * 87.5;

  //is search category

  //for google map
  bool isSearchLocation = false;
  GoogleMapController? mapController;
  @override
  void initState() {
    allInitState();
    super.initState();
  }

  allInitState() async {
    settingSavedFilter();
    locationCircleController();
    locationSubcription = selectedLocation.stream.listen((place) {
      //print("Result is ${place.toString()}");
      if (place.vicinity.isNotEmpty) {
        goToPlace(place);
      }
    });
    authCont.isLoading.value = false;
  }

  TextEditingController maxPriceCont = TextEditingController();
  TextEditingController searchCatCont = TextEditingController();

  //setting all values to the previous saved filter
  settingSavedFilter() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(Get.find<AuthController>().userss!.uid)
        .collection("SearchFilter")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        allbuttonCont.searchFilterlocationLat.value =
            value.docs[0]["LocationLat"];

        allbuttonCont.searchFilterlocationLng.value =
            value.docs[0]["LocationLng"] ?? 0.0;
        allbuttonCont.sliderValue.value =
            value.docs[0]["DistanceFilter"].toDouble() ?? 0.0;
        allbuttonCont.selectedCategoriesInSearchFilter.value =
            value.docs[0]["Categories"] ?? [];
        maxPriceCont.text = value.docs[0]["MaxPrice"] ?? "";
        allbuttonCont.priceGroupValue.value =
            value.docs[0]["LowestToHighestPrice"] == null
                ? -1
                : value.docs[0]["LowestToHighestPrice"]
                    ? 0
                    : 1;
        allbuttonCont.distanceGroupValue.value =
            value.docs[0]["LowestToHighestDistance"] == null
                ? -1
                : value.docs[0]["LowestToHighestDistance"]
                    ? 0
                    : 1;

        //print(value.docs[0]["ShowFree"]);
        allbuttonCont.grouValueFreeSwapItems.value =
            value.docs[0]["ShowFree"] == null ||
                    value.docs[0]["ShowFree"] == false
                ? -1
                : value.docs[0]["ShowFree"]
                    ? 0
                    : 1;
      }
    });
  }

  String searchVal = "";
  double heightOfCircle = 50;
  double widthOfCircle = 100;
  locationCircleController() {
    double multiplier = 0.7;
    if (allbuttonCont.sliderValue.value > 0 &&
        allbuttonCont.sliderValue.value < 5) {
      heightOfCircle = 90 * multiplier;
      widthOfCircle = 180 * multiplier;
    }
    if (allbuttonCont.sliderValue.value > 5 &&
        allbuttonCont.sliderValue.value < 10) {
      heightOfCircle = 100 * multiplier;
      widthOfCircle = 200 * multiplier;
    }
    if (allbuttonCont.sliderValue.value > 10 &&
        allbuttonCont.sliderValue.value < 15) {
      heightOfCircle = 110 * multiplier;
      widthOfCircle = 220 * multiplier;
    }
    if (allbuttonCont.sliderValue.value > 15 &&
        allbuttonCont.sliderValue.value < 20) {
      heightOfCircle = 150 * multiplier;
      widthOfCircle = 300 * multiplier;
    }
    if (allbuttonCont.sliderValue.value > 20 &&
        allbuttonCont.sliderValue.value < 25) {
      heightOfCircle = 180 * multiplier;
      widthOfCircle = 360 * multiplier;
    }
    if (allbuttonCont.sliderValue.value > 25 &&
        allbuttonCont.sliderValue.value < 30) {
      heightOfCircle = 200 * multiplier;
      widthOfCircle = 400 * multiplier;
    }
    if (allbuttonCont.sliderValue.value > 35 &&
        allbuttonCont.sliderValue.value < 40) {
      heightOfCircle = 300 * multiplier;
      widthOfCircle = 600 * multiplier;
    }
    if (allbuttonCont.sliderValue.value > 40 &&
        allbuttonCont.sliderValue.value < 45) {
      heightOfCircle = 400 * multiplier;
      widthOfCircle = 800 * multiplier;
    }
    if (allbuttonCont.sliderValue.value > 45 &&
        allbuttonCont.sliderValue.value < 50) {
      heightOfCircle = 600 * multiplier;
      widthOfCircle = 1200 * multiplier;
    }
  }

//FOR GOOGLE MAP
  Completer<GoogleMapController> mapCompleter = Completer();
  StreamSubscription? locationSubcription;
  final placesController = Get.find<PlacesSearchController>();
  TextEditingController locationCont = TextEditingController();
  StreamController<PlaceModel> selectedLocation =
      StreamController<PlaceModel>();
  @override
  void dispose() {
    super.dispose();
    allbuttonCont.sliderValue.value = 0.0;
    locationSubcription?.cancel();
  }

//METHODS FOR GOOGLE MAP AUTOCOMPLETE
  Future<void> goToPlace(PlaceModel place) async {
    locationCont.text = place.name;
    final GoogleMapController controller = await mapCompleter.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
                place.geometery.location.lat, place.geometery.location.lng),
            zoom: 10)))
        .then((value) {
      allbuttonCont.searchFilterlocationLat.value =
          place.geometery.location.lat;
      allbuttonCont.searchSaveFilterLat.value = place.geometery.location.lat;
      allbuttonCont.searchFilterlocationLng.value =
          place.geometery.location.lng;
      allbuttonCont.searchSaveFilterLng.value = place.geometery.location.lng;
    });
  }

  setSelectedLocation(String placeID) async {
    final placesServices = PlacesService();
    selectedLocation.add(await placesServices.getPlace(placeID));
    setState(() {});
  }

/////////////////////////////////////////BODY///////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    //print("This is latitude : ${allbuttonCont.searchFilterlocationLat.value}");

    return Obx(() => ShowLoading(
        child: searchFilterUI(context),
        inAsyncCall: authCont.isLoading.value));
  }

  Widget searchFilterUI(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    String nameVariable = (myLocale.languageCode == 'en') ? "name" : "name_de";

    return Obx(() => MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppbar(isProfileIcon: false),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 6,
                        right: SizeConfig.widthMultiplier * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isSearchLocation
                            ? const SizedBox()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.location_range,
                                    style: TextStyle(
                                        color: const Color(0xff475569),
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            SizeConfig.textMultiplier * 3.2),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isSearchLocation = true;
                                        });
                                      },
                                      icon: Image.asset(
                                        searchIcon,
                                        height: SizeConfig.heightMultiplier * 3,
                                        color: const Color(0xff475569),
                                      ))
                                ],
                              ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: SizeConfig.widthMultiplier * 4),
                          child: Divider(
                            height: SizeConfig.heightMultiplier * 0.5,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 1.5,
                        ),
                      Obx(
                        ()=>!authCont.isLocationPermission.value?SizedBox():  isSearchLocation
                              ? Container(
                                  width: SizeConfig.widthMultiplier * 90,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: kSecondaryColor),
                                      borderRadius: BorderRadius.circular(50)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.widthMultiplier * 3),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        searchIcon,
                                        height: SizeConfig.heightMultiplier * 2.5,
                                        color: const Color(0xff94A3B8),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.widthMultiplier * 3,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: locationCont,
                                          onChanged: (value) {
                                            placesController.searchPlaces(value);
                                            setState(() {});
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .enter_neighbourhood,
                                              hintStyle: TextStyle(
                                                  color: Color(0xFF94A3B8))),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                      ),
                        SizedBox(height: SizeConfig.heightMultiplier * 2),
                        //map widget
                      Obx(
                        ()=>!authCont.isLocationPermission.value?EnableLocationWidget():  SizedBox(
                            height: SizeConfig.heightMultiplier * 30,
                            width: avgWidth,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                    height: SizeConfig.heightMultiplier * 30,
                                    width: SizeConfig.widthMultiplier * 90,
                                    decoration: BoxDecoration(boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 8)
                                    ], borderRadius: BorderRadius.circular(10)),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: GoogleMap(
                                            mapType: MapType.normal,
                                            myLocationEnabled: true,
                                            zoomControlsEnabled: false,
                                            onMapCreated:
                                                (GoogleMapController cont) {
                                              mapCompleter.complete(cont);
                                            },
                                            initialCameraPosition: CameraPosition(
                                                zoom: 10,
                                                target: LatLng(
                                                  allbuttonCont
                                                              .searchFilterlocationLat
                                                              .value ==
                                                          0.0
                                                      ? authCont.userLat.value
                                                      : allbuttonCont
                                                          .searchFilterlocationLat
                                                          .value,
                                                  allbuttonCont
                                                              .searchFilterlocationLng
                                                              .value ==
                                                          0.0
                                                      ? authCont.userLng.value
                                                      : allbuttonCont
                                                          .searchFilterlocationLng
                                                          .value,
                                                ))))),
                                //location slider controller
                                AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  height: heightOfCircle,
                                  width: widthOfCircle,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: kPrimaryColor),
                                      shape: BoxShape.circle,
                                      color: kPrimaryColor.withOpacity(0.2)),
                                ),
                                //search predictions
                                placesController.searchResults != null &&
                                        placesController.searchResults!.isNotEmpty
                                    ? Container(
                                        height: SizeConfig.heightMultiplier * 30,
                                        width: SizeConfig.widthMultiplier * 90,
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            backgroundBlendMode: BlendMode.darken,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 8)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.widthMultiplier * 5),
                                        child: ListView.builder(
                                            padding: EdgeInsets.only(
                                                top: SizeConfig.heightMultiplier *
                                                    2),
                                            itemCount: placesController
                                                .searchResults?.length,
                                            itemBuilder: (_, i) {
                                              return InkWell(
                                                onTap: () {
                                                  setSelectedLocation(
                                                      placesController
                                                          .searchResults![i]
                                                          .placeID);
                                                  placesController.searchResults =
                                                      null;
                                                  locationCont.clear();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: SizeConfig
                                                              .heightMultiplier *
                                                          2),
                                                  child: Text(
                                                      placesController
                                                              .searchResults?[i]
                                                              .description ??
                                                          "",
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              );
                                            }),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                      ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 1,
                  ),
                  //location slider
               Obx(
                 ()=> !authCont.isLocationPermission.value?SizedBox():   SizedBox(
                        height: SizeConfig.heightMultiplier * 3,
                        child: SliderTheme(
                          data: const SliderThemeData(),
                          child: Slider(
                            min: 0,
                            max: 50,
                            value: allbuttonCont.sliderValue.value,
                            onChanged: (value) {
                              allbuttonCont.sliderValue.value = value;
                              locationCircleController();
                            },
                            thumbColor: kPrimaryColor,
                            inactiveColor: Colors.grey.shade100,
                            activeColor: kPrimaryColor,
                          ),
                        )),
               ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 6),
                    child: Row(
                      children: [
                        Text(
                          "${allbuttonCont.sliderValue.value.toInt()} km",
                          style: TextStyle(
                              color: const Color(0xff475569),
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 1.8),
                        ),
                        const Spacer(),
                        Text(
                          "50 km",
                          style: TextStyle(
                              color: const Color(0xff475569),
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 1.8),
                        )
                      ],
                    ),
                  ),
    
                  //categories
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 3,
                        left: SizeConfig.widthMultiplier * 6,
                        right: SizeConfig.widthMultiplier * 2),
                    child: allbuttonCont.isSearchCat.value
                        ?
                        //if he is searching
                        Container(
                            width: SizeConfig.widthMultiplier * 87,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: const Color(0xff475569),
                                )),
                            padding: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier * 2,
                                bottom: SizeConfig.heightMultiplier * 0.3,
                                left: SizeConfig.widthMultiplier * 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  searchIcon,
                                  height: SizeConfig.heightMultiplier * 3,
                                  color: const Color(0xff475569),
                                ),
                                SizedBox(
                                  width: SizeConfig.widthMultiplier * 2,
                                ),
                                Expanded(
                                    child: TextField(
                                  controller: searchCatCont,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    searchVal = value;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Write the category name",
                                      hintStyle: TextStyle(
                                        fontSize: SizeConfig.textMultiplier * 1.8,
                                        color: const Color(0xFF475569),
                                      )),
                                ))
                              ],
                            ),
                          )
                        :
                        //if he is not searching
                        Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.categories,
                                    style: TextStyle(
                                        color: const Color(0xff475569),
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            SizeConfig.textMultiplier * 3.2),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        allbuttonCont.isSearchCat.value = true;
                                      },
                                      icon: Image.asset(
                                        searchIcon,
                                        height: SizeConfig.heightMultiplier * 3,
                                        color: const Color(0xff475569),
                                      ))
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: SizeConfig.widthMultiplier * 4),
                                child: Divider(
                                  height: SizeConfig.heightMultiplier * 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: searchVal.isEmpty
                          ? FirebaseFirestore.instance
                              .collection("Categories")
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection("Categories")
                              .where(nameVariable,
                                  isGreaterThanOrEqualTo: searchCatCont.text)
                              .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState == ConnectionState.waiting
                            ? Loading()
                            : GridView.count(
                                physics: const BouncingScrollPhysics(),
                                childAspectRatio: 4,
                                //itemCount: snapshot.data?.docs.length,
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                children: List.generate(
                                    snapshot.data?.docs.length ?? 0,
                                    (index) => Row(
                                          children: [
                                            Obx(
                                              () => IconButton(
                                                  onPressed: () {
                                                    if (allbuttonCont
                                                        .selectedCategoriesInSearchFilter
                                                        .contains(snapshot
                                                            .data?.docs[index]
                                                            .get(nameVariable))) {
                                                      allbuttonCont
                                                          .selectedCategoriesInSearchFilter
                                                          .remove(snapshot
                                                              .data?.docs[index]
                                                              .get(nameVariable));
                                                    } else {
                                                      allbuttonCont
                                                          .selectedCategoriesInSearchFilter
                                                          .add(snapshot
                                                              .data?.docs[index]
                                                              .get(nameVariable));
                                                    }
                                                  },
                                                  icon: SizedBox(
                                                    height: 21,
                                                    width: 22,
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          bottom: 2,
                                                          child: Container(
                                                            height: 18,
                                                            width: 18,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                                border: Border.all(
                                                                    color: allbuttonCont.selectedCategoriesInSearchFilter.contains(snapshot
                                                                            .data
                                                                            ?.docs[
                                                                                index]
                                                                            .get(
                                                                                nameVariable))
                                                                        ? kPrimaryColor
                                                                        : const Color(
                                                                            0xFF94A3B8),
                                                                    width: 1.5)),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 1,
                                                          left: 1,
                                                          child: allbuttonCont
                                                                  .selectedCategoriesInSearchFilter
                                                                  .contains(snapshot
                                                                      .data
                                                                      ?.docs[
                                                                          index]
                                                                      .get(
                                                                          nameVariable))
                                                              ? Icon(
                                                                  Icons.close,
                                                                  color:
                                                                      kSecondaryColor,
                                                                  size: 16,
                                                                )
                                                              : const SizedBox(),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            Text(
                                              snapshot.data?.docs[index]
                                                  .get(nameVariable),
                                              style: TextStyle(
                                                  fontSize:
                                                      SizeConfig.textMultiplier *
                                                          1.6),
                                            )
                                          ],
                                        )));
                      }),
    
                  //sort by
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 2,
                        left: SizeConfig.widthMultiplier * 6,
                        right: SizeConfig.widthMultiplier * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.sort_by,
                          //"Sort by",
                          style: TextStyle(
                              color: const Color(0xff475569),
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 3.2),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: SizeConfig.heightMultiplier * 1,
                              top: SizeConfig.heightMultiplier * 1,
                              right: SizeConfig.widthMultiplier * 4),
                          child: Divider(
                            height: SizeConfig.heightMultiplier * 0.5,
                          ),
                        ),
                        //price
                      ],
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RadioButtonDistanceOrPrice(
                            press: () {
                              allbuttonCont.priceGroupValue.value = 0;
                            },
                            changeValue: allbuttonCont.priceGroupValue.value,
                            equalValue: 0,
                            title:
                                AppLocalizations.of(context)!.lowest_to_heighest
                            //"Highest to lowest"
                            ),
                        const Spacer(),
                        RadioButtonDistanceOrPrice(
                            press: () {
                              allbuttonCont.priceGroupValue.value = 1;
                            },
                            changeValue: allbuttonCont.priceGroupValue.value,
                            equalValue: 1,
                            title:
                                AppLocalizations.of(context)!.highest_to_lowest),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 3,
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 6),
                      child: Text(
                        AppLocalizations.of(context)!.price,
                        style: TextStyle(
                            color: const Color(0xff475569),
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.textMultiplier * 2),
                      )),
                  //set max price field
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 6),
                      child: PriceTextField(maxPriceCont: maxPriceCont)),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),
                  //distance
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 6),
                    child: Text(
                      AppLocalizations.of(context)!.distance,
                      style: TextStyle(
                          color: const Color(0xff475569),
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.textMultiplier * 2),
                    ),
                  ),
                  SizedBox(
                      width: SizeConfig.widthMultiplier * 90,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RadioButtonDistanceOrPrice(
                                press: () {
                                  allbuttonCont.distanceGroupValue.value = 0;
                                },
                                changeValue:
                                    allbuttonCont.distanceGroupValue.value,
                                equalValue: 0,
                                title: AppLocalizations.of(context)!
                                    .shortest_to_longest),
                            const Spacer(),
                            RadioButtonDistanceOrPrice(
                                press: () {
                                  allbuttonCont.distanceGroupValue.value = 1;
                                },
                                changeValue:
                                    allbuttonCont.distanceGroupValue.value,
                                equalValue: 1,
                                title: AppLocalizations.of(context)!
                                    .longest_to_shortest),
                          ])),
                  //show free items and show swapping items
                  ShowFreeItemsWidget(
                      press: () {
                        if (allbuttonCont.grouValueFreeSwapItems.value == 0) {
                          allbuttonCont.grouValueFreeSwapItems.value = -1;
                        } else {
                          allbuttonCont.grouValueFreeSwapItems.value = 0;
                        }
                      },
                      equalValue: 0,
                      changeValue: allbuttonCont.grouValueFreeSwapItems.value,
                      title: AppLocalizations.of(context)!.show_free_items),
                  ShowFreeItemsWidget(
                      press: () {
                        if (allbuttonCont.grouValueFreeSwapItems.value == 1) {
                          allbuttonCont.grouValueFreeSwapItems.value = -1;
                        } else {
                          allbuttonCont.grouValueFreeSwapItems.value = 1;
                        }
                      },
                      equalValue: 1,
                      changeValue: allbuttonCont.grouValueFreeSwapItems.value,
                      title: AppLocalizations.of(context)!.show_swapping_items),
    
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),
                  //Search button
                  SearchItemButton(
                      title: AppLocalizations.of(context)!.search,
                      isShuffleButton: false,
                      isSellerProfile: false,
                      press: () async {
                        //print("Hello ${allbuttonCont.searchSaveFilterLng.value}");
                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(Get.find<AuthController>().userss!.uid)
                            .collection("SearchFilter")
                            .doc("K7IIzI764EOiqSakEYXJ")
                            .set({
                          "LocationLat":
                              allbuttonCont.searchFilterlocationLat.value == 0.0
                                  ? authCont.userLat.value
                                  : allbuttonCont.searchSaveFilterLat.value,
                          "LocationLng":
                              allbuttonCont.searchFilterlocationLng.value == 0.0
                                  ? authCont.userLng.value
                                  : allbuttonCont.searchSaveFilterLng.value,
                          "DistanceFilter":
                              allbuttonCont.sliderValue.value.toInt(),
                          "Categories": allbuttonCont
                              .selectedCategoriesInSearchFilter.value,
                          "MaxPrice":
                              maxPriceCont.text.isEmpty ? "0" : maxPriceCont.text,
                          "LowestToHighestPrice":
                              allbuttonCont.priceGroupValue.value == 0
                                  ? true
                                  : false,
                          "LowestToHighestDistance":
                              allbuttonCont.distanceGroupValue.value == 0
                                  ? true
                                  : false,
                          "ShowFree":
                              allbuttonCont.grouValueFreeSwapItems.value == 0
                                  ? true
                                  : false,
                        }).then((value) {
                          Get.back();
                        }).then((value) {
                          final searchCont = Get.put(SearchController());
                          searchCont.queryData(" ", "Price").then((value) {
                            Get.to(() => ArticlesPage(
                                  shuffleType: ShuffleType.search,
                                  snapshotData: value,
                                ));
                          });
                        });
                      }),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  )
                ],
              ),
            ),
          ),
    ));
  }
}
