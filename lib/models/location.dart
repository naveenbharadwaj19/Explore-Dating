import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/models/assign_errors.dart';
import 'package:explore/models/firestore/match_making.dart';
import 'package:explore/models/firestore_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geoflutterfire/geoflutterfire.dart' show Geoflutterfire;
import 'package:geolocator/geolocator.dart';

class LocationModel {
  static checkPremission(
      {@required Function changeToOpenSetting,
      @required Function changeToAllowSetting,
      @required bool check,
      @required Function loadingOn,
      @required Function loadingOff,
      @required Function updatedOpenCloseLocation,
      @required BuildContext context}) async {
    LocationPermission premission = await Geolocator.requestPermission();

    if (LocationPermission.deniedForever == premission) {
      print("User denied the premission forever");
      changeToOpenSetting();
      var checkOpenAppSettings = await Geolocator.openAppSettings();
      if (!checkOpenAppSettings) {
        print(
            "Does not have premission to open app setting . User have to choose manually");
        Flushbar(
          messageText: Text(
            "Open app setting and give location premission",
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(context);
      }
      // return settings;
    } else if (LocationPermission.whileInUse == premission ||
        LocationPermission.always == premission) {
      changeToAllowSetting();
      print("User gave premission : $premission");
      loadingOn();
      await _getCurrentCoordinates(context, updatedOpenCloseLocation);
      // updatedOpenCloseLocation();
      loadingOff();
    }
  }

  static _getCurrentCoordinates(
      BuildContext context, Function updatedOpenCloseLocation) async {
    Position currentPostion;
    try {
      var geo = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPostion = geo;
      print(currentPostion);
      if (currentPostion != null) {
        updateNewLocation(currentPostion.latitude, currentPostion.longitude, context);
        updatedOpenCloseLocation();
      }
    } catch (error) {
      print("Error in fetching coordinates : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Error ${AssignErrors.expcod002}",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }


  static updateNewLocation(
    // * storing current location
      double latitude, double longitude, BuildContext context) async {
    try {
      Coordinates coordinates = Coordinates(latitude, longitude);
      List<Address> addressCompressed =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      if (addressCompressed != null) {
        // var address = addressCompressed.first;
        // print(address.addressLine);
        // * set new user location
        OnlyDuringSignupFirestore.getLocationAddressAndCoordinates(
            latitude, longitude, context);
      }
    } catch (error) {
      print("Error in fetching address : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Error ${AssignErrors.expAdd001}",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  static String myGeoHash({double latitude, double longitude}) {
    // * takes lati and longi and convert them to geo hash
    var myhash =
        Geoflutterfire().point(latitude: latitude, longitude: longitude);
    return myhash.hash;
  }

  static geoData(double latitude, double longitude) {
    var myGeoData =
        Geoflutterfire().point(latitude: latitude, longitude: longitude);
    return myGeoData.data;
  }

  static checkForUserLocation(
      {double latitude, double longitude, BuildContext context}) async {
    // * will update if user geo hash gets changed
    try {
      String fetchHash = myGeoHash(latitude: latitude, longitude: longitude);
      print("GeoHash : $fetchHash");
      var checkFetchlocationDoc = await FirebaseFirestore.instance.doc("Users/${FirebaseAuth.instance.currentUser.uid}/Userlocation/fetchedlocation").get();
      if (checkFetchlocationDoc.exists == false){
        print("No Userlocation collection found so creating one...");
        OnlyDuringSignupFirestore.getLocationAddressAndCoordinates(latitude, longitude, context);
        MatchMakingCollection.updateLocationMM(latitude, longitude);
        print("Added user coordinates in userlocation collection and in matchmaking");
      }
      var location = await FirebaseFirestore.instance
          .collection(
              "Users/${FirebaseAuth.instance.currentUser.uid}/Userlocation")
          .where("current_coordinates.geohash", isNotEqualTo: fetchHash)
          .get();
      location.docs.forEach((element) async {
        print(
            "New geo hash of user is not stored in firestore.So processing...");
        OnlyDuringSignupFirestore.getLocationAddressAndCoordinates(latitude, longitude, context);
        // * update location in matchmaking
        MatchMakingCollection.updateLocationMM(latitude, longitude);
        print("New location updated ...");
      });
    } catch (error) {
      print("Error in userlocation : ${error.toString()}");
    }
  }
}
