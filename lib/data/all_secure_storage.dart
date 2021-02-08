// todo : Secure storage encrypted

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = FlutterSecureStorage();

Future<void> writeValue(String key , String value) async{
  await secureStorage.write(key: key, value: value);
  print("$key is encrypted");
}

Future readValue(String key) async{
  var read = await secureStorage.read(key: key);
  return read;
}

Future readAll() async{
  var allreads = await secureStorage.readAll();
  return allreads;
}

Future<void> deleteValue(String key) async{
  await secureStorage.delete(key: key);
  print("$key is deleted in secure storage");
}

Future<void> deleteAll() async{
  await secureStorage.deleteAll();
  print("Everything deleted in secure storage");
}



writeRFATA(String showme) async{
  // * RFATA -> radius,fromage,toage
  // * will fetch age from firestore
  try{
  writeValue("radius", "200");
  writeValue("from_age", "18");
  writeValue("show_me", showme);
  String uid = FirebaseAuth.instance.currentUser.uid;
  DocumentSnapshot getUserAge = await FirebaseFirestore.instance.doc("Users/$uid").get();
  writeValue("to_age", getUserAge.get("bio.age").toString());
  } catch(error){
    print("Error in Writing RFATA ${error.toString()}");
  }
}
