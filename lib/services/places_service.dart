import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/place.dart';
import '../models/place_search.dart';

class PlacesService {
  final myGoogleApiKey = "AIzaSyBwAY3XYiLYN3caL2ZBphWg7PwVmyzVHDM"; //@TODO
  Future<List<PlaceSearch>> getAutoComplete(String search) async {
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=geocode&language=de&key=$myGoogleApiKey");
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json["predictions"] as List;
    return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
  }
  Future<PlaceModel> getPlace(String placeID) async {
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$myGoogleApiKey");
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    
    var jsonResult = json["result"] as Map<String, dynamic>;
    //print(jsonResult);
    return PlaceModel.fromJson(jsonResult);
  }
}
