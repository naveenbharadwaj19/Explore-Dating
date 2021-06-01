// @dart=2.9
// todo When user account doest exist

import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/server/handle_logout.dart';
import 'package:explore/server/https_cloud_functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AccountDeleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: const Icon(
                Icons.warning_rounded,
                color: Color(0xffF8C80D),
                size: 140,
              ),
            ),
            Spacer(),
            const Text(
              "You account has been banned",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Container(
              // rich text
              child: RichText(
                text: TextSpan(
                  text: "Your account has been banned for violating our ",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  children: [
                    TextSpan(
                        text: "Terms of Use",
                        style: TextStyle(
                          color: Theme.of(context).buttonColor,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("tapped terms of use");
                            // todo navigate to terms of use in web page
                          }),
                  ],
                ),
                maxLines: 4,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Container(
              width: 130,
              margin: const EdgeInsets.only(bottom: 20),
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Color(0xffF8C80D),
                textColor: Color(0xff121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xffF8C80D))),
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  // * delete Userstatus -> uid datas and navigate the user to welcome screen
                  logoutUser(context);
                  callUserDeleteFunction();
                  deleteAll(); // ! not deleting properly
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
