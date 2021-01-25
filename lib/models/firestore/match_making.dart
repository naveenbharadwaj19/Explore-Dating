// todo Manage Matchmaking collection firestore
// * mm/MM - matchmaking collection
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/auth_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MatchMakingCollection{
  static addCurrentUserMM(String selectedShowMe) async{
    try{
      String uid = FirebaseAuth.instance.currentUser.uid;

      // * check if required variables is not empty and null
      if (selectedGenderM.isNotEmpty && ageM != null){
        // * check if current user is men or women
        if (selectedGenderM == "Men"){
         CollectionReference menCollection =  FirebaseFirestore.instance.collection("Matchmaking/simplematch/Men");
         await menCollection.add({
             "uid" : uid,
              "show_me" : selectedShowMe,
              "age" : ageM,
         });

         print("User gender is $selectedGenderM . Successfully created matchmaking");
        } else if (selectedGenderM == "Women"){
          CollectionReference womenCollection =  FirebaseFirestore.instance.collection("Matchmaking/simplematch/Women");
          await womenCollection.add({
             "uid" : uid,
              "show_me" : selectedShowMe,
              "age" : ageM,
         });
         print("User gender is $selectedGenderM . Successfully created matchmaking");
        }
      } else if (selectedGenderM.isEmpty && ageM == null){
        // * when required variables is null and empty -> not stored in memory fetching from firestore
        try{
        DocumentSnapshot fetchDetails = await FirebaseFirestore.instance.doc("Users/$uid").get();
        if (fetchDetails.get("bio.gender") == "Men"){
          CollectionReference menCollection =  FirebaseFirestore.instance.collection("Matchmaking/simplematch/Men");
         await menCollection.add({
             "uid" : uid,
              "show_me" : selectedShowMe,
              "age" : fetchDetails.get("bio.age"),
         });
         print("Successfully created matchmaking . Variables are not in memory so fetched user details from firestore");
        }
        else if (fetchDetails.get("bio.gender") == "Women"){
          CollectionReference womenCollection =  FirebaseFirestore.instance.collection("Matchmaking/simplematch/Women");
         await womenCollection.add({
             "uid" : uid,
              "show_me" : selectedShowMe,
              "age" : fetchDetails.get("bio.age"),
         });
         print("Successfully created matchmaking . Variables are not in memory so fetched user details from firestore");
        }
        } catch (error){
          print("Error in fetching user details for matchmaking : ${error.toString()}");
        }
      }
    }
    catch(error){
      print("Error : ${error.toString()}");
    }
  }
}