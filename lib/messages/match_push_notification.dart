// Todo : Show notification when user press heart -> opposite user get push notification
import 'package:firebase_messaging/firebase_messaging.dart';

test(){
  FirebaseMessaging.instance.requestPermission();
  print("in1");
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print("in3");
    print(event.data);
    print(event.sentTime);
  });
}