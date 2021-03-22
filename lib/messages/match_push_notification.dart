// Todo : Show notification when user press heart -> opposite user get push notification
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

Future<void> notifyUsersFCM({String? fcmToken}) async {
  // ! Remove before deployemnt never use api key in client side
  try {
    // request permission
    FirebaseMessaging.instance.requestPermission(carPlay: false);
    // server key
    String myKey =
        "AAAA1RA5SsE:APA91bGUPy-PpdhWsQjTA6o1eJHZw7ZZPur2cU_ASS1y6vYF_30d92oRKoKM4KF53j3OY2YcRZyqsUIAJcvZV6r1WXqny8YWiWgPiC3Pzhv-Qpiqp05btzTz1CsSrz_htCfn6SClpEyi";
    // body
    var body = json.encode(
      {
        "to":
            "fJdtQ5cvR6mdd9iLCSkNBp:APA91bG8d50FYNZUDhUGcGbQXUX-xr6dtRa5h5w80nHTS5lNWNZsEEzkmmsPDbqtLh9xQtxjS87vkPlMnncUacPaxkJtBK4tla2otT0c_HRyVS1CUBmyOVAvL2cxv0YIyhWe7ArbtLx-",
        "notification": {
          "title": "WOW",
          "body": "BOOM. You got a match!",
          "mutable_content": true,
        },
      },
    );
    // convert String to uri
    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    // send
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "key=$myKey",
      },
      body: body,
    );
    if (response.statusCode == 200) {
      print("Response from FCM : ${response.statusCode}");
      print(response.body);
    } else if (response.statusCode != 200) {
      print("Response from FCM : ${response.statusCode}");
      print("Something went wrong : ${response.body}");
    }
  } catch (error) {
    print("Error in notifinguserFCM : ${error.toString()}");
  }
}

