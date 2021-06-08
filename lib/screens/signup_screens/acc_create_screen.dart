// @dart=2.9
import 'dart:async';
import 'package:explore/server/signup_process.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class AccCreatedScreen extends StatefulWidget {
  static const routeName = "acc-created";

  @override
  _AccCreatedScreenState createState() => _AccCreatedScreenState();
}

class _AccCreatedScreenState extends State<AccCreatedScreen> {
  final String _animationName = "SuccessCheck";
  bool openContinueButton = false;

  void updateButton() {
    setState(() {
      openContinueButton = true;
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      updateButton();
      print("Coninue button released");
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
    return Material(
      child: Container(
        color: Color(0xff121212),
        child: Column(
          children: [
            Container(
              height: 200,
              width: 200,
              margin: const EdgeInsets.symmetric(vertical: 50),
              child: FlareActor(
                "assets/animations/successCheck.flr",
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                animation: _animationName,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: const Text(
                "Account created successfully",
                style: const TextStyle(
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
                margin: const EdgeInsets.only(bottom: 30),
                
                child: !openContinueButton
                    ? Container()
                    // ignore: deprecated_member_use
                    : RaisedButton(
                        color: Color(0xffF8C80D),
                        textColor: Color(0xff121212),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Color(0xffF8C80D),
                            )),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          SignUpProcess.updateAccSuccPage(context);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
