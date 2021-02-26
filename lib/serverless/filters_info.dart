// todo : Manage Filters collection firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> filtersInformationUpdate(String currentShowMe, int radius) async {
  try {
    DocumentReference filtersInfo = FirebaseFirestore.instance
        .doc("Users/${FirebaseAuth.instance.currentUser.uid}/Filters/data");
    try {
      print("1 $currentShowMe");
      await filtersInfo.update({
        "show_me": currentShowMe,
        "radius": radius,
      });
    } catch (error) {
      print("Error in updating filters -> data document so creating one");
      await filtersInfo.set({
        "show_me": currentShowMe,
        "radius": radius,
      });
    }

    print("Filters -> data document updated");
  } catch (error) {
    print("Error in filters -> data document");
  }
}
