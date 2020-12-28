import 'package:Explore/models/assign_errors.dart';
import 'package:Explore/models/firestore_signup.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
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
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
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
      await _getCurrentCoordinates(context,updatedOpenCloseLocation);
      // updatedOpenCloseLocation();
      loadingOff();
    }
  }

  static _getCurrentCoordinates(BuildContext context,Function updatedOpenCloseLocation) async {
    Position currentPostion;
    try {
      var geo = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPostion = geo;
      print(currentPostion);
      if (currentPostion != null) {
        _getCurrentAddress(
            currentPostion.latitude, currentPostion.longitude, context);
        updatedOpenCloseLocation();
      }
    } catch (error) {
      print("Error in fetching coordinates : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Error ${AssignErrors.expcod002}",
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  static _getCurrentAddress(
      double latitude, double longitude, BuildContext context) async {
    try {
      Coordinates coordinates = Coordinates(latitude, longitude);
      List<Address> addressCompressed =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      if (addressCompressed != null) {
        var address = addressCompressed.first;
        print(address.addressLine);
        OnlyDuringSignupFirestore.getLocationAddressAndCoordinates(
            address.addressLine,latitude,longitude,context);
      }
    } catch (error) {
      print("Error in fetching address : ${error.toString()}");
      Flushbar(
        messageText: Text(
          "Error ${AssignErrors.expAdd001}",
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
