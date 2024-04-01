import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:secondhand/api%20services/upload_ad_images.dart';
import 'package:secondhand/constants/api_constant.dart';
import 'package:secondhand/constants/firebase.dart';


import '../controllers/selected_text_controller.dart';

class UploadAdService {
  static Future uploadAd(String userID, String title, List categories,
      String description, String price, bool isFree, String location) async {
    try {
      authCont.isLoading.value  = true;
      Dio dio = Dio();
      //print("$userID $title $description $categories $price $isFree $location");
      var post = {
        "article_data": {
          "user_id": userID,
          "name": title,
          "description": description,
          "categories": categories,
          "price": price,
          "is_free": isFree,
          "location": location
        },
        "app_password": appPassword
      };
      final url = apiURL + "upload_article";
      var response = await dio.post(url, data: FormData.fromMap(post));
      var res = response.data;
      if (response.statusCode == 200) {
        final globalCont = Get.find<GlobalUIController>();
        //print(res);
        for (int i = 0; i < globalCont.uploadImages.length; i++) {
          UploadAdImagesService.uploadAdImages(
              globalCont.uploadImages[i], res);
          authCont.isLoading.value  = false;
        }
        authCont.isLoading.value  = false;
      } else {
        authCont.isLoading.value  = false;
        //print(res);
      }
    } catch (e) {
      authCont.isLoading.value  = false;
      //print(e.toString());
      // Get.snackbar("Error", e.toString());
    }
  }
}
