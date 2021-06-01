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
    print("Delete account process is triggered");
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

Future<void> automaticUnMatch(List<Map> deleteDatas) async {
  // ? automatic unmatch after 12 hrs
  try {
    FirebaseFunctions function = FirebaseFunctions.instance;
    var callFunction = function.httpsCallable("automaticUnMatch");
    callFunction({
      "deleteDatas" : deleteDatas
    }).then((value) => print(value.data));
  } catch (error) {
    print("Error in https callable -> automaticUnMatch : ${error.toString()}");
  }
}


Future<void> unmatchIndividualChats(String path,String oppositeUid) async {
  // ? delete all personal convo when user pressed unmatch
  try {
    FirebaseFunctions function = FirebaseFunctions.instance;
    var callFunction = function.httpsCallable("unmatchIndividualChats");
    callFunction({
      "path" : path,
      "oppositeUid" : oppositeUid
    }).then((value) => print(value.data));
  } catch (error) {
    print("Error in https callable -> unmatchIndividualChats : ${error.toString()}");
  }
}


Future<void> replicateHeadPhoto(String headPhotoUrl) async {
  // ? replicate head photo
  try {
    FirebaseFunctions function = FirebaseFunctions.instance;
    var callFunction = function.httpsCallable("replicateHeadPhoto");
    callFunction({
      "headPhotoUrl" : headPhotoUrl
    }).then((value) => print(value.data));
  } catch (error) {
    print("Error in https callable -> replicateHeadPhoto : ${error.toString()}");
  }
}


Future<void> createMatchMakingServerSide(String headPhoto,String bodyPhoto,String selectedShowMe) async {
  // ? create matchmaking,profile,profilephotos
  try {
    FirebaseFunctions function = FirebaseFunctions.instance;
    var callFunction = function.httpsCallable("createMatchMakingData");
    callFunction({
      "headPhoto" : headPhoto,
      "bodyPhoto" : bodyPhoto,
      "selectedShowMe" : selectedShowMe 
    }).then((value) => print(value.data));
  } catch (error) {
    print("Error in https callable -> createMatchMakingServerSide : ${error.toString()}");
  }
}