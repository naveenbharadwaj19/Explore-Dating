// @dart=2.9
// todo : logout user

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/providers/pageview_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

Future<void> logoutUser(BuildContext context) async {
  final pageViewLogic = Provider.of<PageViewLogic>(context, listen: false);
  DocumentReference logout = FirebaseFirestore.instance
      .doc("Users/${FirebaseAuth.instance.currentUser.uid}");
  await logout.update({"is_loggedin": false});
  //  when user clicks logout button should navigate to welcome screen
  pageViewLogic.callConnectingUsers = true; // reset connecting users
  pageViewLogic.pageStorageKeyNo += 1; // reset page storage key
  scrollUserDetails.clear();//  reset scroll details
  GoogleSignIn().signOut();
  FacebookAuth.instance.logOut();
  FirebaseAuth.instance.signOut();
}
