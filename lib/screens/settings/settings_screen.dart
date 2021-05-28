// @dart=2.9
// todo settings screen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';

class SettingsScreen extends StatelessWidget {
  final String emailAddress = FirebaseAuth.instance.currentUser.email;
  final String currentLoginMethod =
      FirebaseAuth.instance.currentUser.providerData.first.providerId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black12, // status bar color
          statusBarIconBrightness: Brightness
              .light, // text brightness -> light for dark app -> vice versa
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 70,
        title: Container(
          margin: const EdgeInsets.only(top: 5),
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(children: [
              const TextSpan(
                text: "Explore\n",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: "Domine",
                    decoration: TextDecoration.none),
              ),
              const TextSpan(
                text: "Dating",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Domine",
                    decoration: TextDecoration.none),
              ),
            ]),
          ),
        ),
      ),
      body: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, packageSnapShot) {
          if (packageSnapShot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // email address title
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20, left: 60),
                  child: Text(
                    "Email address",
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).buttonColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  // email address
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20, left: 60),
                  child: Text(
                    emailAddress,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Container(
                  // current login method title
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20, left: 60),
                  child: Text(
                    "Current login method",
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).buttonColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  // current login method title
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20, left: 60),
                  child: Text(
                    currentLoginMethod,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  // privacy policy button
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 30, left: 50),
                  child: Container(
                    height: 60,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).buttonColor,
                      splashColor: Colors.white54,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: Theme.of(context).buttonColor, width: 2)),
                      child: const Text(
                        "Privacy Policy",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        // todo navigate to website privacy policy
                      },
                    ),
                  ),
                ),
                Container(
                  // delete account button
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 25, left: 50),
                  child: Container(
                    height: 60,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).buttonColor,
                      splashColor: Colors.red[600],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: Theme.of(context).buttonColor, width: 2)),
                      child: const Text(
                        "Delete Account",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        // todo popup -> delete account
                      },
                    ),
                  ),
                ),
                Container(
                  // logout button
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 25, left: 50),
                  child: Container(
                    height: 60,
                    width: 150,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).buttonColor,
                      splashColor: Colors.white54,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: Theme.of(context).buttonColor, width: 2)),
                      child: const Text(
                        "Logout",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        // todo popup -> delete account
                      },
                    ),
                  ),
                ),
                Container(
                  // made from love text
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // text
                        child: const Text(
                          "Made with",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                      Container(
                        // heart animation
                        margin: const EdgeInsets.only(left: 2),
                        child: Lottie.asset(
                          "assets/animations/heart_final.json",
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      ),
                      const Text(
                        "from India",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  // app version
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    !packageSnapShot.hasData ? "" :"V ${packageSnapShot.data.version}",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
