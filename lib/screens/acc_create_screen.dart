import 'package:explore/models/firestore_signup.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

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
              margin: EdgeInsets.symmetric(vertical: 50),
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
              // ! Place continue button in center of the screen
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 180,
                margin: EdgeInsets.only(bottom:30),
                child: RaisedButton(
                  color: Color(0xffF8C80D),
                  textColor: Color(0xff121212),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Color(0xffF8C80D))),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    // manageSigninLogin = false;
                    OnlyDuringSignupFirestore.updateAccSuccPage(context);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
