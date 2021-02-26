// todo Manage Matchmaking collection firestore
// * mm/MM - matchmaking collection
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart' show Geoflutterfire;

class MatchMakingCollection {
  static addCurrentUserMM(String selectedShowMe) async {
    try {
      bool homo = false;
      print("in1..");
      String uid = FirebaseAuth.instance.currentUser.uid;
      // * create a user document in matchmaking collection 
      DocumentSnapshot fetchDetails =
          await FirebaseFirestore.instance.doc("Users/$uid").get();
        if(selectedShowMe == fetchDetails.get("bio.gender").toString()){
          print("in2..");
          homo = true;
        }
        print("homo $homo");
        print("in3..");
      CollectionReference menWomenCollection = FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen");
      await menWomenCollection.add({
        "uid": uid,
        "show_me": selectedShowMe,
        "age": fetchDetails.get("bio.age"),
        "gender": fetchDetails.get("bio.gender"),
        "name": fetchDetails.get("bio.name"),
        "geohash_rounds": {
          "rh" : homo,
        }
      });

      print(
          "Successfully created user document in matchmaking");
    } catch (error) {
      print("Error in creating user matchmaking : ${error.toString()}");
    }
  }

  static updateLocationMM(double latitude, longitude, Placemark address) async {
    // * update current location of the user in matchmaking
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      bool homo = false;
      var userMM = await FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen")
          .where("uid", isEqualTo: uid)
          .get();
      userMM.docs.forEach((element) async {
        print("Updating user location in matchmaking ...");
        if(element.get("show_me").toString() == element.get("gender").toString()){
          homo = true;
        }
        String fullPath = element.reference.path;
        var myGeoData =
            Geoflutterfire().point(latitude: latitude, longitude: longitude);
        print("Path matchmaking : $fullPath");
        DocumentReference updateLocation =
            FirebaseFirestore.instance.doc(fullPath);
        await updateLocation.update({
          "current_coordinates": myGeoData.data,
          "city": address.locality,
          "state": address.administrativeArea,
          "geohash_rounds" : {
          "r1" : myGeoData.hash.toString().substring(0,5),
          "r2" : myGeoData.hash.toString().substring(0,4),
          "r3" : myGeoData.hash.toString().substring(0,3),
          "r4" : myGeoData.hash.toString().substring(0,2),
          "rh" : homo,
        }
        }
        );
        print("User location updated in matchmaking");
      });
    } catch (error) {
      print("Error in userlocationmm ${error.toString()}");
    }
  }
}
