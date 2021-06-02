// @dart=2.9
// Todo : update show me in Users , MatchMaking when user change show me

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future updateShowMeFirestore(String newShowMe) async {
  try {
    bool homo = false;
    // check if user is homo
    readValue("gender").then((value) {
      if (newShowMe == value.toString()) {
        homo = true;
      }
    });
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference users = FirebaseFirestore.instance.doc("Users/$uid");
    await users.update({
      "show_me": newShowMe,
    });

    QuerySnapshot fetchMatchMakingId = await FirebaseFirestore.instance
        .collection("Matchmaking/simplematch/MenWomen")
        .where("uid", isEqualTo: uid)
        .get();
    fetchMatchMakingId.docs.forEach((element) async {
      String path = element.reference.path;
      DocumentReference updateShowMeMM = FirebaseFirestore.instance.doc(path);
      await updateShowMeMM.update({
        "show_me": newShowMe,
        "geohash_rounds.rh": homo,
      });
    });
    print("Show me updated in Users & Matchmaking collection ...");
  } catch (error) {
    print("Error in updating Show me in firestore ${error.toString()}");
  }
}

Future<void> showMeNull() async {
  // when show me is null
  // * 2 R , 2W
  try {
    final String myUid = FirebaseAuth.instance.currentUser.uid;
    var filtersData =
        await FirebaseFirestore.instance.doc("Users/$myUid/Filters/data").get();
    var matchMakingData = await FirebaseFirestore.instance
        .collection("Matchmaking/simplematch/MenWomen")
        .where("uid", isEqualTo: myUid)
        .get();
    DocumentReference updateUser =
        FirebaseFirestore.instance.doc("Users/$myUid");
    if (filtersData.exists) {
      // if filters data exists
      String showMe = filtersData.get("show_me");
      await updateUser.update({"show_me": showMe});
      matchMakingData.docs.forEach((element) async {
        String path = element.reference.path;
        DocumentReference updateMM = FirebaseFirestore.instance.doc(path);
        await updateMM.update({"show_me": showMe});
      });
      print("Show me error fixed");
    } else {
      print("Cannot get filters data.So updating show me as everyone");
      String showMe = "Everyone";
      await updateUser.update({"show_me": showMe});
      matchMakingData.docs.forEach((element) async {
        String path = element.reference.path;
        DocumentReference updateMM = FirebaseFirestore.instance.doc(path);
        await updateMM.update({"show_me": showMe});
      });
      print("Show me error fixed");
    }
  } catch (e) {
    print("Error in showMeNull : ${e.toString()}");
  }
}
