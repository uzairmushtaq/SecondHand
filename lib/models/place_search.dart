class PlaceSearch {
  final String description, placeID;
  PlaceSearch({required this.description, required this.placeID});
  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
        description: json["description"], placeID: json["place_id"]);
  }
  
}
