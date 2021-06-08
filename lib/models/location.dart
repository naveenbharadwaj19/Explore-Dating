// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/models/assign_errors.dart';
import 'package:explore/server/signup_process.dart';
import 'package:explore/server/match_making.dart';
import 'package:explore/server/profile_backend/abt_me_backend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: Colors.white),
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
    Position currentPosition;
    try {
      var geo = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition = geo;
      print(currentPosition);
      if (currentPosition != null) {
        updateLocationAllOverTheDataBase(
            currentPosition.latitude, currentPosition.longitude, context);
        updatedOpenCloseLocation();
      }
    } catch (error) {
      print("Error in fetching coordinates : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Error ${AssignErrors.edcod002}",
          style:
              const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
  static Future<Position>  getLatitudeAndLongitude() async {
    // * get latitude and longitude
    Position currentPosition;
    try {
      var geo = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition = geo;
      // print(currentPosition);
      if (currentPosition != null) {
        Position tempPosition = currentPosition;
        currentPosition = tempPosition;
      }
      return currentPosition;
    } catch (error) {
      print("Error in getLatitudeAndLongitude : ${error.toString()}");
      return currentPosition;
    }
  }

  static Future<void> updateLocationAllOverTheDataBase(
      // * store location in required documents
      // * central hub -> store , update location all over the database
      double latitude,
      double longitude,
      BuildContext context) async {
    try {
      List<Placemark> address =
          await placemarkFromCoordinates(latitude, longitude);
      if (address.isNotEmpty || address != null) {
        Placemark addressFirst = address.first;
        // documents where location need to be updated
        SignUpProcess.getLocationAddressAndCoordinates(
            latitude: latitude,
            longitude: longitude,
            address: addressFirst,
            context: context); // * 1 W
        MatchMakingCollection.updateLocationMM(
            latitude, longitude, addressFirst); //* 1R,1 W
        ProfileAboutMeBackEnd.updateProfileLocation(addressFirst);
        print("Location details stored & updated all over the database");
        print("Event triggered in : 1 - Users/-/location 2 - Profile 3 - Matchmaking");
      }
    } catch (error,stackTrace) {
      print("Error in fetching address : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Error ${AssignErrors.edAdd001}",
          style:
              const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace,reason: "Error in fetching location & address");
      FirebaseCrashlytics.instance.setUserIdentifier(FirebaseAuth.instance.currentUser.uid);
    }
  }

  static Future<Placemark> getAddress(double latitude, double longitude) async {
    // * geocoding
    // * converts lati and longi to address
    // this function is not used anywhere
    Placemark addressCompressed;
    try {
      List<Placemark> address =
          await placemarkFromCoordinates(latitude, longitude);
      if (address.isNotEmpty || address != null) {
        var addressFirst = address.first;
        addressCompressed = addressFirst;
      }
      return addressCompressed;
    } catch (error) {
      print("Error in fetching address : ${error.toString()}");
      return addressCompressed;
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

  static checkUserLocation(
      {double latitude, double longitude, BuildContext context}) async {
    // * will update if user geo hash gets changed
    // * 2R , 3W (CRUD of checkUserLocation , updateLocationALlOverTheDataBase)
    try {
      String fetchHash = myGeoHash(latitude: latitude, longitude: longitude);
      print("GeoHash : $fetchHash");
      var fetchedLocationDocData = await FirebaseFirestore.instance
          .doc(
              "Users/${FirebaseAuth.instance.currentUser.uid}/Userlocation/fetchedlocation")
          .get(); // * 1 R
      if (fetchedLocationDocData.exists == false) {
        // no Users/--/Userlocation /fetchedlocation document found
        print("No Userlocation collection found so creating one...");
        updateLocationAllOverTheDataBase(latitude, longitude, context);
      }
      // note : if Users/--/USerlocation/fetchedlocation is not updated to new location this will trigger below line
      // and update the new location all over the database
      // check if stored geohash in Users/--/Userlocation is not equal not current geohash
      if (fetchedLocationDocData.get("current_coordinates.geohash") != fetchHash) {
        print("User level geohash has been changed so updating new location all over the database");
        updateLocationAllOverTheDataBase(latitude, longitude, context);
      }
    } catch (error) {
      print("Error in userlocation : ${error.toString()}");
    }
  }
}
