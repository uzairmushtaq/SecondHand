import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:secondhand/constants/api_constant.dart';

class UploadAdImagesService {
  static Future<void> uploadAdImages(
      File image,int articleID) async {
    try {
      final picture = base64Encode(image.readAsBytesSync());
      final pictureName = image.path;
      var post = {
        "app_password": appPassword,
        "upload_data": {
          "name": pictureName,
          "image": picture,
          "article_id": articleID,
        }
      };
      final url = apiURL + "upload_article_image";

      Response response = await Dio().post(url, data: FormData.fromMap(post));

      var res = response.data;
      if (response.statusCode == 200) {
        //print("Uploaded done $res");
      } else {
        //print(res);
      }
    } catch (e) {
      //print(e.toString());
    }
  }
}