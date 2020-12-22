// todo : Handle all deletes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<void> deleteUserDuringSignUpProcess(BuildContext context) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  // loadingOn();
  try {
    DocumentReference userDelete = FirebaseFirestore.instance.doc("Users/$uid");
    await userDelete.delete();
    print("User account deleted successfully in firestore");
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

