import 'package:get/get.dart';
import 'package:secondhand/models/all_user_model.dart';

import '../services/database.dart';

class AllUserController extends GetxController{
  Rxn<List<AllUserModel>> allUsers=Rxn<List<AllUserModel>>();
  List<AllUserModel> get gettingUsers  => allUsers.value??[];
  @override
  void onInit() {
    allUsers.bindStream(DataBase().streamForUSers());
    super.onInit();
  }
}