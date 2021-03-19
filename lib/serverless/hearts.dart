// @dart=2.9
// todo : Trigger when user press heart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/serverless/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Hearts {
  static Widget heartanimation(double size) {
    return Icon(
      Icons.favorite,
      color: Colors.red,
      size: size,
    );
  }

  static Future<void> storeHeartInfo(
      {@required int index, @required BuildContext context}) async {
    // * 25 W , 25 R
    try {
      final now = DateTime.now();
      String userUid = FirebaseAuth.instance.currentUser.uid;
      String oppositeUserUid = scrollUserDetails[index]["uid"];
      String currentDate = DateFormat("dd-MM-yyyy").format(now);
      DocumentSnapshot checkDocinfo = await FirebaseFirestore.instance
          .doc("Users/$userUid/Hearts/$currentDate")
          .get();
      // ? check if document exist
      if (checkDocinfo.exists) {
        // ? doc id exist
        if (checkDocinfo.get("press_limit") == 25) {
          // check if user reached limit
          print("User reached the daily limit");
          Flushbar(
            backgroundColor: Color(0xff121212),
            messageText: const Text(
              // ! change text message
              "Limit exceeded",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 1),
          )..show(context);
        } else {
          if (!scrollUserDetails[index]["heart"] &&
              !scrollUserDetails[index]["lock_heart_star"]) {
            // trigger if user hasn't pressed heart
            String currentDateTime =
                DateFormat('dd-MM-yyyy:hh:mm:ss:a').format(now); // 12 hr format
            String fullPath = checkDocinfo.reference.path;
            DocumentReference heartInfo =
                FirebaseFirestore.instance.doc(fullPath);
            await heartInfo.update({
              "heart_pressed": FieldValue.arrayUnion([
                {
                  "opposite_uid": oppositeUserUid,
                  "time": currentDateTime,
                },
              ]),
              "press_limit": FieldValue.increment(1),
              "time_limit": FieldValue.serverTimestamp(),
            });
            // update heart value and lock
            scrollUserDetails[index]["heart"] = true;
            scrollUserDetails[index]["lock_heart_star"] = true;
            // notifications
            Notifications.storeNotifications(
                index: index, currentDateTime: currentDateTime);
            print("heart info updated in firestore");
          }
        }
      } else if (!checkDocinfo.exists) {
        // ? doc id do not exist
        String currentDateTime =
            DateFormat('dd-MM-yyyy:hh:mm:ss:a').format(now);
        String fullPath = checkDocinfo.reference.path;
        DocumentReference heartInfo = FirebaseFirestore.instance.doc(fullPath);
        // create data
        await heartInfo.set({
          "heart_pressed": FieldValue.arrayUnion([
            {
              "opposite_uid": oppositeUserUid,
              "time": currentDateTime,
            },
          ]),
          "press_limit": 1,
          "time_limit": FieldValue.serverTimestamp(),
        });
        // update heart value and lock
        scrollUserDetails[index]["heart"] = true;
        scrollUserDetails[index]["lock_heart_star"] = true;
        // notifications
        Notifications.storeNotifications(
            index: index, currentDateTime: currentDateTime);
        print("heart info created in firestore");
      }
    } catch (error) {
      print("Error in storing heart info : ${error.toString()}");
    }
  }
}
