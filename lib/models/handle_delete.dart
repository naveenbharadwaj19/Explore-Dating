// todo : Handle all deletes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

Future<void> deleteUserPhotosInCloudStorage() async {
  try {
    FirebaseStorage deleteUser = FirebaseStorage.instance;
    final auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    var deleteCurrentHeadPhoto = await deleteUser
        .ref()
        .child("Userphotos/$uid/currentheadphoto")
        .listAll();
    deleteCurrentHeadPhoto.items.forEach((element) {
      element.delete();
    });
    var deleteCurrentbodyPhoto = await deleteUser
        .ref()
        .child("Userphotos/$uid/currentbodyphoto")
        .listAll();
    deleteCurrentbodyPhoto.items.forEach((element) {
      element.delete();
    });
    var deleteBodyPhotos =
        await deleteUser.ref().child("Userphotos/$uid/bodyphotos").listAll();
    deleteBodyPhotos.items.forEach((element) {
      element.delete();
    });
    print("User photos deleted successfully in cloud storage");
  } catch (error) {
    print("Error : ${error.toString()}");
  }
}

Future<void> deleteAuthDetails() async {
  try {
    FirebaseAuth.instance.currentUser.delete();
    print("Account deleted successfully.Firestore User delete event will get triggred");
  } catch (error) {
    print("Error : ${error.toString()}");
  }
}
