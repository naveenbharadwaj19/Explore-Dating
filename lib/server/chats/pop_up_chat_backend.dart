// @dart=2.9
// todo pop up chat backend

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/server/chats/individual_chat_backend.dart';
import 'package:explore/server/cloud_storage/download_photos_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';

void storeChatData(
    {@required String oppositeUid, // uid2
    @required String oppositeName,
    String messageContent = "Hello",
    @required String oppositeHeadPhotoUrl}) {
  // * entry point for chat message
  // * pop up chat
  // * uid 1 -> person who triggers the converstation
  // * uid 2 -> person who should respond within 12 hrs
  try {
    String myUid = FirebaseAuth.instance.currentUser.uid; // uid1
    FirebaseFirestore.instance.collection("Chats").add({
      "uids": FieldValue.arrayUnion([myUid, oppositeUid]),
    }).then((docRef) async {
      // ! remove server time stamp in add
      String getGeneratedDocId = docRef.id;
      IndividualChatBackEnd.storeTyping(
          getGeneratedDocId, myUid, oppositeUid); // store typing info
      DateTime currentNTPTime = await NTP.now(); // NTP timestamp
      DateTime expireTime =
          currentNTPTime.add(Duration(hours: 12)); // 12hrs ahead
      DownloadCloudStoragePhotos.headPhotoDownload(myUid).then((headPhoto) {
        // head photo
        readValue("name").then((name) async {
          // name
          if (name.isNotEmpty) {
            DocumentReference data = FirebaseFirestore.instance
                .doc("Chats/$getGeneratedDocId/Chats/room1");
            await data.set({
              "uid1": myUid,
              "uid2": oppositeUid,
              "automatic_unmatch": true,
              "uids": FieldValue.arrayUnion([myUid, oppositeUid]),
              "expire_time": expireTime,
              "latest_time": FieldValue.serverTimestamp(),
              "show_this": true,
              "can_send": FieldValue.arrayUnion([
                {"uid": myUid, "permission": false},
                {"uid": oppositeUid, "permission": true}
              ]),
              "messages": FieldValue.arrayUnion([
                {
                  "msg_content": messageContent,
                  "sender_uid": myUid,
                  "show_url_preview": false,
                  "time_sent": currentNTPTime,
                }
              ]),
              "can_send_photos": false,
              "doc_limit": FieldValue.increment(1),
              "names": FieldValue.arrayUnion([
                {"uid": myUid, "name": name},
                {"uid": oppositeUid, "name": oppositeName},
              ]),
              "head_photos": FieldValue.arrayUnion([
                {"uid": myUid, "head_photo": headPhoto},
                {"uid": oppositeUid, "head_photo": oppositeHeadPhotoUrl},
              ]),
            });
            print("Stored chat data successfully");
          }
        });
      });
    });
  } catch (error) {
    print("Error in storing chat data popup chat : ${error.toString()}");
  }
}
