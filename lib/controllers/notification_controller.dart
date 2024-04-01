import 'package:get/get.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/models/notifications_model.dart';

import '../services/database.dart';

class NotificationController extends GetxController {
  Rxn<List<NotificationsMOdel>> notify = Rxn<List<NotificationsMOdel>>();
  List<NotificationsMOdel> get gettingNotify => notify.value ?? [];
  @override
  void onInit() {
    String uid = Get.find<AuthController>().userss!.uid ?? "";
    notify.bindStream(DataBase().streamOfNotifications(uid));
    super.onInit();
  }
}
