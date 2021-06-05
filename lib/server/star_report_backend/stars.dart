// @dart=2.9
// todo when user press star button
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/models/all_enums.dart';
import 'package:explore/models/vibration.dart';
import 'package:explore/screens/chats/pop_up_chat_screen.dart';
import 'package:explore/server/star_report_backend/stars_rtdb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';

class Stars {
  static Widget starAnimation() {
    return Lottie.asset(
      "assets/animations/star_final.json",
      height: 40,
      width: 40,
      fit: BoxFit.cover,
    );
  }

  static Future<void> storeStarInfo(
      {@required index,
      @required PreviewType previewType,
      @required BuildContext context}) async {
    try {
      // * 7 R ,7 W
      final now = DateTime.now();
      String userUid = FirebaseAuth.instance.currentUser.uid;
      String oppositeUserUid = scrollUserDetails[index]["uid"];
      String currentDate =
          DateFormat("dd-MM-yyyy").format(now); // device current date
      DateTime currentNTPDate = await NTP.now();
      String convertedNTP =
          DateFormat("dd-MM-yyyy").format(currentNTPDate); // NTP date
      // check if current date and ntp does not match
      if (currentDate != convertedNTP) {
        currentDate = convertedNTP; // overwrite ntp date to current date
      }
      DocumentSnapshot checkDocinfo = await FirebaseFirestore.instance
          .doc("Users/$userUid/Stars/$currentDate")
          .get();
      // ? check if document exist
      if (checkDocinfo.exists) {
        // ? doc id exist
        if (checkDocinfo.get("press_limit") == 7) {
          // check if user reached limit
          print("User reached the daily limit");
          Flushbar(
            backgroundColor: Color(0xff121212),
            messageText: const Text(
              "You have exceeded your daily limit! You cannot star anyone else today.Try again tomorrow.",
              maxLines: 2,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            duration: Duration(seconds: 3),
          )..show(context);
        } else if (checkDocinfo.get("press_limit") > 8) {
          // manipulating stars
          // delete account
          DocumentReference userData =
              FirebaseFirestore.instance.doc("Users/$userUid");
          await userData.update({"is_delete": true});
        } else {
          if (!scrollUserDetails[index]["star"]) {
            // trigger if user hasn't pressed star
            // HapticFeedback.mediumImpact(); // vibrate when pressed
            vibrate(50); // vibrate when pressed
            String currentDateTime =
                DateFormat('dd-MM-yyyy:hh:mm:ss:a').format(now); // 12 hr format
            String fullPath = checkDocinfo.reference.path;
            DocumentReference starInfo =
                FirebaseFirestore.instance.doc(fullPath);
            await starInfo.update({
              "star_pressed": FieldValue.arrayUnion([
                {
                  "opposite_uid": oppositeUserUid,
                  "time": currentDateTime,
                },
              ]),
              "press_limit": FieldValue.increment(1),
              "latest_time": FieldValue.serverTimestamp(),
            });
            // update star value and lock report
            scrollUserDetails[index]["star"] = true;
            scrollUserDetails[index]["lock_report"] = true;
            print("star info updated in firestore");
            popUpChatBottomSheet(index, previewType, context);
            starsRTDB(oppositeUserUid);
          }
        }
      } else if (!checkDocinfo.exists) {
        // ? doc id do not exist
        if (!scrollUserDetails[index]["star"]) {
          // HapticFeedback.mediumImpact();
          vibrate(50); // vibrate when pressed
          String currentDateTime =
              DateFormat('dd-MM-yyyy:hh:mm:ss:a').format(now);
          String fullPath = checkDocinfo.reference.path;
          DocumentReference starInfo = FirebaseFirestore.instance.doc(fullPath);
          // create data
          await starInfo.set({
            "star_pressed": FieldValue.arrayUnion([
              {
                "opposite_uid": oppositeUserUid,
                "time": currentDateTime,
              },
            ]),
            "press_limit": 1,
            "latest_time": FieldValue.serverTimestamp(),
          });
          // update star value and lock report
          scrollUserDetails[index]["star"] = true;
          scrollUserDetails[index]["lock_report"] = true;
          print("star info created in firestore");
          popUpChatBottomSheet(index, previewType, context);
          starsRTDB(oppositeUserUid);
        }
      }
    } catch (error) {
      print("Error in storing star info : ${error.toString()}");
    }
  }
}
