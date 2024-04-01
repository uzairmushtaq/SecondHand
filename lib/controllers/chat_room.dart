import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:secondhand/models/chat_room.dart';
import 'package:secondhand/services/database.dart';

class ChatRoomCont extends GetxController {
  Rxn<List<ChatRoomModel>> normalBuyChat = Rxn<List<ChatRoomModel>>();
  List<ChatRoomModel>? get getNormalBuyChat => normalBuyChat.value;
  Rxn<List<ChatRoomModel>> normalSellChat = Rxn<List<ChatRoomModel>>();
  List<ChatRoomModel>? get getNormalSellChat => normalSellChat.value;
  Rxn<List<ChatRoomModel>> archievedChat = Rxn<List<ChatRoomModel>>();
  List<ChatRoomModel>? get getArchievedChat => archievedChat.value;

  @override
  void onInit() {
    super.onInit();
    normalBuyChat.bindStream(DataBase().streamForNormalChatRoom(true));
    normalSellChat.bindStream(DataBase().streamForNormalChatRoom(false));
    archievedChat.bindStream(DataBase().streamForArchievedChatRoom());
  }
}
