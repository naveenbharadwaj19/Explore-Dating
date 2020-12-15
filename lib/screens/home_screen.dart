import 'package:Explore/models/spinner.dart';
import 'package:Explore/screens/acc_create_screen.dart';
import 'package:Explore/screens/emai_verf_screen.dart';
import 'package:Explore/screens/gender_screen.dart';
import 'package:Explore/screens/location_screen.dart';
import 'package:Explore/screens/pick_photos_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "home-page";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .doc("Users/${FirebaseAuth.instance.currentUser.uid}")
          .snapshots(),
      builder: (context, snapShot2) {
        if (snapShot2.connectionState == ConnectionState.waiting ||
            snapShot2.hasError) {
          return Center(
            child: loadingSpinner(),
          );
        }
        final genderCheck = snapShot2.data["bio"];
        final accessCheck = snapShot2.data["access_check"];

        if (!accessCheck["email_address_verified"]) {
          print("In email verification");
          return EmailVerificationScreen();
        }
        if (!accessCheck["account_success_page"]) {
          print("In account success page");
          return AccCreatedScreen();
        }
        if (genderCheck["gender"].isEmpty) {
          print("In gender page");
          return GenderScreen();
        }
        if (!accessCheck["locationaccess"]) {
          print("In location page");
          return LocationScreen();
        }
        if (!accessCheck["top_notch_photo"] || !accessCheck["body_photo"]) {
          print("In photo page");
          return PickPhotoScreen();
        }
        return Material(
          child: Container(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Home Screen",
                    style: TextStyle(color: Colors.white, fontSize: 40)),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  iconSize: 50,
                  onPressed: () {
                    FirebaseAuth.instance.currentUser.delete();
                    print("account deleted");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app_outlined),
                  color: Colors.red,
                  iconSize: 50,
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
