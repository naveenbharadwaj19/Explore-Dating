// todo Manage Matchmaking collection firestore
// * mm/MM - matchmaking collection
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/temp/auth_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart' show Geoflutterfire;

class MatchMakingCollection {
  static addCurrentUserMM(String selectedShowMe) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;

      // * check if required variables is not empty and null
      if (selectedGenderM.isNotEmpty && ageM != null && nameM.isNotEmpty) {
        // * check if current user is men or women
        CollectionReference menWomenCollection = FirebaseFirestore.instance
            .collection("Matchmaking/simplematch/MenWomen");
        await menWomenCollection.add({
          "uid": uid,
          "show_me": selectedShowMe,
          "age": ageM,
          "gender": selectedGenderM,
          "name" : nameM,
        });
      } else if (selectedGenderM.isEmpty && ageM == null && nameM.isEmpty) {
        // * when required variables is null and empty -> not stored in memory fetching from firestore
        try {
          DocumentSnapshot fetchDetails =
              await FirebaseFirestore.instance.doc("Users/$uid").get();
          CollectionReference menWomenCollection = FirebaseFirestore.instance
              .collection("Matchmaking/simplematch/MenWomen");
          await menWomenCollection.add({
            "uid": uid,
            "show_me": selectedShowMe,
            "age": fetchDetails.get("bio.age"),
            "gender": fetchDetails.get("bio.gender"),
            "name" : fetchDetails.get("bio.name"),
          });

          print(
              "Successfully created matchmaking . Variables are not in memory so fetched user details from firestore");
        } catch (error) {
          print(
              "Error in fetching user details for matchmaking : ${error.toString()}");
        }
      }
    } catch (error) {
      print("Error : ${error.toString()}");
    }
  }

  static updateLocationMM(double latitude, longitude) async {
    // * update current location of the user in matchmaking
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      var userMM = await FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen")
          .where("uid", isEqualTo: uid)
          .get();
      userMM.docs.forEach((element) async {
        print("Updating user location in matchmaking ...");
        String fullPath = element.reference.path;
        var myGeoData =
            Geoflutterfire().point(latitude: latitude, longitude: longitude);
        print("Path matchmaking : $fullPath");
        DocumentReference updateLocation =
            FirebaseFirestore.instance.doc(fullPath);
        await updateLocation.update({
          "current_coordinates": myGeoData.data,
        });
        print("User location updated in matchmaking");
      });
    } catch (error) {
      print("Error in userlocationmm ${error.toString()}");
    }
  }
}
