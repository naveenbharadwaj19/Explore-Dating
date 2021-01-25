import 'package:connectivity/connectivity.dart';
import 'package:explore/data/auth_data.dart';
import 'package:explore/models/handle_delete_logout.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/screens/acc_create_screen.dart';
import 'package:explore/screens/error_screen.dart';
import 'package:explore/screens/google_dob_screen.dart';
import 'package:explore/screens/emai_verf_screen.dart';
import 'package:explore/screens/gender_screen.dart';
import 'package:explore/screens/location_screen.dart';
import 'package:explore/screens/no_internet_connection_screen.dart';
import 'package:explore/screens/pick_photos_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/screens/show_me_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "home-page";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _animationName = "SearchLocation";
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
      print("Bad document during home screen error suppressed");
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
    print("gender : $selectedGenderM , age : $ageM");
    return StreamBuilder(
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
        if (checkUserStatus["isloggedin"] == true &&
            checkUserStatus["isdeleted"] == true) {
          print("No user data exist in firestore and in deletation page");
          return WhenUserIdNotExistInFirestore();
        }
        return StreamBuilder(
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

            if (!accessCheck["account_success_page"]) {
              print("In account success page");
              return AccCreatedScreen();
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
            return StreamBuilder<Position>(
              // ? help to get the on time location
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
                      height: 300,
                      // width: 300,
                      child: FlareActor(
                        "assets/animations/location_pin.flr",
                        fit: BoxFit.cover,
                        animation: _animationName,
                      ),
                    ),
                  );
                }
                // if (locationSnapShot.hasError) {
                //   print("Facing error in location stream");
                //   return Center(
                //     child: Container(
                //       height: 300,
                //       // width: 300,
                //       child: FlareActor(
                //         "assets/animations/location_pin.flr",
                //         fit: BoxFit.cover,
                //         animation: _animationName,
                //       ),
                //     ),
                //   );
                // }
                final Position currentCoordinates = locationSnapShot.data;
                print("CurrentCoordinates : $currentCoordinates");
                if (currentCoordinates == null &&
                    openCloseLocationPage == false) {
                  print("In Location page");
                  return LocationScreen(
                      updatedOpenCloseLocation: updateLocationBool);
                }
                // ? reason assigning false is because when user in current state the bool check will always be true . Until user restart / kills the app
                openCloseLocationPage = false;

                return StreamBuilder(
                  // ? check for internet connectivity
                  stream: Connectivity().onConnectivityChanged,
                  builder: (context, internetConnection) {
                    if (internetConnection.connectionState ==
                            ConnectionState.waiting ||
                        internetConnection.hasError ||
                        !internetConnection.hasData) {
                      print(
                          "Fetching connectivity status.Will show loading spinner");
                      return Center(child: loadingSpinner());
                    }
                    print("ConnectionStatus : ${internetConnection.data}");
                    if (internetConnection.data == ConnectivityResult.none) {
                      print("Cannot find internet connection");
                      return noInternetConnection(animationName2);
                    }
                    return Material(
                      child: Container(
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Home Screen",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 40)),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              iconSize: 50,
                              onPressed: () {
                                deleteAuthDetails();
                                // deleteUserPhotosInCloudStorage();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.exit_to_app_outlined),
                              color: Colors.red,
                              iconSize: 50,
                              onPressed: () => logoutUser(),
                            ),
                            IconButton(
                              icon: Icon(Icons.call),
                              color: Colors.red,
                              iconSize: 50,
                              onPressed: () async{
                                // print(
                                //     FirebaseAuth.instance.currentUser.reload());
                              },
                            ),
                          ],
                        ),
                      ),
                    );
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
