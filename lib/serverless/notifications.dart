// @dart=2.9
// todo : When user get's a heart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/serverless/download_photos_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Notifications {
  static bool startPagination = false;
  static List<String> doNotShowUid = [];
  static int latestAge;
  static String latestUid;
  static String headPhotoUrl = "";
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
      int oppositeUserAge = scrollUserDetails[index]["age"];
      // ? get current user head photo from cloud storage
      // check if headphotourl is empty
      if (headPhotoUrl.isEmpty) {
        // get photo
        await DownloadCloudStoragePhotos.headImageDownload(uid)
            .then((headPhoto) {
          headPhotoUrl = headPhoto;
          print("headphoto stored in memory");
        });
      }
      // ? update the document
      DocumentReference notificationsData =
          FirebaseFirestore.instance.doc("Notifications/$oppositeUserUid");
      // batch
      WriteBatch batch = FirebaseFirestore.instance.batch();
      // ? unzip secure storage datas
      readAll().then((ssValues) async {
        batch.update(notificationsData, {
          "received_hearts_info": FieldValue.arrayUnion([
            {
              "uid": uid,
              "age": ssValues["age"],
              "name": ssValues["name"],
              "head_photo": headPhotoUrl,
              // "time": currentDateTime,
              "swiped_right": false,
            },
          ]),
          "received_hearts_uid": FieldValue.arrayUnion([
            uid,
          ]),
          "uid": oppositeUserUid,
          "age": oppositeUserAge,
        });
        batch.commit();
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
          int oppositeUserAge = scrollUserDetails[index]["age"];
          DocumentSnapshot checkDocInfo = await FirebaseFirestore.instance
              .doc("Notifications/$oppositeUserUid")
              .get();
          String fullPath = checkDocInfo.reference.path;
          //  create new sub collection and doc
          // ? get current user head photo from cloud storage
          // check if headphotourl is empty
          if (headPhotoUrl.isEmpty) {
            // get photo
            await DownloadCloudStoragePhotos.headImageDownload(uid)
                .then((headPhoto) {
              headPhotoUrl = headPhoto;
              print("headphoto stored in memory");
            });
          }
          // ? create document
          DocumentReference notificationsData = FirebaseFirestore.instance
              .doc("$fullPath/Notifications/$oppositeUserUid");
          // ? unzip secure storage datas
          readAll().then((ssValues) async {
            await notificationsData.set({
              "received_hearts_info": FieldValue.arrayUnion([
                {
                  "uid": uid,
                  "age": ssValues["age"],
                  "name": ssValues["name"],
                  "head_photo": headPhotoUrl,
                  // "time": currentDateTime,
                  "swiped_right": false,
                },
              ]),
              "received_hearts_uid": FieldValue.arrayUnion([
                uid,
              ]),
              "uid": oppositeUserUid,
              "age": oppositeUserAge,
            });
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
          int oppositeUserAge = scrollUserDetails[index]["age"];
          DocumentSnapshot checkDocInfo = await FirebaseFirestore.instance
              .doc("Notifications/$oppositeUserUid")
              .get();
          String fullPath = checkDocInfo.reference.path;
          //  create new sub collection and doc
          // ? get current user head photo from cloud storage
          // check if headphotourl is empty
          if (headPhotoUrl.isEmpty) {
            // get photo
            await DownloadCloudStoragePhotos.headImageDownload(uid)
                .then((headPhoto) {
              headPhotoUrl = headPhoto;
              print("headphoto stored in memory");
            });
          }
          // ? create document
          DocumentReference notificationsData = FirebaseFirestore.instance
              .doc("$fullPath/Notifications/$oppositeUserUid");
          // ? unzip secure storage datas
          readAll().then((ssValues) async {
            await notificationsData.set({
              "received_hearts_info": FieldValue.arrayUnion([
                {
                  "uid": uid,
                  "age": ssValues["age"],
                  "name": ssValues["name"],
                  "head_photo": headPhotoUrl,
                  // "time": currentDateTime,
                  "swiped_right": false,
                },
              ]),
              "received_hearts_uid": FieldValue.arrayUnion([
                uid,
              ]),
              "uid": oppositeUserUid,
              "age": oppositeUserAge,
            });
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
        // print("No pagination");
        var queryNotifications = await FirebaseFirestore.instance
            .collectionGroup("Notifications")
            .where("received_hearts_uid", arrayContains: myUid)
            .orderBy("age")
            .orderBy("uid")
            // .limit(limit) // ! check CRUD
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
          print("latest noti : $latestUid : $latestAge");
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
            .where("received_hearts_uid", arrayContains: myUid)
            .orderBy("age")
            .orderBy("uid")
            .startAfter([latestAge, latestUid])
            // .limit(paginatelimit) //! check CRUD
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
          print("latest noti : $latestUid : $latestAge");
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

  static Future<List> showNotifications() async {
    try {
      String myUid = FirebaseAuth.instance.currentUser.uid;
      List users = [];
      // "7Hsr2gfBRvaByEJrudUmP3HsOWI3"
      QuerySnapshot query = await FirebaseFirestore.instance
          .collectionGroup("Notifications")
          .where("uid", isEqualTo: myUid)
          .orderBy("received_hearts_info")
          .limit(1)
          .get();
        
      var zipList = query.docs.map((e) => e["received_hearts_info"]);
      zipList.toList().forEach((element) {
        element.forEach((element2) {
          if (!element2["swiped_right"]) {
            // print(element2);
            // add swiped_right == false to the users list
            users.add(element2);
          }
        });
      });
      // print(users);
      return users;
    } catch (error) {
      print("Error in showing notified users : ${error.toString()}");
      return [];
    }
  }

  static notificationAccepted(
      {@required dynamic data, @required int index}) async {
    try {
      // ? accepted
      String myUid = FirebaseAuth.instance.currentUser.uid;
      String oppositeUserId = data[index]["uid"];
      List fetchedInfo = []; // received_hearts_info
      DocumentReference notificationReference =
          FirebaseFirestore.instance.doc("Notifications/$myUid");
      // transaction
      FirebaseFirestore.instance.runTransaction((transaction) async {
        // get the document
        DocumentSnapshot notificationsData =
            await transaction.get(notificationReference);
        // add rec_hearts_info to fetchedInfo
        fetchedInfo.addAll(notificationsData.get("received_hearts_info"));
        // update the map of rec_hearts_info
        fetchedInfo.forEach((element) {
          if (element["uid"] == oppositeUserId) {
            Map heartInfo = element;
            // update swipe_right
            heartInfo["swiped_right"] = true;
          }
        });
        // update the document
        transaction.update(notificationReference, {
          "received_hearts_info": fetchedInfo,
        });
        print("$oppositeUserId accepted from user notifications");
      });
    } catch (error) {
      print(
          "Error in updating accepeted user -> notifications : ${error.toString()}");
    }
  }

  static Future<void> notificationRejected(
      {@required dynamic data, @required int index}) async {
    try {
      // ? rejection
      String myUid = FirebaseAuth.instance.currentUser.uid;
      List fetchedUid = []; // received_hearts_uid
      List fetchedInfo = []; // received_hearts_info
      String oppositeUserId = data[index]["uid"];
      int removeEmptyMapidx = 0;
      DocumentReference notificationReference =
          FirebaseFirestore.instance.doc("Notifications/$myUid");
      // transaction
      FirebaseFirestore.instance.runTransaction((transaction) async {
        // get the document
        DocumentSnapshot notificationsData =
            await transaction.get(notificationReference);
        // add rec_hearts_uid to fetcheduid
        fetchedUid.addAll(notificationsData.get("received_hearts_uid"));
        // add rec_hearts_info to fetchedInfo
        fetchedInfo.addAll(notificationsData.get("received_hearts_info"));
        // remove the rejected uid
        int idxToRemoveInUid = fetchedUid.indexOf(oppositeUserId);
        fetchedUid.removeAt(idxToRemoveInUid);
        // remove map from rec_hearts_info
        fetchedInfo.forEach((element) {
          if (element["uid"] == oppositeUserId) {
            Map heartInfo = element;
            heartInfo.clear(); // clear key.values
            // get the index of empty map
            if (heartInfo.isEmpty) {
              int idx = fetchedInfo.indexOf(heartInfo);
              // print("idx: $idx");
              removeEmptyMapidx = idx;
            }
          }
        });
        // remove idx from hearts info
        fetchedInfo.removeAt(removeEmptyMapidx);
        // update the document
        transaction.update(notificationReference, {
          "received_hearts_uid": fetchedUid,
          "received_hearts_info": fetchedInfo,
        });
        print("$oppositeUserId removed from user notifications");
      });
    } catch (error) {
      print(
          "Error in deleting rejected user -> notifications : ${error.toString()}");
    }
  }
}
