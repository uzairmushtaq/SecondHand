import 'dart:async';

import 'package:get/get.dart';

import '../models/place.dart';
import '../models/place_search.dart';
import '../services/places_service.dart';

class PlacesSearchController extends GetxController {
  final placesService = PlacesService();
  
    List<PlaceSearch>?searchResults;
     searchPlaces(String searchKey) async {
      searchResults = await placesService.getAutoComplete(searchKey);
      //print(searchResults);
  }
}
