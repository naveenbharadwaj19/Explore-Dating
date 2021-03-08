// todo When user account doest exist

import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/models/handle_deletes_logout.dart';
import 'package:explore/models/https_cloud_functions.dart';
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
              margin: const EdgeInsets.only(top: 25),
              child: const Icon(
                Icons.block_flipped,
                color: Color(0xffF8C80D),
                size: 150,
              ),
            ),
            Spacer(),
            const Text(
              "Error : 404",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  decoration: TextDecoration.none),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            const Text(
              "Your account has been deleted for violating our terms",
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
