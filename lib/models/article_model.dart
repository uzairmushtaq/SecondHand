import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  String? articleID,
      userID,
      title,
      description,
      price,
      location,
      expiryDate,
      postedOn,
      currency,
      language;
  List? categories, images, likedBy, searchBy, crossedBy, views;
  double? lat, lng;
  bool? isFree, isDraft;
  ArticleOwner? owner;
  ArticleModel(
      {required this.userID,
   required   this.currency,
      required this.owner,
      required this.title,
      required this.description,
      required this.categories,
      required this.images,
      required this.isFree,
      required this.location,
      required this.expiryDate,
      required this.lat,
      required this.lng,
      required this.postedOn,
      required this.articleID,
      required this.likedBy,
      required this.isDraft,
      required this.searchBy,
      required this.crossedBy,
      required this.views,
      required this.price,
      required this.language});
  ArticleModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    articleID = doc.id;
    owner=ArticleOwner.fromDocumentSnapshot(doc['Owner']);
    userID = doc["UploadedBy"];
    currency=doc['Currency'];
    title = doc["Title"];
    description = doc["Description"];
    price = doc["Price"];
    location = doc["Location"];
    isFree = doc["isFree"];
    categories = doc["Categories"];
    images = doc["Images"];
    expiryDate = doc["ExpiryDate"];
    postedOn = doc["PostedOn"];
    likedBy = doc["LikedBy"];
    searchBy = doc["SearchBy"];
    isDraft = doc["isDraft"];
    crossedBy = doc["CrossedBy"];
    views = doc["Views"];
    lat = doc["Latitude"];
    lng = doc["Longitude"];
    language = doc['Language'];
  }
}

class ArticleOwner {
  String? name, phone, email;
  ArticleOwner({this.email, this.name, this.phone});
  ArticleOwner.fromDocumentSnapshot(Map<String, dynamic> data) {
    name = data['Name'];
    email = data['Email'];
    phone = data['Phone'];
  }
}
