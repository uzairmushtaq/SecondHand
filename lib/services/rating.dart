import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:secondhand/constants/firebase.dart';

class RatingsService {
  //DO RATING
  static Future<void> doRating(String userID, int rating,
      Map<String, dynamic> ratingData, List ratedBy) async {
    Get.back();
    ratingData['$rating'] = ratingData['$rating']! + 1;
    ratedBy.add(authCont.userss!.uid);
    
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .update({'RatedBy': ratedBy});
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .update({'Ratings': ratingData});
    
  }

  static double calculatingtotalRating(Map<String, dynamic> ratingData) {
    int fiveStar = ratingData['5']!;
    int fourStar = ratingData['4']!;
    int threeStar = ratingData['3']!;
    int twoStar = ratingData['2']!;
    int oneStar = ratingData['1']!;
    int calculation =
        5 * fiveStar + 4 * fourStar + 3 * threeStar + 2 * twoStar + 1 * oneStar;
    int totalRatedBy = fiveStar + fourStar + threeStar + twoStar + oneStar;

    double userRating = 0;
       
    userRating = calculation / totalRatedBy;

    return userRating;
  }
}
