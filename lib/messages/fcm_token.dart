// Todo : Manage FCM token

import 'package:firebase_messaging/firebase_messaging.dart';

class FCMToken {
  static getFCMToken() async {
    try {
      var fcm = FirebaseMessaging.instance;
      var token = await fcm.getToken();
      print(token);
    } catch (error) {
      print("Error in getting FCM token : ${error.toString()}");
    }
  }
}
