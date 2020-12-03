import 'package:Explore/main.dart';
import 'package:Explore/models/email_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "home-page";
  @override
  Widget build(BuildContext context) {
    return Material(
          child: Container(
            color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home Screen",style:TextStyle(color: Colors.white,fontSize: 40)),
            IconButton(
              icon: Icon(Icons.send),
              color: Colors.red,
              iconSize: 50,
              onPressed: (){
                sendMail("dummyUserName","claw2020@gmail.com", generateFourDigitCode());
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app_outlined),
              color: Colors.red,
              iconSize: 50,
              onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, WelcomeLoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}