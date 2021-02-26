// todo : Handle all deletes and logout

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/data/all_shared_pref_data.dart';
import 'package:explore/data/temp/auth_data.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

Future<void> deleteAuthDetails() async {
  try {
    // * signout user if they use google auth
    GoogleSignIn().signOut();
    FirebaseAuth.instance.currentUser.delete();
    print("Account deleted successfully.Firestore User delete event will get triggred and Userstatus collection will be deleted");
    // * fetch user id from shared pref
    await readUserUid();
    print("Removing userid : $currentUserUidSf");
    await Future.delayed(Duration(seconds: 2));
    FirebaseFirestore.instance.doc("Userstatus/$currentUserUidSf").delete();
    removeUserUid();
    deleteAll();
  } catch (error) {
    print("Error : ${error.toString()}");
  }
}

Future<void> deleteUserStatus() async{
  // * delete Userstatus -> uid fields
  try{
    await readUserUid();
    print("Removing userid : $currentUserUidSf");
    FirebaseAuth.instance.currentUser.reload();
    // * signout google user
    GoogleSignIn().signOut();
    await Future.delayed(Duration(seconds: 2));
    FirebaseFirestore.instance.doc("Userstatus/$currentUserUidSf").delete();
    removeUserUid();
    deleteAll();
    print("Userstatus -> uid deleted successfully");
  }
  catch(error){
    print("Error : ${error.toString()}");
  }
}

Future<void>logoutUser() async{
  // * logout current user
  DocumentReference logout = FirebaseFirestore.instance.doc("Userstatus/${FirebaseAuth.instance.currentUser.uid}");
  await logout.update({
    "isloggedin" : false
  });
  // * when user clicks logout button should navigate to welcome screen
  manageSigninLogin = false;
  // * reset scroll details
  scrollUserDetails.clear();
  GoogleSignIn().signOut();
  FirebaseAuth.instance.signOut();
}

