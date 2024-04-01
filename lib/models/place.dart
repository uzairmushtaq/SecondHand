import 'package:secondhand/models/geometry.dart';

class PlaceModel {
   GeometeryModel geometery;
   String name, vicinity;
  PlaceModel(
      {required this.geometery, required this.name, required this.vicinity});
  factory PlaceModel.fromJson(Map<String, dynamic> parsedJson) {
    return PlaceModel(
      geometery: GeometeryModel.fromJson(parsedJson["geometry"]),
      name: parsedJson["formatted_address"],
      vicinity: parsedJson["vicinity"],
    );
  }
}
