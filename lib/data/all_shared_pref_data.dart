// @dart=2.9
// todo store all info related shared preference

import 'package:shared_preferences/shared_preferences.dart';

String  currentUserUidSf;

Future<void> storeCurrentUserUid(String userUid) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userUid', userUid);
    print("Uid stored successfully");
  } catch (error) {
    print("Error : ${error.toString()}");
  }
}

 Future<void> readUserUid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("userUid")){
  print("Fetched userUid successfully");
  String fetchStoredUserID =  prefs.getString('userUid');
  currentUserUidSf = fetchStoredUserID;
  }
  
}

Future<void>removeUserUid()async{
  try{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("userUid");
  print("UserUid removed");
  }
  catch (error) {
    print("Error : ${error.toString()}");
  }
}