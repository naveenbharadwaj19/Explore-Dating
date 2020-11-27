import 'package:Explore/main.dart';
import 'package:Explore/screens/acc_create_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatelessWidget {
  static const routeName = "email-page";
  @override
  Widget build(BuildContext context) {
    return Material(
          child: Container(
            color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Email Page",style:TextStyle(color: Colors.white,fontSize: 40)),
            IconButton(
              icon: Icon(Icons.check_box),
              tooltip: "successpage",
              color: Colors.red,
              iconSize: 50,
              onPressed: (){
                Navigator.pushNamed(context, AccCreatedScreen.routeName);
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app_outlined),
              color: Colors.red,
              iconSize: 50,
              onPressed: (){
                // FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, WelcomeLoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}