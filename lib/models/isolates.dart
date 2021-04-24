// @dart=2.9
// todo Manage all isolates here

// import 'package:explore/data/all_secure_storage.dart';
// import 'package:explore/serverless/match_making.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// void isolateShowMeScreen(String selectedShowMe) async {
//   // * will run a seprate isolate when continue button is pressed in show me
//   try {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(); // initialize firebase app
//     MatchMakingCollection.addCurrentUserMM(selectedShowMe);
//     writeRFATA(selectedShowMe);
//     // OnlyDuringSignupFirestore.updateShowMeFields(
//     //     isolateParameter["selectedShowme"], isolateParameter["context"]);
//   } catch (error) {
//     print("Error in isolateForShowMeScreen");
//   }
// }
