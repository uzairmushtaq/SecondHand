import 'package:get/get.dart';

class GlobalUIController extends GetxController {
  RxList selectedCategory = [].obs;
  RxMap catCount={}.obs;
  RxBool isFreePrice = false.obs;
  RxBool translationLoading=false.obs;
  RxString priceOfArticle = "".obs;
  RxString titleOfArticle = "".obs;
  RxString descriptionOfArticle = "".obs;
  RxString locationofArticle = "".obs;
  RxList uploadImages = [].obs;
  RxList uploadMessageImages = [].obs;
  RxDouble articleLatitude = 0.0.obs;
  RxDouble articleLongitude = 0.0.obs;
  RxBool isRecorder = false.obs;
  RxString selectedCurrency='\$'.obs;
  RxString rePostAdid = "".obs;
  RxDouble progressBarOfArticleData = 10.0.obs;
  RxString articleID = "".obs;
  RxBool industrialSupplierCheckBox=false.obs;
  //for searchFilter
  RxInt grouValueFreeSwapItems = (-1).obs;
  RxList selectedCategoriesInSearchFilter = [].obs;
  RxInt distanceGroupValue = (-1).obs;
  RxInt priceGroupValue = (-1).obs;
  RxDouble sliderValue = 0.0.obs;
  RxString searchingCAtText = "All".obs;
  RxBool isSearchCat = false.obs;
  RxDouble searchFilterlocationLat = 0.0.obs;
  RxDouble searchSaveFilterLat = 0.0.obs;
  RxDouble searchSaveFilterLng = 0.0.obs;
  RxDouble searchFilterlocationLng = 0.0.obs;
  //for getting firebase price
  RxDouble pricePerPhoto = 0.0.obs;
  RxBool onEndSearchArticle=false.obs;
  RxBool isDataEmpty=false.obs;

  //FOR BOTTOM NAV BAR
  RxInt bnbSelectedIndex=0.obs;

  //FOR AUTH
  RxBool isPhoneOkay=false.obs;

  //FOR MESSAGING
  RxInt selectedModeMsg=0.obs;
}
