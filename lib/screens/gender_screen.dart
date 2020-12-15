import 'package:Explore/data/auth_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GenderScreen extends StatelessWidget {
  static const routeName = "gender-screen";
  @override
  Widget build(BuildContext context) {
    return Material(
          child: Container(
            color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Gender Screen",style:TextStyle(color: Colors.white,fontSize: 40)),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              iconSize: 50,
              onPressed: (){
                FirebaseAuth.instance.currentUser.delete();
                print("account deleted");
                // Navigator.pushNamed(context, WelcomeLoginScreen.routeName);
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app_outlined),
              color: Colors.red,
              iconSize: 50,
              onPressed: (){
                manageSigninLogin = false;
                FirebaseAuth.instance.signOut();
                // Navigator.pushNamed(context, WelcomeLoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}