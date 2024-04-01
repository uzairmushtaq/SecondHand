// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/services/geo_locator.dart';
import 'package:secondhand/services/places_service.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/enable_location.dart';
import 'package:secondhand/views/widgets/next_button.dart';
import 'package:secondhand/views/widgets/custom_appbar.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import 'package:websafe_svg/websafe_svg.dart';
import '../../../constants/icons.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/search_places_controller.dart';
import '../../../controllers/selected_text_controller.dart';
import '../../../models/place.dart';
import '../../../services/database.dart';
import '../../bottom sheets/categories_bs.dart';
import '../order summary/order_summary.dart';
import 'components/custom_radio_buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geocoding/geocoding.dart';

import 'components/selected_categories.dart';
import 'components/title_textfield.dart';

class CreateAnAdPage extends StatefulWidget {
  const CreateAnAdPage({Key? key}) : super(key: key);

  @override
  State<CreateAnAdPage> createState() => _CreateAnAdPageState();
}

class _CreateAnAdPageState extends State<CreateAnAdPage> {
  TextEditingController titleCont = TextEditingController();
  TextEditingController desCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  TextEditingController locationCont = TextEditingController();

  int industrialSupplier = -1;
  List<String> selectedCategories = [];
  final userCont = Get.find<AuthController>();
  final globalCont = Get.find<GlobalUIController>();

