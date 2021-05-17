// @dart=2.9
// ? These sream manages all user forums until user complete all neccessary details
// ? Email verf -> account success -> gender -> photos -> show me -> location -> internet connectivity


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:explore/data/temp/filter_datas.dart';
import 'package:explore/models/current_user_details.dart';
import 'package:explore/models/location.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/screens/signup_screens/acc_create_screen.dart';
import 'package:explore/screens/lockuser_screens/disabled_screen.dart';
import 'package:explore/screens/signup_screens/emai_verf_screen.dart';
import 'package:explore/screens/lockuser_screens/error_screen.dart';
import 'package:explore/screens/signup_screens/gender_screen.dart';
import 'package:explore/screens/signup_screens/google_dob_screen.dart';
import 'package:explore/screens/location_screen.dart';
import 'package:explore/screens/bottom_navigation_bar_screens.dart';
import 'package:explore/screens/no_internet_connection_screen.dart';
import 'package:explore/screens/signup_screens/pick_photos_screen.dart';
import 'package:explore/screens/signup_screens/show_me_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class BasicDetailsScreens extends StatefulWidget {
  static const routeName = "basic-details";

  @override
  _BasicDetailsScreensState createState() => _BasicDetailsScreensState();
}

class _BasicDetailsScreensState extends State<BasicDetailsScreens> {
  // final String _animationName = "SearchLocation";
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
      // ? helps to track of user status :
      stream: FirebaseFirestore.instance
          .doc("Userstatus/${FirebaseAuth.instance.currentUser.uid}")
          .snapshots(),
      builder: (context, snapShot1) {
        if (snapShot1.connectionState == ConnectionState.waiting ||
            snapShot1.hasError ||
            !snapShot1.hasData) {
          return Center(
            child: loadingSpinner(),
          );
        }
        final checkUserStatus = snapShot1.data;
        if (checkUserStatus["isdeleted"] == true) {
          print("No user data exist in firestore and in deletation page");
          return WhenUserIdNotExistInFirestore();
        }
        if (checkUserStatus["isdisabled"] == true) {
          print("In User account disabled");
          return UserAccountDisabled();
        }
        return StreamBuilder<DocumentSnapshot>(
          // ? help to check all forums and fields are updated
          stream: FirebaseFirestore.instance
              .doc("Users/${FirebaseAuth.instance.currentUser.uid}")
              .snapshots(),
          builder: (context, snapShot2) {
            if (snapShot2.connectionState == ConnectionState.waiting ||
                snapShot2.hasError ||
                !snapShot2.hasData) {
              return Center(
                child: loadingSpinner(),
              );
            }

            final genderCheck = snapShot2.data["bio"];
            final dobCheck = snapShot2.data["bio"];
            final accessCheck = snapShot2.data["access_check"];
            if (!accessCheck["email_address_verified"]) {
              print("In email verification");
              return EmailVerificationScreen();
            }
            if (dobCheck["dob"].isEmpty) {
              print("In dob page");
              return GoogleDobScreen();
            }

            if (genderCheck["gender"].isEmpty) {
              print("In gender page");
              return GenderScreen();
            }
            // if (!genderCheck["gender"]["other"]["clicked_other"]) {
            //   print("In other gender page");
            //   return OtherGenderScreen();
            // }
            // if (!accessCheck["locationaccess"]) {
            //   print("In location page");
            //   return LocationScreen();
            // }
            if (!accessCheck["top_notch_photo"] || !accessCheck["body_photo"]) {
              print("In photo page");
              return PickPhotoScreen();
            }
            if (snapShot2.data["show_me"].isEmpty ||
                snapShot2.data["show_me"] == null) {
              print("In show me page");
              return ShowMeScreen();
            }

            if (!accessCheck["account_success_page"]) {
              print("In account success page");
              return AccCreatedScreen();
            }
            
            return StreamBuilder<Position>(
              // ? time location
              stream: Geolocator.getPositionStream(
                desiredAccuracy: LocationAccuracy.best,
                intervalDuration: Duration(seconds: 60),
                // ! change interval duration to min (3min or 5min) before deployment
              ),
              builder: (context, locationSnapShot) {
                if (locationSnapShot.connectionState ==
                    ConnectionState.waiting) {
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
                if (currentCoordinates == null &&
                    openCloseLocationPage == false) {
                  print("In Location page");
                  return LocationScreen(
                      updatedOpenCloseLocation: updateLocationBool);
                }
                // ? reason assigning false is because when user in current state the bool check will always be true . Until user restart / kills the app
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
                      return noInternetConnection(animationName2);
                    }
                    validateAndStoreUserDetails(currentCoordinates.latitude,
                        currentCoordinates.longitude);
                    fetchFiltersData();
                    return BottomNavigationBarScreens();
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
