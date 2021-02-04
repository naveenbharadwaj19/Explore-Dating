// todo : CRUD currently logged in user details

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/models/location.dart';
import 'package:firebase_auth/firebase_auth.dart';

Map<String, dynamic> currentLoggedinUserDetails = {
  "current_uid": "",
  "gender": "",
  "show_me": "",
  "age": "",
  "geohash": "",
};

// * check if any fields from current loggedin user details is missing
validateAndStoreUserDetails(double latitude, double longitude) {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    String ontimeHash =
        LocationModel.myGeoHash(latitude: latitude, longitude: longitude);
    readAll().then((values) async {
      if (values["current_uid"] == null ||
          values["current_uid"] != uid ||
          values["gender"] == null ||
          values["show_me"] == null ||
          values["age"] == null ||
          values["geohash"] == null) {
        var fetchUserdetails = await FirebaseFirestore.instance
            .doc("Users/${FirebaseAuth.instance.currentUser.uid}")
            .get();

        var fetchUserLocation = await FirebaseFirestore.instance
            .doc(
                "Users/${FirebaseAuth.instance.currentUser.uid}/Userlocation/fetchedlocation")
            .get();
        writeValue("current_uid", uid);
        writeValue("gender", fetchUserdetails.get("bio.gender"));
        writeValue("show_me", fetchUserdetails.get("show_me"));
        writeValue("age", fetchUserdetails.get("bio.age").toString());
        writeValue(
            "geohash", fetchUserLocation.get("current_coordinates.geohash"));
        print("All user datas stored in secure storage successfully");
      }
      if (values["geohash"] != ontimeHash) {
        print(
            "Geo hash changed so re-encrypting geo hash field in secure storage");
        writeValue("geohash", ontimeHash);
      }
    });
  } catch (error) {
    print("Error : ${error.toString()}");
  }
}
