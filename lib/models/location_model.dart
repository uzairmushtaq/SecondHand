class LocationSearch{
  final double lat;final double lng;
  LocationSearch({required this.lat,required this.lng});
  factory LocationSearch.fromJson(Map<dynamic,dynamic> parsedJson){
    return LocationSearch(lat: parsedJson["lat"], lng: parsedJson["lng"]);
  }
}