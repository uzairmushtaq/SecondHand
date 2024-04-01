import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import '../constants/api_constant.dart';
import '../controllers/auth_controller.dart';

class GetCategoryService {
  // final cont = Get.put(CategoriesController());

  static Future gettingCategories() async {
    try {
      var userID = Get.find<AuthController>().userss!.uid;

      var post = {
        "app_password": appPassword,
      };

      final url = apiURL + "get_categories/" + userID.toString();
      var response = await Dio().post(url, data: FormData.fromMap(post));
      //print(response.data.toString());
      return response.data;
    
    } catch (e) {
      //print(e.toString());
    }
  }
}
