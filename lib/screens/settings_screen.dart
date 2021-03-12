import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/serverless/handle_deletes_logout.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Home Screen",
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
              bulkOperation();
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
              readValue("geohash").then((value) {
                String a = value.toString();
                String b = a.substring(0, 4);
                print(b.contains("n"));
              });
            },
          ),
        ],
      ),
    );
  }
}

void bulkOperation() async {
  // write bulk operation here
}


Future bulkPhotoOperation() async {
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
    deleteCurrentHeadPhoto.items.forEach((headp)async {
      String url = await headp.getDownloadURL();
      await editData.update({
        "photos.current_head_photo" : url,
      });
    });
    var deleteCurrentbodyPhoto = await uploadUserPhotos
        .ref()
        .child("Userphotos/${element.get("uid")}/currentbodyphoto")
        .listAll();
    deleteCurrentbodyPhoto.items.forEach((bodyp)async {
      String url = await bodyp.getDownloadURL();
      await editData.update({
        "photos.current_body_photo" : url,
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
