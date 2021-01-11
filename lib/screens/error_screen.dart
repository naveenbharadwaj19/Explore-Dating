// todo When user account doest exist

import 'package:flutter/material.dart';

class WhenUserIdNotExistInFirestore extends StatelessWidget {
  // * when users -> id - deleted , not found in firestore
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff121212),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            "Something went wrong",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                decoration: TextDecoration.none),
          ),
          Padding(padding: EdgeInsets.all(10),),
          Text(
            "Error : 404",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                decoration: TextDecoration.none),
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
                "Okay",
                style: TextStyle(
                    fontFamily: "Nunito",
                    // fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              onPressed: () {
              },
            ),
          ),
        ],
      ),
    );
  }
}
