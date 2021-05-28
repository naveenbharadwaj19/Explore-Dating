// @dart=2.9
// todo : manage all chat screen backend
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/server/https_cloud_functions.dart';
import 'package:explore/server/match_backend/exclude_users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:ntp/ntp.dart';

class ChatBackEnd {
  static List chatData = []; // store all info of the chat
  static ValueNotifier<bool> processChatDatas =
      ValueNotifier(true); // hold execution
  static List<Map<String, String>> deleteDatas =
      []; // store datas when automatic unmatch is triggered
  static String latestTimeStr = ""; // store the last time ascending
  static bool showLoadingSpineer = true;

  static Future displayChats() async {
    Stopwatch stopwatch = Stopwatch();
    try {
      // * convert str time to datetime
      DateTime latestTime;
      if (latestTimeStr.isNotEmpty) {
        latestTime = DateTime.tryParse(latestTimeStr);
      }
      stopwatch.start(); // start
      processChatDatas.value = true; // start the process
      String myUid = FirebaseAuth.instance.currentUser.uid;
      DateTime currentNTP = await NTP.now();
      // query
      QuerySnapshot query = await FirebaseFirestore.instance
          .collectionGroup("Chats")
          .where("uids", arrayContains: myUid)
          .where("show_this", isEqualTo: true)
          .orderBy("latest_time", descending: true)
          .limit(10)
          .startAfter([latestTimeStr.isEmpty ? "" : latestTime]).get();
      // unzip
      query.docs.forEach((data) {
        DateTime expireTime = data.get("expire_time").toDate();
        // * check if time expired
        if (currentNTP.isAfter(expireTime) && data.get("automatic_unmatch")) {
          String path = data.reference.path;
          List uids = data.get("uids");
          int oppositeUidIdx = uids.indexWhere((e) => e != myUid);
          Map map = {"path": path, "opposite_uid": uids[oppositeUidIdx]};
          // add map to the list
          deleteDatas.add(map);
        } else {
          // * get index of head_photo
          List headPhotos = data.get("head_photos");
          int headPhotoIdx = headPhotos.indexWhere((e) => e["uid"] != myUid);
          //  * get index of name
          List names = data.get("names");
          int nameIdx = names.indexWhere((e) => e["uid"] != myUid);
          Map mapValues = {
            "name": data.get("names")[nameIdx]["name"],
            "automatic_unmatch": data.get("automatic_unmatch"),
            "last_message": data.get("messages").last["msg_content"],
            "sender_uid": data.get("messages").last["sender_uid"],
            "opposite_uid": data.get("names")[nameIdx]["uid"],
            "head_photo": data.get("head_photos")[headPhotoIdx]["head_photo"],
            "show_url_preview": data.get("messages").last["show_url_preview"],
            "path": data.reference.parent.path,
          };
          // * add to the list
          chatData.add(mapValues);
        }
      });
      // * call cloud function
      if (deleteDatas.isNotEmpty) {
        print("Unmatching : ${deleteDatas.length} users");
        automaticUnMatch(deleteDatas);
      }
      // * latest documents
      try {
        latestTimeStr = query.docs[query.docs.length - 1]
            .get("latest_time")
            .toDate()
            .toString();
      } on RangeError {
        print("No more documents to fetch");
        latestTimeStr = "";
      }
      // * stop process
      stopwatch.stop(); // stop
      processChatDatas.value = false; // stop the process
      showLoadingSpineer = false;
      print(
          "Chat process response time : ${stopwatch.elapsed.inMilliseconds} ms");
    } catch (error) {
      stopwatch.stop(); // stop
      processChatDatas.value = false;
      print("Error in processing chat datas : ${error.toString()}");
    }
  }
}
