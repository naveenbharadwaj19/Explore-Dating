// @dart=2.9
// todo When user account doest exist

import 'package:explore/server/handle_deletes_logout.dart';
import 'package:explore/server/https_cloud_functions.dart';
import 'package:flutter/material.dart';

class UserAccountDisabled extends StatelessWidget {
  // * when user account disabled
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xff121212),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: const Icon(
                Icons.close,
                color: Color(0xffF8C80D),
                size: 150,
              ),
            ),
            Spacer(),
            const Text(
              "Error",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  decoration: TextDecoration.none),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            const Text(
              "Your account has been disabled for violating our terms. Click help for more information",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.none),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: IconButton(
                color: Colors.white,
                iconSize: 35,
                icon: const Icon(Icons.help),
                onPressed: () {},
                tooltip: "Help",
              ),
            ),
            Spacer(),
            Container(
              width: 125,
              margin: const EdgeInsets.only(bottom: 20),
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Color(0xffF8C80D),
                textColor: Color(0xff121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xffF8C80D))),
                child: const Text(
                  "Ok",
                  style: const TextStyle(
                      fontFamily: "Nunito",
                      // fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                onPressed: () {
                  callUserDisableFunction();
                  logoutUser(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
