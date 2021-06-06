// @dart=2.9
// todo : CRUD currently logged in user details

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/models/location.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Map<String, dynamic> currentLoggedinUserDetails = {
//   "current_uid": "",
//   "gender": "",
//   "show_me": "",
//   "age": "",
//   "geohash": "",
//   "radius": "",
//   "from_age": "",
//   "to_age": "",
// };

// * check if any fields from current loggedin user details is missing
storeUserDetailsSharedPref(double latitude, double longitude) {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    String ontimeHash =
        LocationModel.myGeoHash(latitude: latitude, longitude: longitude);
    readAll().then((values) async {
      if (values["current_uid"] == null ||
          values["current_uid"] != uid ||
          values["name"] == null ||
          values["gender"] == null ||
          values["show_me"] == null ||
          values["age"] == null ||
          values["geohash"] == null ||
          values["radius"] == null ||
          values["to_age"] == null ||
          values["from_age"] == null) {
        var fetchUserdetails = await FirebaseFirestore.instance
            .doc("Users/${FirebaseAuth.instance.currentUser.uid}")
            .get();
        writeValue("current_uid", uid);
        writeValue("name", fetchUserdetails.get("bio.name"));
        writeValue("gender", fetchUserdetails.get("bio.gender"));
        writeValue("show_me", fetchUserdetails.get("show_me"));
        writeValue("age", fetchUserdetails.get("bio.age").toString());
        writeValue("geohash", ontimeHash);
        writeValue("radius", "180");
        writeValue("from_age", "18");
        writeValue("to_age", fetchUserdetails.get("bio.age").toString());
        print("All user datas stored in secure storage successfully");
        print("RFATA enctrypted");
      }
      if (values["geohash"] != ontimeHash) {
        print(
            "Geo hash changed so re-encrypting geo hash field in secure storage");
        writeValue("geohash", ontimeHash);
      }
    });
  } catch (error) {
    print("Error in validate and store user details secure storage : ${error.toString()}");
  }
}
