// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/serverless/handle_deletes_logout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Settings screen",
              style: const TextStyle(color: Colors.white, fontSize: 30)),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            iconSize: 50,
            onPressed: () {
              deleteAuthDetails();
              // deleteUserPhotosInCloudStorage();
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app_outlined),
            color: Colors.red,
            iconSize: 50,
            onPressed: () => logoutUser(context),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.red,
            iconSize: 50,
            onPressed: () {
              BulkOperations.getNotifiedBulk();
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            color: Colors.red,
            iconSize: 50,
            onPressed: () {
              readAll().then((value) {
                print(value);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            color: Colors.red,
            iconSize: 50,
            onPressed: () {
              deleteAll();
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            color: Colors.red,
            iconSize: 50,
            onPressed: () {
              BulkOperations.deleteNotificationFieldBulk();
            },
          ),
        ],
      ),
    );
  }
}

class BulkOperations {
  static void deleteNotificationFieldBulk() async {
    // write bulk operation here
    try {
      var data =
          await FirebaseFirestore.instance.collection("Notifications").get();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      data.docs.forEach((element) async {
        String path = element.reference.path;
        DocumentReference editData = FirebaseFirestore.instance.doc(path);
        await editData.update({
          "received_hearts_info": FieldValue.delete(),
          "received_hearts_uid": FieldValue.delete(),
          "uid": FieldValue.delete(),
          "age": FieldValue.delete(),
        });
        // batch.update(editData, {
        //     "received_hearts_info": FieldValue.delete(),
        //   "received_hearts": FieldValue.delete(),
        // });
        // batch.commit();
      });

      print("Done Bulk operations");
    } catch (e) {
      print("Error in deletenotificationfield bulk");
    }
  }

  static Future bulkPhotoOperation() async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen")
          .get();
      data.docs.forEach((element) async {
        String path = element.reference.path;
        DocumentReference editData = FirebaseFirestore.instance.doc(path);
        FirebaseStorage uploadUserPhotos = FirebaseStorage.instance;
        var deleteCurrentHeadPhoto = await uploadUserPhotos
            .ref()
            .child("Userphotos/${element.get("uid")}/currentheadphoto")
            .listAll();
        deleteCurrentHeadPhoto.items.forEach((headp) async {
          String url = await headp.getDownloadURL();
          await editData.update({
            "photos.current_head_photo": url,
          });
        });
        var deleteCurrentbodyPhoto = await uploadUserPhotos
            .ref()
            .child("Userphotos/${element.get("uid")}/currentbodyphoto")
            .listAll();
        deleteCurrentbodyPhoto.items.forEach((bodyp) async {
          String url = await bodyp.getDownloadURL();
          await editData.update({
            "photos.current_body_photo": url,
          });
        });
        // await editData.update({
        //   "uid" : FieldValue.delete(),
        //   "age" : FieldValue.delete(),
        //   "received_hearts" : FieldValue.delete(),
        // });
      });

      print("Done..");
    } catch (e) {
      print("Erro in bulk photo operation ${e.toString()}");
    }
  }

  static Future<void> getNotifiedBulk() async {
    try {
      QuerySnapshot coll = await FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen")
          .get();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      List heartInfos = [];
      List heartUid = [];
      coll.docs.forEach((element) {
        Map serialize = {
          "uid": element.get("uid"),
          "age": element.get("age"),
          "name": element.get("name"),
          "swiped_right": false,
          "head_photo": element.get("photos.current_head_photo"),
          "time": "16-03-2021"
        };
        heartInfos.add(serialize);
        heartUid.add(element.get("uid"));
      });
      DocumentReference myDocRef = FirebaseFirestore.instance
          .doc("Notifications/${FirebaseAuth.instance.currentUser.uid}");
      batch.update(myDocRef, {
        "received_hearts_info": heartInfos,
        "received_hearts_uid": heartUid,
        "uid" : FirebaseAuth.instance.currentUser.uid,
        "age" : 24
      });
      batch.commit();
      print("get notified done");
    } catch (e) {
      print("Error in getnotified bulk : ${e.toString()}");
    }
  }
}
