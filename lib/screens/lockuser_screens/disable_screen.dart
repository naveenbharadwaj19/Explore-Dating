// @dart=2.9
// todo When user account doest exist

import 'package:explore/models/logout.dart';
import 'package:explore/server/https_cloud_functions.dart';
import 'package:flutter/material.dart';

class AccountDisabledScreen extends StatelessWidget {
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
                Icons.warning_rounded,
                color: Color(0xffF8C80D),
                size: 140,
              ),
            ),
            Spacer(),
            const Text(
              "Your account is under review",
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            const Text(
              "We have detected inappropriate behavior in your account.We will be reviewing your account to determine what action needs to be made.If you think we made a mistake contact support.",
              maxLines: 10,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              // ignore: deprecated_member_use
              child: FlatButton(
                child: Text(
                  "Contact us",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                onPressed: () => print("contact us"),
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
                  "Logout",
                  style: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  logoutUser(context);
                  disableUser();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
