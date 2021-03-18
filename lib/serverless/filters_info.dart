// @dart=2.9
// todo : Manage Filters collection firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> filtersInformationUpdate(String currentShowMe, int radius,RangeValues ageValues) async {
  try {
    DocumentReference filtersInfo = FirebaseFirestore.instance
        .doc("Users/${FirebaseAuth.instance.currentUser.uid}/Filters/data");
    try {
      // print("1 $radius");
      await filtersInfo.update({
        "show_me": currentShowMe,
        "radius": radius,
        "from_age" : ageValues.start.round(),
        "to_age" : ageValues.end.round(),
      });
    } catch (error) {
      print("Error in updating filters -> data document so creating one");
      await filtersInfo.set({
        "show_me": currentShowMe,
        "radius": radius,
        "from_age" : ageValues.start.round(),
        "to_age" : ageValues.end.round(),
      });
    }

    print("Filters -> data document updated");
  } catch (error) {
    print("Error in filters -> data document");
  }
}
