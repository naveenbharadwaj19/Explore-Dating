// todo : When user get's a heart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Notifications {
  static bool startPagination = false;
  static List<String> doNotShowUid = [];
  static int latestAge;
  static String latestUid;
  static void resetLatestDocs() {
    latestAge = 0;
    latestUid = "";
  }

  static Future<void> storeNotifications(
      {@required int index, @required String currentDateTime}) async {
    // * 25 W -> hearts
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      String oppositeUserUid = scrollUserDetails[index]["uid"];
      int age = scrollUserDetails[index]["age"];
      // ? update the document
      DocumentReference notificationsData =
          FirebaseFirestore.instance.doc("Notifications/$oppositeUserUid");
      await notificationsData.update({
        "received_hearts": FieldValue.arrayUnion([
          uid,
        ]),
        "uid": oppositeUserUid,
        "age": age,
      });
      print(
          "uid : $uid created and stored successfully in opposite user : $oppositeUserUid notification");
    } catch (error) {
      if (error.toString().contains(
          "INVALID_ARGUMENT: A document cannot be written because it exceeds the maximum size allowed")) {
        // ? if document reached 1 Mb limit
        try {
          // * 1 W , 1 R
          String uid = FirebaseAuth.instance.currentUser.uid;
          String oppositeUserUid = scrollUserDetails[index]["uid"];
          int age = scrollUserDetails[index]["age"];
          DocumentSnapshot checkDocInfo = await FirebaseFirestore.instance
              .doc("Notifications/$oppositeUserUid")
              .get();
          String fullPath = checkDocInfo.reference.path;
          //  create new sub collection and doc
          DocumentReference notificationsData = FirebaseFirestore.instance
              .doc("$fullPath/Notifications/$oppositeUserUid");
          await notificationsData.set({
            "received_hearts": FieldValue.arrayUnion([
              uid,
            ]),
            "uid": oppositeUserUid,
            "age": age,
          });
          print(
              "notifications -> doc id -> reached 1Mb. Creating sub collection");
        } catch (error) {
          print(
              "Error in creating notifications collection. document size reached 1Mb");
        }
      } else if (error
          .toString()
          .contains("INVALID_ARGUMENT: too many index entries for entity")) {
        // ? when documents cannot be indexed
        try {
          // * 1 W , 1 R
          String uid = FirebaseAuth.instance.currentUser.uid;
          String oppositeUserUid = scrollUserDetails[index]["uid"];
          int age = scrollUserDetails[index]["age"];
          DocumentSnapshot checkDocInfo = await FirebaseFirestore.instance
              .doc("Notifications/$oppositeUserUid")
              .get();
          String fullPath = checkDocInfo.reference.path;
          //  create new sub collection and doc
          DocumentReference notificationsData = FirebaseFirestore.instance
              .doc("$fullPath/Notifications/$oppositeUserUid");
          await notificationsData.set({
            "received_hearts": FieldValue.arrayUnion([
              uid,
            ]),
            "uid": oppositeUserUid,
            "age": age,
          });
          print(
              "notifications -> doc id -> reached max index. Creating sub collection");
        } catch (error) {
          print(
              "Error in creating notifications collection. Too many index to rearrange. Possible reason fields might have more than 40K index");
        }
      } else {
        print("Error in notifications -> doc id : ${error.toString()}");
      }
    }
  }

  static Future<void> queryNotifications(
      {@required int limit, @required int paginatelimit}) async {
    try {
      // * No of documents R -> limit & paginate limit
      String myUid = FirebaseAuth.instance.currentUser.uid;
      if (!startPagination) {
        print("No pagination");
        var queryNotifications = await FirebaseFirestore.instance
            .collectionGroup("Notifications")
            .where("received_hearts", arrayContains: myUid)
            .orderBy("age")
            .orderBy("uid")
            .limit(limit)
            .get();
        // add retrieved doc to the list
        queryNotifications.docs.forEach((data) {
          doNotShowUid.add(data.id);
        });
        // ? get latest documents
        try {
          latestAge = queryNotifications
              .docs[queryNotifications.docs.length - 1]
              .get("age");
          latestUid = queryNotifications
              .docs[queryNotifications.docs.length - 1]
              .get("uid");
          // print("latest noti : $latestUid : $latestAge");
        } on RangeError {
          // print("No more notification details to query");
          latestAge = 0;
          latestUid = "";
        }

        // ? turn on pagination
        startPagination = true;
      } else if (startPagination) {
        var queryNotifications = await FirebaseFirestore.instance
            .collectionGroup("Notifications")
            .where("received_hearts", arrayContains: myUid)
            .orderBy("age")
            .orderBy("uid")
            .startAfter([latestAge, latestUid])
            .limit(paginatelimit)
            .get();
        // add retrieved doc to the list
        queryNotifications.docs.forEach((data) {
          doNotShowUid.add(data.id);
        });
        // ? get latest documents
        // ? get latest documents
        try {
          latestAge = queryNotifications
              .docs[queryNotifications.docs.length - 1]
              .get("age");
          latestUid = queryNotifications
              .docs[queryNotifications.docs.length - 1]
              .get("uid");
          // print("latest noti : $latestUid : $latestAge");
        } on RangeError {
          // print("No more notification details to query");
          latestAge = 0;
          latestUid = "";
        }
      }
    } catch (error) {
      print("Error in querying notifications : ${error.toString()}");
    }
  }
}
