
// Todo : update show me in Users , MatchMaking when user change show me


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

updateShowMeFirestore(String newShowMe) async{
  try{
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
    });
  });
  print("Show me updated in Users & Matchmaking collection ...");
  } catch (error){
    print("Error in updating Show me in firestore ${error.toString()}");
  }
}