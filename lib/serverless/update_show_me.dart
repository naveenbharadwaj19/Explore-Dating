
// Todo : update show me in Users , MatchMaking when user change show me


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future updateShowMeFirestore(String newShowMe) async{
  try{
  bool homo = false;
  // check if user is homo
  readValue("gender").then((value){
    if (newShowMe == value.toString()){
      homo = true;
    }
  }); 
  String uid = FirebaseAuth.instance.currentUser.uid;
  DocumentReference users = FirebaseFirestore.instance.doc("Users/$uid");
  await users.update({
    "show_me" : newShowMe,
  });

  QuerySnapshot fetchMatchMakingId = await FirebaseFirestore.instance.collection("Matchmaking/simplematch/MenWomen").where("uid",isEqualTo: uid).get();
  fetchMatchMakingId.docs.forEach((element)async {
    String path = element.reference.path;
    DocumentReference updateShowMeMM = FirebaseFirestore.instance.doc(path);
    await updateShowMeMM.update({
      "show_me" : newShowMe,
      "geohash_rounds.rh" : homo,
    });
  });
  print("Show me updated in Users & Matchmaking collection ...");
  } catch (error){
    print("Error in updating Show me in firestore ${error.toString()}");
  }
}