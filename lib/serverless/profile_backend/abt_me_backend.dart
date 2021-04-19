// @dart=2.9
// todo : All details of about me widgets

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ProfileAboutMeBackEnd {
  static Future<void> storeProfileData({
    @required String name,
    @required int age,
    @required String headPhotoHash,
    @required String headPhotoUrl,
  }) async {
    try {
      // * only during sign up
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference profileData =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // set data
      await profileData.set({
        "name": name,
        "age": age,
        "location": {
          "city": "",
          "state": "",
        }, // location will be updated later
        "head_photo": {"hash": headPhotoHash, "url": headPhotoUrl},
        "about_me": "",
        "my_interests": FieldValue.arrayUnion([]),
        "education_level": "",
        "education": "",
        "work": "",
        "exercise" : "",
        "height": "",
        "smoking": "",
        "drinking": "",
        "looking_for": "",
        "kids": "",
        "from": {
          "country" : "",
          "state" : "",
          "city" : "",
        },
        "zodiac_signs": "",
        "do_not_show_again": false,
        "show_photos_info": true,
      });
      // total 19 fields
      print("Profile fields stored successfully in database");
    } catch (error) {
      print("Error in creating profile data in database : ${error.toString()}");
      // ! show error message in UI
    }
  }

  static Future<void> updateProfileLocation(Placemark address) async {
    // * update location field
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference profileData =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update data
      await profileData.update({
        "location.city": address.locality,
        "location.state": address.administrativeArea,
      });
    } catch (error) {
      print("Error in updating profile location : ${error.toString()}");
    }
  }

  static Future<void> aboutMe(String aboutMe) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "about_me": aboutMe,
      });
      print("about_me data stored");
    } catch (error) {
      print(
          "Error in updating about_me details in database : ${error.toString()}");
    }
  }
  static Future<void> myInterests(List selectedInterests) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "my_interests": selectedInterests,
      });
      print("my_interest data stored");
    } catch (error) {
      print(
          "Error in updating my_interests details in database : ${error.toString()}");
    }
  }

  static Future<void> educationLevel(String educationLevel) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "education_level": educationLevel,
      });
      print("education_level data stored");
    } catch (error) {
      print(
          "Error in updating education_level details in database : ${error.toString()}");
    }
  }

  static Future<void> education(String education) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "education": education,
      });
      print("education data stored");
    } catch (error) {
      print(
          "Error in updating education details in database : ${error.toString()}");
    }
  }

  static Future<void> work(String work) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "work": work,
      });
      print("work data stored");
    } catch (error) {
      print("Error in updating work details in database : ${error.toString()}");
    }
  }

  static Future<void> height(String height) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "height": height,
      });
      print("height data stored");
    } catch (error) {
      print(
          "Error in updating height details in database : ${error.toString()}");
    }
  }

  static Future<void> exercise(String exercise) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "exercise": exercise,
      });
      print("exercise data stored");
    } catch (error) {
      print(
          "Error in updating exercise details in database : ${error.toString()}");
    }
  }

  static Future<void> smoking(String smoking) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "smoking": smoking,
      });
      print("smoking data stored");
    } catch (error) {
      print(
          "Error in updating smoking details in database : ${error.toString()}");
    }
  }

  static Future<void> drinking(String drinking) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "drinking": drinking,
      });
      print("drinking data stored");
    } catch (error) {
      print(
          "Error in updating drinking details in database : ${error.toString()}");
    }
  }

  static Future<void> lookingFor(String lookingFor) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "looking_for": lookingFor,
      });
      print("looking_for data stored");
    } catch (error) {
      print(
          "Error in updating looking_for details in database : ${error.toString()}");
    }
  }

  static Future<void> from(String country, String state, String city) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "from": {
          "country": country,
          "state": state,
          "city": city,
        }
      });
      print("from details stored");
    } catch (error) {
      print("Error in updating from details in database : ${error.toString()}");
    }
  }

  static Future<void> kids(String kids) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({"kids": kids});
      print("kids details stored");
    } catch (error) {
      print("Error in updating kids details in database : ${error.toString()}");
    }
  }

  static Future<void> zodiacSigns(String zodiacSigns) async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "zodiac_signs": zodiacSigns,
      });
      print("zodiac_signs details stored");
    } catch (error) {
      print(
          "Error in updating zodiac_signs details in database : ${error.toString()}");
    }
  }

  static Future<void> uploadHeadPhoto(String hash, String url) async {
    // * 1 R , 2 W
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");

      // update
      await data.update({
        "head_photo.hash": hash,
        "head_photo.url": url,
      });
      print("head_photo details updated");
      // get document of matchmaking
      QuerySnapshot matchmakingData = await FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen")
          .where("uid", isEqualTo: uid)
          .get();
      // get the path of match making
      matchmakingData.docs.forEach((datas) async {
        String path = datas.reference.path;
        // update the head photo
        DocumentReference updateHeadPhotoMactchMaking =
            FirebaseFirestore.instance.doc(path);
        await updateHeadPhotoMactchMaking.update({
          "photos.current_body_photo_hash": hash,
          "photos.current_head_photo": url,
        });
        print("head_photo updated in queryed matchmaking");
      });
    } catch (error) {
      print(
          "Error in updating head_photo details in database : ${error.toString()}");
    }
  }

  static Future<void> doNotShowAgainMessage() async {
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "do_not_show_again": true,
      });
      print("do_not_show_again details updated");
    } catch (error) {
      print(
          "Error in updating do_not_show_again details in database : ${error.toString()}");
    }
  }
}
