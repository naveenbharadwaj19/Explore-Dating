// todo create data only when user signup and datas until home screen

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      await data.set({
        "access_check": {
          "locationaccess": false,
          "top_notch_photo": false,
          "body_photo": false,
          "email_address_verified": false,
          "account_success_page": false,
        },
        "bio": {
          "user_id": uid,
          "username": username,
          "emailaddress": emailaddess,
          "name": name,
          "dob": dob,
          "age": _findAge(),
          "account_verified": false,
          "top_notch_photo_using": "",
          "body_photo_using": "",
          "gender": "",
        }
      });
      print("User bio created in Firestore successfully");

      // Navigator.pushNamed(context, AccCreatedScreen.routeName);
    } catch (error) {
      print("Error ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
    // loadingOff();
  }

  static updateEmailAddress(Function loadingOn , Function loadingOff , BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    loadingOn();
    try {
      DocumentReference user = FirebaseFirestore.instance.doc("Users/$uid");
      await user.update({
        "access_check.email_address_verified" : true,
      });
      print("Email address field updated");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w700,
              color: Colors.white),
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
        "access_check.account_success_page" : true,
      });
      print("Acc success field updated");
    } catch (error) {
      print("Error : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Something went wrong try again",
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
    // loadingOff();
  }
}
