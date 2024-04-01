import 'package:secondhand/models/location_model.dart';


class GeometeryModel {
  final LocationSearch location;

  GeometeryModel({required this.location});

  GeometeryModel.fromJson(Map<String,dynamic> parsedJson)
      :location = LocationSearch.fromJson(parsedJson['location']);
}