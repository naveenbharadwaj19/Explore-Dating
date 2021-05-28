// @dart=2.9
// todo backend data of stars rtdb

import 'package:explore/private/database_url_rtdb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

starsRTDB(String oppositeUid) async {
  // store data related to stars in rtdb
  try {
    String myUid = FirebaseAuth.instance.currentUser.uid;
    DatabaseReference db =
        FirebaseDatabase(databaseURL: starInformationsRTDBUrl).reference();
    // store my star info
    await db.child(myUid).update({
      myUid: {"my_uid": myUid,"no_of_stars_pressed_by_me": ServerValue.increment(1),}
    });
    await db.child("$myUid/stars").update({
      oppositeUid: {"uid": oppositeUid, "time": ServerValue.timestamp}
    });
    // store star info in opposite uid
    await db.child("$oppositeUid").update({
      oppositeUid : {"no_of_stars_pressed_on_me" : ServerValue.increment(1)}
    });
    await db.child("$oppositeUid/stars").update({
      myUid: {"uid": myUid, "time": ServerValue.timestamp}
    });
    print("Star info stored in rtdb");
  } catch (error) {
    print("Error in starsRTDB : ${error.toString()}");
  }
}
