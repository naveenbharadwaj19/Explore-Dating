import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(icon: Icon(Icons.fireplace,color: Colors.red,), onPressed:(){
        // FirebaseCrashlytics.instance.crash();
        checkQuer();
      })
    );
  }
}


// Lottie.asset("assets/animations/infinity.json",fit: BoxFit.cover),


checkQuer() async{
  QuerySnapshot query = await FirebaseFirestore.instance.collection("Notifications").where("received_hearts_uid",arrayContains: {"uid" : FirebaseAuth.instance.currentUser.uid,"swiped_right" : false}).get();
  query.docs.forEach((element) {
    print(element.data());
  });
}