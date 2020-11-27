import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:Explore/main.dart';

class AccCreatedScreen extends StatelessWidget {
  static const routeName = "acc-created";

  final String _animationName = "SuccessCheck";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xff121212),
        child: Column(
          children: [
            Container(
              height: 200,
              width: 200,
              child: FlareActor(
                "assets/animations/successCheck.flr",
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                animation: _animationName,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Account created successfully",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                color: Color(0xffF8C80D),
                textColor: Color(0xff121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: BorderSide(color: Color(0xffF8C80D))),
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, WelcomeLoginScreen.routeName);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
