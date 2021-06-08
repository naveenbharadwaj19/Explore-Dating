// @dart=2.9
// todo all signup process
// * All backend work is stored until user reach homescreen

import 'dart:io';
import 'package:explore/data/temp/auth_data.dart';
import 'package:explore/models/all_enums.dart';
import 'package:explore/models/assign_errors.dart';
import 'package:explore/models/handle_photos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class SignUpProcess {
  static Future<void> updateDobName(
      String dateOfBirth, int age, String name) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    try {
      DocumentReference updateDob =
          FirebaseFirestore.instance.doc("Users/$uid");
      await updateDob
          .update({"bio.dob": dateOfBirth, "bio.age": age, "bio.name": name});
      print("DOB , age updated");
      // * resetting memory of dob and age
      dobM = null;
      // ageM = null;
    } catch (error) {
      print("Error : ${error.toString()}");
    }
  }

  static updateAccSuccPage(BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    // loadingOn();
    try {
      DocumentReference user = FirebaseFirestore.instance.doc("Users/$uid");
      await user.update({
        "access_check.account_success_page": true,
      });
      print("Acc success field updated");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: const Text(
          "Something went wrong try again",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
    // loadingOff();
  }

  static updateGenderPage(String selectedGender, BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    try {
      DocumentReference user = FirebaseFirestore.instance.doc("Users/$uid");
      await user.update({
        "bio.gender": selectedGender,
      });
      print("Gender field updated");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: const Text(
          "Something went wrong try again",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  static getLocationAddressAndCoordinates(
      {@required double latitude,
      @required double longitude,
      @required Placemark address,
      @required BuildContext context}) async {
    //  get user address , coordinates and write them on database
    String uid = FirebaseAuth.instance.currentUser.uid;
    try {
      Geoflutterfire geo = Geoflutterfire();
      GeoFirePoint myCoordinates =
          geo.point(latitude: latitude, longitude: longitude);
      DocumentReference storeUserLocation = FirebaseFirestore.instance
          .doc("Users/$uid/Userlocation/fetchedlocation");
      await storeUserLocation.set({
        "current_coordinates": myCoordinates.data,
        "city": address.locality,
        "state": address.administrativeArea,
        "geohash_rounds": {
          "r1": myCoordinates.hash.toString().substring(0, 5),
          "r2": myCoordinates.hash.toString().substring(0, 4),
          "r3": myCoordinates.hash.toString().substring(0, 3),
          "r4": myCoordinates.hash.toString().substring(0, 2),
          "rh": false,
        }
      });
      // print("Stored User coordinates in firestore");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: const Text(
          "Something went wrong try again",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  static updatePhotoFields(BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    try {
      DocumentReference user = FirebaseFirestore.instance.doc("Users/$uid");
      await user.update({
        "access_check.top_notch_photo": true,
        "access_check.body_photo": true
      });
      print("Photo fields updated in firestore");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: const Text(
          "Something went wrong try again",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
    // loadingOff();
  }

  static updateShowMeFields(String selectedShowMe, BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    // loadingOn();
    try {
      DocumentReference user = FirebaseFirestore.instance.doc("Users/$uid");
      await user.update({
        "show_me": selectedShowMe,
      });
      print("Show me fields updated in firestore");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: const Text(
          "Something went wrong try again",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}

void uploadPhotosTocloudStorageFirstTime(
    String imagePathForHead, String imagePathForBody, BuildContext context) {
  // * ref1 = current head photo , ref2 = body photo , ref3 = all body photos
  try {
    FirebaseStorage _storage = FirebaseStorage.instance;
    final auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    // * ref1 ----
    String imgNameHead = "choosenheadphoto.jpg";
    // imagePathForHead.split("/").last;
    var reference1 =
        _storage.ref().child("Userphotos/$uid/currentheadphoto/$imgNameHead");
    reference1.putFile(File(imagePathForHead));
    // * ref2 ----
    String imgNameBody = "choosenbodyphoto.jpg";
    // imagePathForBody.split("/").last;
    var reference2 =
        _storage.ref().child("Userphotos/$uid/currentbodyphoto/$imgNameBody");
    reference2.putFile(File(imagePathForBody));
    // * ref3 ----
    String imgName = imagePathForBody.split("/").last;
    var reference3 =
        _storage.ref().child("Userphotos/$uid/bodyphotos/$imgName");
    reference3.putFile(File(imagePathForBody));

    print("Photos uploaded to storage");
    SignUpProcess.updatePhotoFields(context);
    // * reset head and body photo to null
    HandlePhotos.headPhoto = null;
    HandlePhotos.bodyPhoto = null;
  } catch (error) {
    print("Error : ${error.toString()}");
    Flushbar(
      messageText: Text(
        AssignErrors.edcldstr005,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}

Future<void> createUserData(
    AuthenticationType authenticationType,
    BuildContext context,
    String displayNameGoogle,
    String emailAddressGoogle,
    String userUid) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  String signinType = "";
  try {
    if (AuthenticationType.google == authenticationType) {
      signinType = "Google";
    } else if (AuthenticationType.facebook == authenticationType) {
      signinType = "Facebook";
    }
    DocumentReference data =
        FirebaseFirestore.instance.doc("Users/$uid"); // Users
    DocumentReference data2 =
        FirebaseFirestore.instance.doc("Users/$uid/Filters/data"); // Filters
    await data.set({
      "access_check": {
        "top_notch_photo": false,
        "body_photo": false,
        "account_success_page": false,
        "get_started": false,
      },
      "bio": {
        "user_id": userUid,
        "emailaddress": emailAddressGoogle,
        "method_used_to_signin": signinType,
        "name": displayNameGoogle,
        "dob": "",
        "age": "",
        "account_verified": false,
        "gender": "",
      },
      "show_me": "",
      "is_loggedin": true,
      "is_disabled": false,
      "is_delete": false,
    });
    await data2.set({
      "show_me": "Everyone",
      "radius": 180,
      "from_age": 18,
      "to_age": 25 // default age
    });
    print("User Data created successfully");
  } catch (error) {
    print("Error ${error.toString()}");
    Flushbar(
      messageText: const Text(
        "Something went wrong try again",
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