  //selecting images
  void selectingImages() async {
    final act = CupertinoActionSheet(
        title: Text(AppLocalizations.of(context)!.photo),
        actions: <Widget>[
          CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.camera),
              onPressed: () async {
                var pickedImage =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                globalCont.uploadImages.value.add(File(pickedImage!.path));
                setState(() {});
                if (Get.find<GlobalUIController>()
                        .progressBarOfArticleData
                        .value <=
                    90) {
                  Get.find<GlobalUIController>()
                          .progressBarOfArticleData
                          .value +
                      10;
                }

                // If the widget was removed from the tree while the asynchronous platform
                // message was in flight, we want to discard the reply rather than calling
                // setState to update our non-existent appearance.
                if (!mounted) return;

                setState(() {});
                Navigator.of(context, rootNavigator: true).pop("Discard");
              }),
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.gallery),
            onPressed: () async {
              final pickedImage =
                  await ImagePicker().pickImage(source: ImageSource.gallery);

              globalCont.uploadImages.value.add(File(pickedImage!.path));
              setState(() {});
              if (Get.find<GlobalUIController>()
                      .progressBarOfArticleData
                      .value <=
                  90) {
                Get.find<GlobalUIController>().progressBarOfArticleData.value +
                    10;
              }

              // If the widget was removed from the tree while the asynchronous platform
              // message was in flight, we want to discard the reply rather than calling
              // setState to update our non-existent appearance.
              if (!mounted) return;

              setState(() {});
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('abbrechen'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },
        ));
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => act).then((value) async {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {});
    });
  }

  //for getting current location
  final geoLocationService = GeoLocatorService();

  bool isLoadingMap = true;
  setCurrentLocation() async {
    globalCont.articleLatitude.value = userCont.userLat.value;
    globalCont.articleLongitude.value = userCont.userLng.value;
    List<Placemark> placemarks = await placemarkFromCoordinates(
        userCont.userLat.value, userCont.userLng.value);
    Placemark placemark = placemarks[0];
    //print(placemark);
    locationCont.text = placemark.thoroughfare! + ", " + placemark.locality!;
    globalCont.locationofArticle.value =
        placemark.thoroughfare! + ", " + placemark.locality!;
  }

  //for google map
  //VARIABLES
  Completer<GoogleMapController> mapCompleter = Completer();
  late StreamSubscription locationSubcription;
  late GoogleMapController mapController;

  ///create map controller
  void onMapCreated(GoogleMapController controller) {
    if (!mapCompleter.isCompleted) {
      mapCompleter.complete(controller);
    }
  }

  final placesController = Get.find<PlacesSearchController>();

  StreamController<PlaceModel> selectedLocation =
      StreamController<PlaceModel>();
  @override
  void initState() {
    //locationLat = 51.1657;
    //locationLng = 10.4515;
    setCurrentLocation();
    isLoadingMap = false;
    locationSubcription = selectedLocation.stream.listen((place) {
      //print("Result is ${place.toString()}");
      if (place.vicinity.isNotEmpty) {
        goToPlace(place);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero, () {
      globalCont.selectedCategory.value = [];
      globalCont.uploadImages.value = [];
      globalCont.progressBarOfArticleData.value = 10.0;
      globalCont.industrialSupplierCheckBox.value = false;
      selectedLocation.close();
      locationSubcription.cancel();
    });
    super.dispose();
  }

//METHODS FOR GOOGLE MAP AUTOCOMPLETE
  Future<void> goToPlace(PlaceModel place) async {
    final GoogleMapController controller = await mapCompleter.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
                place.geometery.location.lat, place.geometery.location.lng),
            zoom: 14)))
        .then((value) {
      globalCont.articleLatitude.value = place.geometery.location.lat;
      globalCont.articleLongitude.value = place.geometery.location.lng;
      locationCont.text = place.name;
      globalCont.locationofArticle.value = place.name;
    });
  }

  setSelectedLocation(String placeID) async {
    final placesServices = PlacesService();
    selectedLocation.add(await placesServices.getPlace(placeID));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ShowLoading(
          child: createAdUI(context), inAsyncCall: authCont.isLoading.value),
    );
  }

  Widget createAdUI(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              const CustomAppbar(isProfileIcon: false),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2.5,
                    ),
                    Container(
                      height: SizeConfig.heightMultiplier * 1,
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ]),
                      //PROGRESS BAR
                      child: Obx(
                        () => FAProgressBar(
                          animatedDuration: const Duration(seconds: 1),
                          currentValue:
                              globalCont.progressBarOfArticleData.value,
                          backgroundColor: const Color(0xFFCBD5E1),
                          progressColor: kPrimaryColor,
                          displayTextStyle:
                              const TextStyle(color: kPrimaryColor),
                          displayText: '%',
                          borderRadius: BorderRadius.circular(12 * 2),
                        ),
                      ),
                    ),
                    //TITLE
                    TitleTextFieldWidget(
                        controller: titleCont,
                        title: AppLocalizations.of(context)!.title),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2.5,
                    ),
                    Divider(
                      color: Colors.grey.shade200,
                      thickness: 1.5,
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 3,
                    ),
                    //CATEGORY
                    Text(
                      AppLocalizations.of(context)!.category, //"Category",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.heightMultiplier * 3.5,
                          color: const Color(0xFF475569)),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1.5,
                    ),
                    //SELECTED CATEGORIES
                    SelectedCategoriesWidget(),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1.5,
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            builder: (context) =>
                                const CategoriesBottomSheet());
                        if (Get.find<GlobalUIController>()
                                .progressBarOfArticleData
                                .value <=
                            30) {
                          Get.find<GlobalUIController>()
                                  .progressBarOfArticleData
                                  .value +
                              10;
                        }
                      },
                      child: Container(
                        height: SizeConfig.heightMultiplier * 5.7,
                        width: SizeConfig.widthMultiplier * 90,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.categories,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    fontWeight: FontWeight.w600)),
                            const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: Colors.white,
                              size: 19,
                            )
                          ],
                        ),
                      ),
                    ),
                    //PRICE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TitleTextFieldWidget(
                              title: AppLocalizations.of(context)!.price,
                              controller: priceCont),
                        ),
                        //CURRENCYBUTTON
                        SelectCurrency()
                      ],
                    ),
                    const CustomRadioPriceButtons(),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2.5,
                    ),
                    Divider(
                      color: Colors.grey.shade200,
                      thickness: 1.5,
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 3,
                    ),
                    //DESCRIPTION
                    Text(
                      AppLocalizations.of(context)!.description,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.heightMultiplier * 3.5,
                          color: const Color(0xFF475569)),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1.5,
                    ),
                    //LOCATION
                    Container(
                      height: SizeConfig.heightMultiplier * 12,
                      width: SizeConfig.widthMultiplier * 90,
                      decoration: BoxDecoration(
                          border: Border.all(color: kSecondaryColor),
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 5),
                      child: TextField(
                        maxLines: 5,
                        controller: desCont,
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            if (Get.find<GlobalUIController>()
                                    .progressBarOfArticleData
                                    .value <=
                                50) {
                              Get.find<GlobalUIController>()
                                      .progressBarOfArticleData
                                      .value +
                                  10;
                            }
                          }
                        },
                        decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!
                                .write_short_description,
                            //"Write a short and captivating\ndescription....",
                            hintMaxLines: 2,
                            hintStyle: TextStyle(color: Color(0xFF94A3B8))),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2.5,
                    ),
                    Divider(
                      color: Colors.grey.shade200,
                      thickness: 1.5,
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 3,
                    ),
                    Text(
                      AppLocalizations.of(context)!.location,
                      //"Location",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.heightMultiplier * 3.5,
                          color: const Color(0xFF475569)),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1.5,
                    ),
                    Obx(
                      () => !userCont.isLocationPermission.value
                          ? EnableLocationWidget()
                          : Container(
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
                                        if (Get.find<GlobalUIController>()
                                                .progressBarOfArticleData
                                                .value <=
                                            70) {
                                          Get.find<GlobalUIController>()
                                                  .progressBarOfArticleData
                                                  .value +
                                              10;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .enter_neighbourhood,
                                          //"Enter neighbuorhood or area",
                                          hintStyle: TextStyle(
                                              color: Color(0xFF94A3B8))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    //map widget
                    Obx(
                      () => !userCont.isLocationPermission.value
                          ? const SizedBox()
                          : Stack(
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
                                                (GoogleMapController cont) =>
                                                    onMapCreated(cont),
                                            initialCameraPosition:
                                                CameraPosition(
                                                    zoom: 15,
                                                    target: LatLng(
                                                      userCont.userLat.value,
                                                      userCont.userLng.value,
                                                    ))))),
                                //search predictions
                                placesController.searchResults != null &&
                                        placesController
                                            .searchResults!.isNotEmpty
                                    ? Container(
                                        height:
                                            SizeConfig.heightMultiplier * 30,
                                        width: SizeConfig.widthMultiplier * 90,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            backgroundBlendMode:
                                                BlendMode.darken,
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
                                                top: SizeConfig
                                                        .heightMultiplier *
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
                                                  placesController
                                                      .searchResults = null;
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
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2.5,
                    ),
                    Divider(
                      color: Colors.grey.shade200,
                      thickness: 1.5,
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 3,
                    ),
                    Text(
                      AppLocalizations.of(context)!.photos,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.heightMultiplier * 3.5,
                          color: const Color(0xFF475569)),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1.5,
                    ),
                  ],
                ),
              ),
              //Images part
              Obx(
                () => Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    ...List.generate(
                        globalCont.uploadImages.value.length,
                        (index) => Container(
                            height: SizeConfig.heightMultiplier * 23,
                            width: SizeConfig.widthMultiplier * 44,
                            margin: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier * 3,
                                top: SizeConfig.heightMultiplier * 2),
                            decoration: BoxDecoration(
                                color: const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(12)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                    globalCont.uploadImages.value[index],
                                    fit: BoxFit.cover)))),
                    InkWell(
                      onTap: selectingImages,
                      child: Container(
                        height: SizeConfig.heightMultiplier * 23,
                        width: SizeConfig.widthMultiplier * 44,
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier * 2),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: WebsafeSvg.asset("assets/icons/plus.svg",
                              height: SizeConfig.heightMultiplier * 6,
                              color: const Color(0xFF475569)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 3,
              ),
              //INDUSTRIAL SUPPLIER CHECKBOX
              IndustrialSupplierCheckBox(globalCont: globalCont),
              SizedBox(
                height: SizeConfig.heightMultiplier * 1,
              ),
              NextButton(
                  title: AppLocalizations.of(context)!.next,
                  color: kSecondaryColor,
                  borderColor: klightGreen,
                  textColor: Colors.white,
                  icon: Icons.arrow_forward_ios_rounded,
                  press: () {
                    if (globalCont.uploadImages.value.length != 0) {
                      if (titleCont.text.isNotEmpty &&
                          globalCont.selectedCategory.value.isNotEmpty &&
                          priceCont.text.isNotEmpty &&
                          globalCont.articleLatitude.value != 0.0 &&
                          globalCont.articleLongitude.value != 0.0 &&
                          desCont.text.isNotEmpty) {
                        String goodTitle =
                            titleCont.text[0].substring(0).toUpperCase() +
                                titleCont.text.substring(1).toLowerCase();
                        globalCont.titleOfArticle.value = goodTitle;
                        globalCont.descriptionOfArticle.value = desCont.text;
                        globalCont.priceOfArticle.value = priceCont.text;
                        Locale appLocale = Localizations.localeOf(context);

                        DataBase()
                            .addingArticle(
                                Get.find<AuthController>().userInfo?.id ?? "",
                                globalCont.titleOfArticle.value,
                                globalCont.selectedCategory.value,
                                globalCont.descriptionOfArticle.value,
                                globalCont.priceOfArticle.value,
                                globalCont.isFreePrice.value,
                                globalCont.locationofArticle.value,
                                globalCont.articleLatitude.value,
                                globalCont.articleLongitude.value,
                                globalCont.uploadImages.value,
                                globalCont.industrialSupplierCheckBox.value,
                                appLocale.languageCode)
                            .then((value) {
                          Get.to(
                              () => OrderSummaryPage(
                                    isRepost: false,
                                    numberOfPhotos:
                                        globalCont.uploadImages.value.length,
                                  ),
                              transition: Transition.leftToRight,
                              duration: const Duration(seconds: 1));
                        });
                      } else {
                        Get.snackbar(
                          AppLocalizations.of(context)!.error, //'Error',
                          AppLocalizations.of(context)!
                              .fill_all_blanks, //'Fill all the blanks',
                        );
                      }
                    } else {
                      Get.snackbar(
                        AppLocalizations.of(context)!.error, //'Error',
                        AppLocalizations.of(context)!
                            .pick_image, //'Pick a image',
                      );
                    }
                  }),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2.5,
              ),
              NextButton(
                  title: AppLocalizations.of(context)!.go_back,
                  color: Colors.white,
                  borderColor: kSecondaryColor,
                  textColor: klightGreen,
                  icon: Icons.arrow_back_ios_new_rounded,
                  press: () {
                    Get.back();
                  }),
              SizedBox(
                height: SizeConfig.heightMultiplier * 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SelectCurrency extends StatelessWidget {
  SelectCurrency({
    Key? key,
  }) : super(key: key);
  List<String> currencySymbols = [
    '\$',
    '€',
    '¥',
    '£',
    '₹',
    '₽',
    '₪',
    '฿',
    '₺',
    '₩',
    '₴',
    '₦',
    '₡',
    '₲',
    '₮',
    '₸',
    '₱',
    '₭',
    '₣',
    '₵',
    '₫',
    '₥',
    '₨',
    '₳',
  ];
  final cont = Get.find<GlobalUIController>();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: SizeConfig.widthMultiplier * 6),
        Obx(() => Text(
              cont.selectedCurrency.value,
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
        PopupMenuButton(
          icon: Icon(Icons.arrow_drop_down_rounded),
          itemBuilder: (_) => [
            for (int i = 0; i < currencySymbols.length; i++) ...[
              PopupMenuItem(child: Text(currencySymbols[i]), value: i)
            ]
          ],
          onSelected: (val) {
            for (int i = 0; i < currencySymbols.length; i++) {
              if (val == i) {
                cont.selectedCurrency.value = currencySymbols[i];
              }
            }
          },
        ),
      ],
    );
  }
}

class IndustrialSupplierCheckBox extends StatelessWidget {
  const IndustrialSupplierCheckBox({
    Key? key,
    required this.globalCont,
  }) : super(key: key);

  final GlobalUIController globalCont;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          SizedBox(
            width: SizeConfig.widthMultiplier * 3,
          ),
          IconButton(
            onPressed: () {
              globalCont.industrialSupplierCheckBox.value =
                  !globalCont.industrialSupplierCheckBox.value;
            },
            icon: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: SizeConfig.heightMultiplier * 2.5,
                width: SizeConfig.widthMultiplier * 5.5,
                decoration: BoxDecoration(
                    color: globalCont.industrialSupplierCheckBox.value
                        ? kPrimaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    border: globalCont.industrialSupplierCheckBox.value
                        ? null
                        : Border.all(color: const Color(0xFF94A3B8), width: 1)),
                child: globalCont.industrialSupplierCheckBox.value
                    ? Icon(Icons.done,
                        color: Colors.white,
                        size: SizeConfig.textMultiplier * 2)
                    : SizedBox()),
          ),
          Text(
            AppLocalizations.of(context)!.industrial_supplier,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.textMultiplier * 1.6),
          ),
        ],
      ),
    );
  }
}
