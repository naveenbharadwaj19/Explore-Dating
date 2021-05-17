// @dart=2.9
// Todo : manage all https/http callable cloud functions
import 'package:cloud_functions/cloud_functions.dart';

Future<void> callUserDisableFunction() async {
  // ? when triggred user account is disabled
  try {
    FirebaseFunctions disableFunction = FirebaseFunctions.instance;
    var callFunction = disableFunction.httpsCallable("disableUserAccount");
    await callFunction();
    print("disableUserAccount function is triggered");
  } catch (error) {
    print("Error in https callable : ${error.toString()}");
  }
}

Future<void> callUserDeleteFunction() async {
  // ? when triggred user account is deleted
  try {
    FirebaseFunctions disableFunction = FirebaseFunctions.instance;
    var callFunction = disableFunction.httpsCallable("deleteUserAccount");
    await callFunction();
    print("deleteUserAccount function is triggered");
  } catch (error) {
    print("Error in https callable : ${error.toString()}");
  }
}

Future<void> callnotifyUsersFCMFunction({String token}) async {
  // ? push notification when pressed heart
  try {
    FirebaseFunctions function = FirebaseFunctions.instance;
    var notfiyUsersFCM = function.httpsCallable("notifyUsersFCM");
    await notfiyUsersFCM({
      "token": token,
      "title": "BOOM",
      "body": "You got a match"
    }).then((value) => print(value.data));
  } catch (error) {
    print("Error in https callable -> notifyUsersFCM : ${error.toString()}");
  }
}

Future<void> automaticUnMatch(List<String> deletePath) async {
  // ? push notification when pressed heart
  try {
    FirebaseFunctions function = FirebaseFunctions.instance;
    var callFunction = function.httpsCallable("automaticUnMatch");
    callFunction({
      "deletePath" : deletePath
    }).then((value) => print(value.data));
  } catch (error) {
    print("Error in https callable -> notifyUsersFCM : ${error.toString()}");
  }
}

