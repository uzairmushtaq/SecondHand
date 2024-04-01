import 'package:get/get.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/models/user_model.dart';

class AuthService {
  static Future<bool> createUser(UserModel user) async {
    try {
      await kfirestore.collection("Users").doc(user.id).set({
        "Fullname": user.fullName,
        "Phone": user.phone,
        "ProfilePic": user.profilePic,
        "Email": user.email,
        "Password": user.password,
        "Alias": user.alias,
        "ShowAlias": user.showAlias,
        'BlockUsers': [],
        'BlockedFrom': [],
        "Language": user.language,
        "ShowNumber": user.showNumber,
        "Date": DateTime.now().toString()
      });
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  static Future<void> blockorUnblockUser(String otherUserID) async {
    List blockUsers = authCont.userInfo?.blockedUsers ?? [];
    if (blockUsers.contains(otherUserID)) {
      blockUsers.remove(otherUserID);
    } else {
      blockUsers.add(otherUserID);
    }
    await kfirestore
        .collection('Users')
        .doc(authCont.userss!.uid)
        .update({'BlockUsers': blockUsers});

    Get.back();
    //BLOCKED FROM OTHER USER
    final otherUserData =
        await kfirestore.collection('Users').doc(otherUserID).get();
    List otherUserBlocked = otherUserData.get('BlockedFrom');
    if (otherUserBlocked.contains(authCont.userss!.uid)) {
      otherUserBlocked.remove(authCont.userss!.uid);
    } else {
      otherUserBlocked.add(authCont.userss!.uid);
    }
    await kfirestore
        .collection('Users')
        .doc(otherUserID)
        .update({'BlockedFrom': otherUserBlocked});
  }
}
