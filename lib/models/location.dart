import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/models/assign_errors.dart';
import 'package:explore/serverless/firestore_signup.dart';
import 'package:explore/serverless/match_making.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
          messageText: const Text(
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
        updateNewLocation(
            currentPostion.latitude, currentPostion.longitude, context);
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

  static Future<void> updateNewLocation(
      // * storing current location in users collection
      double latitude,
      double longitude,
      BuildContext context) async {
    try {
      List<Placemark> address =
          await placemarkFromCoordinates(latitude, longitude);
      if (address.isNotEmpty || address != null) {
        var addressFirst = address.first;
        OnlyDuringSignupFirestore.getLocationAddressAndCoordinates(
            latitude: latitude,
            longitude: longitude,
            address: addressFirst,
            context: context);
        MatchMakingCollection.updateLocationMM(
            latitude, longitude, addressFirst);
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

  // static Future<void> updateNewLocationInMM(
  // // * storing current location in match making
  //   double latitude, double longitude) async {
  // try {
  //   List<Placemark> address = await placemarkFromCoordinates(latitude, longitude);
  //   if(address.isNotEmpty || address != null){
  //     var addressFirst = address.first;
  //     MatchMakingCollection.updateLocationMM(latitude, longitude, addressFirst);
  //   }
  // } catch (error) {
  //   print("Error in fetching address for MM : ${error.toString()}");
  // }

  //   }

  static Future<Placemark> getAddress(double latitude, double longitude) async {
    // ? geocoding
    try {
      Placemark addressCompressed;
      List<Placemark> address =
          await placemarkFromCoordinates(latitude, longitude);
      if (address.isNotEmpty || address != null) {
        var addressFirst = address.first;
        addressCompressed = addressFirst;
      }
      return addressCompressed;
    } catch (error) {
      print("Error in fetching address : ${error.toString()}");
      return null;
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
      var checkFetchlocationDoc = await FirebaseFirestore.instance
          .doc(
              "Users/${FirebaseAuth.instance.currentUser.uid}/Userlocation/fetchedlocation")
          .get();
      if (checkFetchlocationDoc.exists == false) {
        print("No Userlocation collection found so creating one...");
        // OnlyDuringSignupFirestore.getLocationAddressAndCoordinates(latitude, longitude, context);
        updateNewLocation(latitude, longitude, context);
        // updateNewLocationInMM(latitude, longitude);
        print(
            "Added user coordinates in userlocation collection and in matchmaking");
      }
      var location = await FirebaseFirestore.instance
          .collection(
              "Users/${FirebaseAuth.instance.currentUser.uid}/Userlocation")
          .where("current_coordinates.geohash", isNotEqualTo: fetchHash)
          .get();
      location.docs.forEach((element) async {
        print(
            "New geo hash of user is not stored in firestore.So processing...");
        updateNewLocation(latitude, longitude, context);
        // * update location in matchmaking
        // updateNewLocationInMM(latitude, longitude);
        print("New location updated ...");
      });
    } catch (error) {
      print("Error in userlocation : ${error.toString()}");
    }
  }
}
