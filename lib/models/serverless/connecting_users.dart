// todo : Algorithm for getting matched user id


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';

class ConnectingUsers{
  // * radiuskm default value is whole country
  static String radiusKm;
  static String agePreferred;
  static matchUsers() async{
    try{
      var matchMakingResults = FirebaseFirestore.instance.collection("Matchmaking/simplematch/MenWomen");
    if (radiusKm == "Whole Country"){
      readAll().then((ssValues){
        int ageInt = int.parse(ssValues["age"]);
        int setAge = ageInt + 5;
        if(ssValues["gender"] == ssValues["show_me"]){
          // query same gender and showme -> homosexual
         var queryedResults =  matchMakingResults.where("gender",isEqualTo: ssValues["gender"]).where("uid",isNotEqualTo: ssValues["current_uid"]).where("show_me",isEqualTo: ssValues["show_me"]).where("age",isLessThanOrEqualTo: setAge).limit(5).get();
        }
      });
    }
    } catch(error){
      print("Error in ConnectingUsers -> matchusers : ${error.toString()}");
    }
  }
}