// @dart=2.9
// Todo : Backend of  profile photos

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePhotosBackEnd {
  static Future<void> storePhotosInfo(String hash, String bodyUrl) async {
    // * only during sign up
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data = FirebaseFirestore.instance.doc(
          "Users/$uid/Profile/profile/Photos/myphotos"); 
      // update
      await data.set({
        "show_on_feeds": {
          "hash": hash,
          "url": bodyUrl,
        },
        "photos": FieldValue.arrayUnion([
          {
            "hash": hash,
            "url": bodyUrl,
          }
        ]),
        "total_photos_uploaded": 1,
        "time_feed_icon_clicked":
            FieldValue.serverTimestamp(), // latest time feed icon clicked
        "time_photo_uploaded":
            FieldValue.serverTimestamp(), // latest time new photo uploaded
      });
      print("photos_info stored");
    } catch (error) {
      print(
          "Error in storing photos_info details in database : ${error.toString()}");
    }
  }

  static Future<void> showPhotosInfo() async {
    // * update alert dialogue 
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data =
          FirebaseFirestore.instance.doc("Users/$uid/Profile/profile");
      // update
      await data.update({
        "show_photos_info": false,
      });
      print("show_photos_info data updated");
    } catch (error) {
      print(
          "Error in updating show_photos_info details in database : ${error.toString()}");
    }
  }

  static Future<void> uploadPhoto(String hash, String url) async {
    // * 1W
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data = FirebaseFirestore.instance.doc(
          "Users/$uid/Profile/profile/Photos/myphotos"); 
      // update
      await data.update({
        "photos": FieldValue.arrayUnion([
          {
            "hash": hash,
            "url": url,
          }
        ]),
        "total_photos_uploaded": FieldValue.increment(1),
        "time_photo_uploaded": FieldValue.serverTimestamp(),
      });
      print("new photo data stored");
    } catch (error) {
      print(
          "Error in storing new photo details in database : ${error.toString()}");
    }
  }

  static Future<void> updateShowOnFeedsData(String hash, String url) async {
    try {
      // * when user long press feeds icon
      // * 1R,2W
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data = FirebaseFirestore.instance.doc(
          "Users/$uid/Profile/profile/Photos/myphotos"); 
      // update show on feeds
      await data.update({
        "show_on_feeds": {
          "hash": hash,
          "url": url,
        },
        "time_feed_icon_clicked": FieldValue.serverTimestamp(),
      });
      print("show_on_feeds data updated");
      // update the body photo in matchmaking
      QuerySnapshot matchMakingData = await FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen")
          .where("uid", isEqualTo: uid)
          .get();
      matchMakingData.docs.forEach((data) async {
        String path = data.reference.path;
        DocumentReference updateMatchmakingData =
            FirebaseFirestore.instance.doc(path);
        await updateMatchmakingData.update({
          "photos.current_body_photo_hash": hash,
          "photos.current_body_photo": url,
        });
        print("current body photo updated in respected user matchmaking");
      });
    } catch (error) {
      print(
          "Error in updating show_on_feeds data in database : ${error.toString()}");
    }
  }

  static Future<void> deletePhoto(String hash, String url,Function startDelete , Function stopDelete) async {
    try {
      // * when user press delete icon
      // * 1W
      startDelete(); // delete process started
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference data = FirebaseFirestore.instance.doc(
          "Users/$uid/Profile/profile/Photos/myphotos"); 
      // update show on feeds
      await data.update({
        "photos": FieldValue.arrayRemove([
          {
            "hash": hash,
            "url": url,
          },
        ]),
        "total_photos_uploaded": FieldValue.increment(-1),
        "time_photo_deleted":
            FieldValue.serverTimestamp(), // latest time photo is deleted
      });
      await Future.delayed(Duration(seconds: 1));
      stopDelete(); // delete process over
      print("photo deleted from the array");
    } catch (error) {
      print(
          "Error in deleting photo from the array in database : ${error.toString()}");
      stopDelete(); // delete process over
    }
  }
}
