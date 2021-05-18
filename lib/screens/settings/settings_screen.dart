// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/models/blur_hash_img.dart';
import 'package:explore/server/handle_deletes_logout.dart';
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
                deleteAuthDetails(context);
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
                // BulkOperations.deleteNotificationFieldBulk();
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
          "head_photo_hash": element.get("photos.current_head_photo_hash"),
          // "time": "16-03-2021"
        };
        heartInfos.add(serialize);
        heartUid.add(element.get("uid"));
      });
      DocumentReference myDocRef = FirebaseFirestore.instance
          .doc("Notifications/${FirebaseAuth.instance.currentUser.uid}");
      batch.update(myDocRef, {
        "received_hearts_info": heartInfos,
        "received_hearts_uid": heartUid,
        "uid": FirebaseAuth.instance.currentUser.uid,
        "age": 24
      });
      batch.commit();
      print("get notified done");
    } catch (e) {
      print("Error in getnotified bulk : ${e.toString()}");
    }
  }
}

// ! remove
// checkNFSW() async {
//   try {
//     String imgUrl =
//         "https://firebasestorage.googleapis.com/v0/b/explore-dating.appspot.com/o/test_nfsw%2Fsunny-leone-bday-20-139a.jpg?alt=media&token=ee793ff4-d2f3-4798-a212-6103bb81ba08";
//     String api = "4e1479c2e46f75bda7e252dab7b9fc66";
//     String uriEncode = Uri.encodeComponent(imgUrl);
//     Uri uri = Uri.parse(
//         "https://im-api1.webpurify.com/services/rest/?api_key=$api&format=json&method=webpurify.aim.imgcheck&cats=nudity,faces,celebrities,scam&imgurl=$uriEncode");

//     var response = await http.post(uri);
//     var decodeResponse = utf8.decode(response.bodyBytes);
//     var myJson = json.decode(decodeResponse);
//     print(response.statusCode);
//     print(myJson);
//     print(myJson["rsp"]["nudity"]);
//   } catch (e) {
//     print("Error in nfsw : ${e.toString()}");
//   }
// }

Future bulkPhotoOperation() async {
  try {
    var data = await FirebaseFirestore.instance
        .collection("Matchmaking/simplematch/MenWomen")
        .get();
    data.docs.forEach((element) async {
      String path = element.reference.path;
      DocumentReference editData = FirebaseFirestore.instance.doc(path);
      FirebaseStorage uploadUserPhotos = FirebaseStorage.instance;
      var getphotos = await uploadUserPhotos
          .ref()
          .child("Userphotos/${element.get("uid")}/currentheadphoto")
          .listAll();
      getphotos.items.forEach((headp) async {
        String url = await headp.getDownloadURL();
        encodeBlurHashImg(url).then((blurHash) async {
          await editData.update({
            "photos.current_head_photo_hash": blurHash,
          });
        });
      });
      var deleteCurrentbodyPhoto = await uploadUserPhotos
          .ref()
          .child("Userphotos/${element.get("uid")}/currentbodyphoto")
          .listAll();
      deleteCurrentbodyPhoto.items.forEach((bodyp) async {
        String url = await bodyp.getDownloadURL();
        encodeBlurHashImg(url).then((blurHash) async {
          await editData.update({
            "photos.current_body_photo_hash": blurHash,
          });
        });
      });
    });

    print("Done..");
  } catch (e) {
    print("Erro in bulk photo operation ${e.toString()}");
  }
}