// todo When user account doest exist

import 'package:explore/models/handle_delete_logout.dart';
import 'package:flutter/material.dart';

class WhenUserIdNotExistInFirestore extends StatelessWidget {
  // * when users -> id - deleted , not found in firestore
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xff121212),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top:25),
              child: Icon(
                Icons.block_flipped,
                color: Color(0xffF8C80D),
                size: 150,
              ),
            ),
            Spacer(),
            Text(
              "Error : 404",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  decoration: TextDecoration.none),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Text(
              "Your account has been deleted for violating our terms",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.none),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: IconButton(
                color: Colors.white,
                iconSize: 35,
                icon: Icon(Icons.help),
                onPressed: () {},
                tooltip: "Help",
              ),
            ),
            Spacer(),
            Container(
              width: 125,
              margin: EdgeInsets.only(bottom: 20),
              child: RaisedButton(
                color: Color(0xffF8C80D),
                textColor: Color(0xff121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xffF8C80D))),
                child: Text(
                  "Ok",
                  style: TextStyle(
                      fontFamily: "Nunito",
                      // fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                onPressed: () {
                  // * delete Userstatus -> uid datas and navigate the user to welcome screen
                  deleteUserStatus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
