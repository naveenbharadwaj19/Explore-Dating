// @dart=2.9
// todo individual chat backend

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/private/database_url_rtdb.dart';
import 'package:explore/server/cloud_storage/delete_photos_cloud_storage.dart';
import 'package:explore/server/cloud_storage/download_photos_storage.dart';
import 'package:explore/server/cloud_storage/upload_photos_cloud_storage.dart';
import 'package:explore/widgets/chats/url_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';

class IndividualChatBackEnd {
  static Future<void> boomMessage(
      {@required String message,
      @required String path,
      @required BuildContext context,
      @required String uid1}) async {
    // * opposite user message first time
    try {
      DateTime nTPTime = await NTP.now();
      DocumentReference data = FirebaseFirestore.instance.doc(path);
      String myUid = FirebaseAuth.instance.currentUser.uid;
      List canSend = [
        {"uid": uid1, "permission": true},
        {"uid": myUid, "permission": true},
      ];
      await data.update({
        "automatic_unmatch": false,
        "latest_time": FieldValue.serverTimestamp(),
        "can_send": canSend,
        "messages": FieldValue.arrayUnion([
          {
            "msg_content": message,
            "sender_uid": myUid,
            "show_url_preview": false,
            "time_sent": nTPTime,
          }
        ]),
        "doc_limit": FieldValue.increment(1),
      });
      print("Boom message stored successfully");
    } catch (e) {
      print("Error in boomMessage ${e.toString()}");
      Flushbar(
          messageText: Center(
            child: const Text(
              "Message failed to send",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(context);
    }
  }

  static Future<void> casualMessages(
      {@required String path,
      @required String message,
      @required BuildContext context,
      bool messageHasUrl = false}) async {
    try {
      DocumentReference data = FirebaseFirestore.instance.doc(path);
      String myUid = FirebaseAuth.instance.currentUser.uid;
      DateTime nTPTime = await NTP.now();
      //  * start transaction
      if (messageHasUrl) {
        // if message has url
        getUrlData(message).then((urlData) {
          // unzip url data
          data.update({
            "messages": FieldValue.arrayUnion([
              {
                "msg_content": {
                  "title": urlData["title"],
                  "image": urlData["image"],
                  "url": urlData["url"]
                },
                "sender_uid": myUid,
                "show_url_preview": true,
                "time_sent": nTPTime,
              }
            ]),
            "latest_time": FieldValue.serverTimestamp(),
            "doc_limit": FieldValue.increment(1)
          });
          print("Casual message stored successfully and it's a url link");
        });
      } else if (!messageHasUrl) {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapShot = await transaction.get(data);
          if (snapShot.get("doc_limit") >= 10 &&
              !snapShot.get("can_send_photos")) {
            transaction.update(data, {
              "messages": FieldValue.arrayUnion([
                {
                  "msg_content": message,
                  "sender_uid": myUid,
                  "show_url_preview": false,
                  "time_sent": nTPTime,
                }
              ]),
              "latest_time": FieldValue.serverTimestamp(),
              "can_send_photos": true,
              "doc_limit": FieldValue.increment(1)
            });
            print("Unlocked photos option");
          } else if (snapShot.get("doc_limit") >= 650) {
            // if document size reached 650 + create new room
            transaction.update(
                data, {"show_this": false}); // set false to the previous room
            _createNewDoc(
                path: snapShot.reference.path,
                name0: snapShot.get("names").first["name"],
                name1: snapShot.get("names").last["name"],
                uid1: snapShot.get("uid1"),
                uid2: snapShot.get("uid2"),
                expireTime: snapShot.get("expire_time").toDate(),
                message: message,
                headPhoto0: snapShot.get("head_photos").first["head_photo"],
                headPhoto1: snapShot
                    .get("head_photos")
                    .last["head_photo"]); // create new room
          } else {
            transaction.update(data, {
              "messages": FieldValue.arrayUnion([
                {
                  "msg_content": message,
                  "sender_uid": myUid,
                  "show_url_preview": false,
                  "time_sent": nTPTime,
                }
              ]),
              "latest_time": FieldValue.serverTimestamp(),
              "doc_limit": FieldValue.increment(1)
            });
            print("Casual message stored successfully");
          }
        });
      }
    } catch (e) {
      if (e.toString().contains(
          "INVALID_ARGUMENT: A document cannot be written because it exceeds the maximum size allowed")) {
        // ? when document size reached 1 mb
        try {
          DocumentReference data = FirebaseFirestore.instance.doc(path);
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot snapShot = await transaction.get(data);
            transaction.update(
                data, {"show_this": false}); // set false to the previous room
            _createNewDoc(
                path: snapShot.reference.path,
                name0: snapShot.get("names").first["name"],
                name1: snapShot.get("names").last["name"],
                uid1: snapShot.get("uid1"),
                uid2: snapShot.get("uid2"),
                expireTime: snapShot.get("expire_time").toDate(),
                message: message,
                headPhoto0: snapShot.get("head_photos").first["head_photo"],
                headPhoto1: snapShot
                    .get("head_photos")
                    .last["head_photo"]); // create new room
          });
        } catch (e) {
          print(
              "Error in creating room in chats error occured in 1Mb document size : ${e.toString()}");
        }
      } else if (e
          .toString()
          .contains("INVALID_ARGUMENT: too many index entries for entity")) {
        // ? when document cannot be indexed
        try {
          DocumentReference data = FirebaseFirestore.instance.doc(path);
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot snapShot = await transaction.get(data);
            transaction.update(
                data, {"show_this": false}); // set false to the previous room
            _createNewDoc(
                path: snapShot.reference.path,
                name0: snapShot.get("names").first["name"],
                name1: snapShot.get("names").last["name"],
                uid1: snapShot.get("uid1"),
                uid2: snapShot.get("uid2"),
                expireTime: snapShot.get("expire_time").toDate(),
                message: message,
                headPhoto0: snapShot.get("head_photos").first["head_photo"],
                headPhoto1: snapShot
                    .get("head_photos")
                    .last["head_photo"]); // create new room
          });
        } catch (e) {
          print(
              "Error in creating room in chats error occured in maxium index : ${e.toString()}");
        }
      }
      print("Error in casual messages : ${e.toString()}");
      Flushbar(
          messageText: Center(
            child: const Text(
              "Message failed to send",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(context);
    }
  }

  static Future<void> _createNewDoc(
      {@required String path,
      @required String name0,
      @required String name1,
      @required String uid1,
      @required String uid2,
      @required DateTime expireTime,
      @required String message,
      @required String headPhoto0,
      @required String headPhoto1}) async {
    // create new doc when doc limit exceed or when maxiumum size reached
    try {
      String getRoom = path.split("/").last;
      String newRoomNumber = _extractNumberFromStr(getRoom);
      String newRoomName = "room$newRoomNumber";
      String newPath = path.replaceFirst(getRoom, newRoomName);
      String myUid = FirebaseAuth.instance.currentUser.uid;
      DateTime currentNTPTime = await NTP.now(); // NTP timestamp
      DocumentReference data = FirebaseFirestore.instance.doc(newPath);
      await data.set({
        "uid1": uid1,
        "uid2": uid2,
        "automatic_unmatch": false,
        "uids": FieldValue.arrayUnion([uid1, uid2]),
        "expire_time": expireTime,
        "latest_time": FieldValue.serverTimestamp(),
        "show_this": true,
        "can_send": FieldValue.arrayUnion([
          {"uid": uid1, "permission": true},
          {"uid": uid2, "permission": true}
        ]),
        "messages": FieldValue.arrayUnion([
          {
            "msg_content": message,
            "sender_uid": myUid,
            "show_url_preview": false,
            "time_sent": currentNTPTime,
          }
        ]),
        "can_send_photos": true,
        "doc_limit": FieldValue.increment(1),
        "names": FieldValue.arrayUnion([
          {"uid": uid1, "name": name0},
          {"uid": uid2, "name": name1},
        ]),
        "head_photos": FieldValue.arrayUnion([
          {"uid": uid1, "head_photo": headPhoto0},
          {"uid": uid2, "head_photo": headPhoto1},
        ]),
      });
      print("Created new room in chats and all data stored successfully");
    } catch (e) {
      print("Error in creating new doc in chats : ${e.toString()}");
    }
  }

  static String _extractNumberFromStr(String extract) {
    // extract only number from str
    // increment it
    // convert back to str
    String extractNumberFromStr = extract.replaceAll(RegExp(r'[^0-9]'), "");
    int toInt = int.tryParse(extractNumberFromStr);
    toInt += 1;
    return toInt.toString();
  }

  static Future<void> photoProcess(
      String photoPath, String path, BuildContext context) async {
    // when user uploads photo
    try {
      await uploadPhotosOfIndividualChatToCloudStorage(
          photoPath, path, context); // upload photo
      DownloadCloudStoragePhotos.individualPhotoDownload(photoPath, path)
          .then((photo) async {
        if (photo.isNotEmpty && !photo.contains("Cannot get image url")) {
          casualMessages(
              path: path, message: photo,context: context); // upload the image url to db
          print("Photo url stored successfully in db");
        }
      });
    } catch (e) {
      print("Error in photo process individual chat : ${e.toString()}");
    }
  }

  static Future<void> deletePhotoFromDb(
      String photoUrl, String senderUid, DateTime timeSent, String path) async {
    // delete viewed photo from db
    // delete from cloud storage
    try {
      DocumentReference data = FirebaseFirestore.instance.doc(path);
      await data.update({
        "messages": FieldValue.arrayRemove([
          {
            "msg_content": photoUrl,
            "sender_uid": senderUid,
            "show_url_preview": false,
            "time_sent": timeSent,
          }
        ])
      });
      deletePhotoChatsFromCloudStorage(photoUrl);
      print("Photo deleted successfully");
    } catch (e) {
      print("Error in deleting photo from Db : ${e.toString()}");
    }
  }

  static Future<void> detectTyping(String path, String myUid,
      {bool isTyping = true}) async {
    // rtdb
    try {
      String docId = path.split("/")[1]; // random auto id
      if (isTyping) {
        DatabaseReference db = FirebaseDatabase(databaseURL: dataBaseUrlRTDB)
            .reference()
            .child(docId);
        await db.update({
          myUid: true,
        });
      } else {
        DatabaseReference db = FirebaseDatabase(databaseURL: dataBaseUrlRTDB)
            .reference()
            .child(docId);
        await db.update({
          myUid: false,
        });
      }
    } catch (e) {
      print("Error in detectTyping rtdb : ${e.toString()}");
    }
  }

  static Future<void> storeTyping(String docId, String uid1, String uid2) async {
    // rtdb
    try {
      DatabaseReference db = FirebaseDatabase(databaseURL: dataBaseUrlRTDB)
          .reference()
          .child(docId);
      await db.update({
        uid1: false,
        uid2: false,
      });
      print("Stored typing info in rtdb successfully");
    } catch (e) {
      print("Error in storeTyping rtdb : ${e.toString()}");
    }
  }
}
