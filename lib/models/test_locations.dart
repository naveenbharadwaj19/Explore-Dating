// * test whether geoflutter fire support limit

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart'show Geoflutterfire,GeoFirePoint;
import 'package:geolocator/geolocator.dart'show Geolocator,LocationAccuracy;

fetchNearbyUsers()async {
  try{
  var geol = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
  var currentPostion = geol;
  print("Test coordinates : ${currentPostion.latitude} ${currentPostion.longitude}");
  Geoflutterfire geo = Geoflutterfire();
  GeoFirePoint center = geo.point(latitude: currentPostion.latitude, longitude: currentPostion.longitude);
  var collRef = FirebaseFirestore.instance.collection("Matchmaking/simplematch/MenWomen");
  double radiusKm = 50;
  String field = "current_coordinates";
  var nearBy = geo.collection(collectionRef: collRef,limitby: 10).within(center: center, radius: radiusKm, field: field);
  nearBy.listen((event) {
    event.forEach((element) {
      print(element.data());
    });
  });

  }
  catch(error){
    print("Error : ${error.toString()}");
  }
}