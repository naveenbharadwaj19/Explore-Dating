// todo create data only when user signup .
// * All backend work is stored until user reach homescreen

import 'dart:io';
import 'package:explore/data/auth_data.dart'show dobM,ageM;
import 'package:explore/models/assign_errors.dart';
import 'package:explore/models/handle_photos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OnlyDuringSignupFirestore {
  static signUpWrite({
    @required Function loadingOn,
    @required loadingOff,
    @required String emailaddess,
    @required String username,
    @required String dob,
    @required String name,
    @required BuildContext context,
  }) async {
    String uid = FirebaseAuth.instance.currentUser.uid;

    int _findAge() {
      // ? check whether user is above 18+
      String getYear = dob.substring(dob.length - 4);
      int strToIntYear = int.parse(getYear);
      DateTime currentTimeStamp = DateTime.now();
      String formatYear =
          DateFormat("yyyy").format(currentTimeStamp).toString();
      int formatYearToInt = int.parse(formatYear);
      int findAge = formatYearToInt - strToIntYear;
      return findAge;
    }

    // loadingOn();
    try {
      DocumentReference data = FirebaseFirestore.instance.doc("Users/$uid");
      DocumentReference data2 = FirebaseFirestore.instance.doc("Userstatus/$uid");
      await data.set({
        "access_check": {
          "top_notch_photo": false,
          "body_photo": false,
          "email_address_verified": false,
          "account_success_page": false,
        },
        "bio": {
          "user_id": uid,
          "username": username,
          "emailaddress": emailaddess,
          "method_used_to_signin": "email/password",
          "name": name,
          "dob": dob,
          "age": _findAge(),
          "account_verified": false,
          "gender": "",
        },
        "show_me" : "",
      });
      await data2.set({
        "isloggedin": true,
        "isdisabled": false,
        "isdeleted" : false,
      });
      // Todo in future change this document field while other other screen:
      // {
      //       "m_f": "",
      //       "other": {"clicked_other": true, "other_gender": ""},
      //     }

      print("User bio created in Firestore successfully");

      // Navigator.pushNamed(context, AccCreatedScreen.routeName);
    } catch (error) {
      print("Error ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
    // loadingOff();
  }

  static updateEmailAddress(
      Function loadingOn, Function loadingOff, BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    loadingOn();
    try {
      DocumentReference user = FirebaseFirestore.instance.doc("Users/$uid");
      await user.update({
        "access_check.email_address_verified": true,
      });
      print("Email address field updated");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
    loadingOff();
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
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
    // loadingOff();
  }

  static updateGenderPage(String selectedGender, BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    // loadingOn();
    try {
      DocumentReference user = FirebaseFirestore.instance.doc("Users/$uid");
      await user.update({
        "bio.gender": selectedGender,
      });
      // todo change the above the field to :
      // bio.gender.m_f. -> field
      print("Gender field updated");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
    // loadingOff();
  }

  // static pressedOtherGender(BuildContext context) async {
  //   String uid = FirebaseAuth.instance.currentUser.uid;
  //   // loadingOn();
  //   try {
  //     DocumentReference user = FirebaseFirestore.instance.doc("Users/$uid");
  //     await user.update({
  //       "bio.gender.m_f": "other",
  //       "bio.gender.other.clicked_other": false,
  //     });
  //     print("Pressed other gender , gender 'm_f' field updated");
  //   } catch (error) {
  //     print("Error : ${error.toString()}");
  //     Flushbar(
  //       messageText: Text(
  //         "Something went wrong try again",
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       backgroundColor: Color(0xff121212),
  //       duration: Duration(seconds: 3),
  //     )..show(context);
  //   }
  //   // loadingOff();
  // }

  // static updateOtherGender(
  //     String selectedOtherGender, BuildContext context) async {
  //   String uid = FirebaseAuth.instance.currentUser.uid;
  //   // loadingOn();
  //   try {
  //     DocumentReference user = FirebaseFirestore.instance.doc("Users/$uid");
  //     await user.update({
  //       "bio.gender.other.other_gender": selectedOtherGender,
  //       "bio.gender.other.clicked_other": true,
  //     });
  //     print("Other gender updated");
  //   } catch (error) {
  //     print("Error : ${error.toString()}");
  //     Flushbar(
  //       messageText: Text(
  //         "Something went wrong try again",
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       backgroundColor: Color(0xff121212),
  //       duration: Duration(seconds: 3),
  //     )..show(context);
  //   }
  //   // loadingOff();
  // }

  // static backToMaleFemaleGenderPage(BuildContext context) async {
  //   String uid = FirebaseAuth.instance.currentUser.uid;
  //   // loadingOn();
  //   try {
  //     DocumentReference user = FirebaseFirestore.instance.doc("Users/$uid");
  //     await user.update({
  //       "bio.gender.m_f": "",
  //       "bio.gender.other.clicked_other": true,
  //     });
  //     print("Back to male / female gender  page");
  //   } catch (error) {
  //     print("Error : ${error.toString()}");
  //     Flushbar(
  //       messageText: Text(
  //         "Something went wrong try again",
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       backgroundColor: Color(0xff121212),
  //       duration: Duration(seconds: 3),
  //     )..show(context);
  //   }
  //   // loadingOff();
  // }

  static getLocationAddressAndCoordinates(String addressLine, double latitude,
      double longitude, BuildContext context) async {
    // * get user address , coordinates and write them on database
    String uid = FirebaseAuth.instance.currentUser.uid;
    // loadingOn();
    try {
      DocumentReference storeUserLocation = FirebaseFirestore.instance
          .doc("Users/$uid/Userlocation/fetchedlocation");
      await storeUserLocation.set({
        "current_coordinates": GeoPoint(latitude, longitude),
        "current_address": addressLine,
      });
      print("Stored User address in firestore");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
    // loadingOff();
  }

  static updatePhotoFields(BuildContext context) async {
    // * get user address , coordinates and write them on database
    String uid = FirebaseAuth.instance.currentUser.uid;
    // loadingOn();
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
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(color: Colors.white),
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
        "show_me" : selectedShowMe,
      });
      print("Show me fields updated in firestore");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}

void uploadHeadBodyPhotoTocloudStorage(
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
    OnlyDuringSignupFirestore.updatePhotoFields(context);
    // * reset head and body photo to null
    HandlePhotos.headPhoto = null;
    HandlePhotos.bodyPhoto = null;
  } catch (error) {
    print("Error : ${error.toString()}");
    Flushbar(
      messageText: Text(
        AssignErrors.expcldstr005,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}

class GooglePath {
  // * When user choose google signin method
  static Future<void> signInWithGoogle(
      BuildContext context,
      String displayNameGoogle,
      String emailAddressGoogle,
      String userUid) async {
    // * store data when user clicked signin with google
    String uid = FirebaseAuth.instance.currentUser.uid;

    // loadingOn();
    try {
      DocumentReference data = FirebaseFirestore.instance.doc("Users/$uid");
      DocumentReference data2 = FirebaseFirestore.instance.doc("Userstatus/$uid");
      await data.set({
        "access_check": {
          "top_notch_photo": false,
          "body_photo": false,
          "email_address_verified": true,
          "account_success_page": false,
        },
        "bio": {
          "user_id": userUid,
          "username": "",
          "emailaddress": emailAddressGoogle,
          "method_used_to_signin": "Google",
          "name": displayNameGoogle,
          "dob": "",
          "age": "",
          "account_verified": false,
          "gender": "",
        },
        "show_me" : "",
      });
      await data2.set({
        "isloggedin": true,
        "isdisabled": false,
        "isdeleted" : false,
        
      });
       // Todo in future change this document field while other other screen:
        // {
        //     "m_f": "",
        //     "other": {"clicked_other": true, "other_gender": ""},
        //   }
      print("User bio using google signin created successfully in firestore");

      // Navigator.pushNamed(context, AccCreatedScreen.routeName);
    } catch (error) {
      print("Error ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
    // loadingOff();
  }

  static Future<void> updateDobGoogle(String dateOfBirth, int age) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    try {
      DocumentReference updateDob =
          FirebaseFirestore.instance.doc("Users/$uid");
      await updateDob.update({
        "bio.dob": dateOfBirth,
        "bio.age": age,
      });
      print("DOB , age updated");
      // * resetting memory of dob and age
      dobM = null;
      ageM = null;
    } catch (error) {
      print("Error : ${error.toString()}");
    }
  }
}
