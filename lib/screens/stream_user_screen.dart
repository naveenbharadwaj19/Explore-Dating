// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:explore/data/temp/filter_datas.dart';
import 'package:explore/models/user_shared_pref.dart';
import 'package:explore/models/location.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/screens/signup_screens/acc_create_screen.dart';
import 'package:explore/screens/lockuser_screens/disable_screen.dart';
import 'package:explore/screens/lockuser_screens/account_delete_screen.dart';
import 'package:explore/screens/signup_screens/gender_screen.dart';
import 'package:explore/screens/signup_screens/dob_name_screen.dart';
import 'package:explore/screens/location_screen.dart';
import 'package:explore/screens/bottom_navigation_bar_screens.dart';
import 'package:explore/screens/no_internet_connection_screen.dart';
import 'package:explore/screens/signup_screens/get_started_screen.dart';
import 'package:explore/screens/signup_screens/pick_photos_screen.dart';
import 'package:explore/screens/signup_screens/show_me_screen.dart';
import 'package:explore/server/update_show_me.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class StreamScreens extends StatefulWidget {
  static const routeName = "basic-details";

  @override
  _StreamScreensState createState() => _StreamScreensState();
}

class _StreamScreensState extends State<StreamScreens> {
  final String animationName2 = "NoWifi";
  bool openCloseLocationPage = false;

  void updateLocationBool() {
    setState(() {
      openCloseLocationPage = true;
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    ErrorWidget.builder = ((e) {
      print("Error in basic user details screen");
      return Center(
        child: loadingSpinner(),
      );
    });
  }

  @override
  // ? Check setstate disposed properly
  void setState(fn) {
    // ignore: todo
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      // ? users data
      stream: FirebaseFirestore.instance
          .doc("Users/${FirebaseAuth.instance.currentUser.uid}")
          .snapshots(),
      builder: (context, userSnapShot) {
        if (userSnapShot.connectionState == ConnectionState.waiting ||
            userSnapShot.hasError ||
            !userSnapShot.hasData) {
          return Center(
            child: loadingSpinner(),
          );
        }

        final genderCheck = userSnapShot.data["bio"];
        final dobCheck = userSnapShot.data["bio"];
        final accessCheck = userSnapShot.data["access_check"];
        if (userSnapShot.data["is_delete"] == true) {
          print("Account delete page");
          return AccountDeleteScreen();
        }
        if (userSnapShot.data["is_disabled"] == true) {
          print("Account disabled page");
          return AccountDisabledScreen();
        }
        if (dobCheck["dob"].isEmpty) {
          print("In dob page");
          return DOBNameScreen();
        }

        if (genderCheck["gender"].isEmpty) {
          print("In gender page");
          return GenderScreen();
        }
        if (!accessCheck["top_notch_photo"] || !accessCheck["body_photo"]) {
          print("In photo page");
          return PickPhotoScreen();
        }
        if (userSnapShot.data["show_me"] == null) {
          print("ShowMe is null");
          showMeNull();
          return Center(child: loadingSpinner());
        }

        if (userSnapShot.data["show_me"].isEmpty) {
          print("In show me page");
          return ShowMeScreen();
        }

        if (!accessCheck["account_success_page"]) {
          print("In account success page");
          return AccCreatedScreen();
        }
        if(!accessCheck["get_started"]){
          print("In get started page");
          return GetStartedScreen();
        }

        return StreamBuilder<Position>(
          // ? time location
          stream: Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.best,
            intervalDuration: Duration(minutes: 3),
          ),
          builder: (context, locationSnapShot) {
            if (locationSnapShot.connectionState == ConnectionState.waiting) {
              // print("waiting for the location stream");
              return Center(
                child: Container(
                  height: 200,
                  // width: 300,
                  child: Lottie.asset(
                    "assets/animations/location_pin.json",
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
            final Position currentCoordinates = locationSnapShot.data;
            print("CurrentCoordinates : $currentCoordinates");
            if (currentCoordinates != null) {
              // ! might lead to too much data read and update
              // will trigger to the time set in intervalduration
              LocationModel.checkUserLocation(
                  latitude: currentCoordinates.latitude,
                  longitude: currentCoordinates.longitude,
                  context: context);
            }
            if (currentCoordinates == null && openCloseLocationPage == false) {
              print("In Location page");
              return LocationScreen(
                  updatedOpenCloseLocation: updateLocationBool);
            }
            //  reason assigning false because when user in current state the bool check will always be true . Until user restart / kill the app
            openCloseLocationPage = false;

            return StreamBuilder<ConnectivityResult>(
              // ? check for internet connectivity
              stream: Connectivity().onConnectivityChanged,
              builder: (context, internetConnection) {
                if (internetConnection.connectionState ==
                        ConnectionState.waiting ||
                    internetConnection.hasError ||
                    !internetConnection.hasData) {
                  // print(
                  //     "Fetching connectivity status.Will show loading spinner");
                  return Center(child: loadingSpinner());
                }
                print("ConnectionStatus : ${internetConnection.data}");
                if (internetConnection.data == ConnectivityResult.none) {
                  print("Cannot find internet connection");
                  return noInternetConnection(animationName2, context);
                }
                storeUserDetailsSharedPref(
                    currentCoordinates.latitude, currentCoordinates.longitude);
                fetchFiltersData();
                return BottomNavigationBarScreens();
              },
            );
          },
        );
      },
    );
  }
}
