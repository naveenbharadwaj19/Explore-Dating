// @dart=2.9
// todo : Handle all deletes and logout

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/temp/auth_data.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/providers/pageview_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

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
        style: const TextStyle(
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

void deleteAuthDetails(BuildContext context) {
  // * delete user account
  try {
    FirebaseAuth.instance.currentUser.delete();
  } catch (error) {
    print("Error in deleteAuthDetails : ${error.toString()}");
    Flushbar(
      message: "Logout and try again",
      duration: Duration(seconds: 2),
    ).show(context);
  }
}

Future<void> logoutUser(BuildContext context) async {
  final pageViewLogic = Provider.of<PageViewLogic>(context, listen: false);
  // * logout current user
  DocumentReference logout = FirebaseFirestore.instance
      .doc("Userstatus/${FirebaseAuth.instance.currentUser.uid}");
  await logout.update({"isloggedin": false});
  // * when user clicks logout button should navigate to welcome screen
  manageSigninLogin = false;
  pageViewLogic.callConnectingUsers = true; // reset connecting users
  // * reset scroll details
  scrollUserDetails.clear();
  GoogleSignIn().signOut();
  FirebaseAuth.instance.signOut();
}
