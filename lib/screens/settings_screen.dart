import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/models/handle_deletes_logout.dart';
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

bulkOperation() async {
  try {
    var data = await FirebaseFirestore.instance
        .collection("Matchmaking/simplematch/MenWomen")
        .get();
    data.docs.forEach((element) async {
      String path = element.reference.path;
      DocumentReference editData = FirebaseFirestore.instance.doc(path);
      await editData.update({
        "photos": {
          "current_head_photo":
              "https://firebasestorage.googleapis.com/v0/b/explore-dating.appspot.com/o/Userphotos%2F7Hsr2gfBRvaByEJrudUmP3HsOWI3%2Fcurrentheadphoto%2Fchoosenheadphoto.jpg?alt=media&token=8ea716d6-cb53-4e8e-bc0a-bbdd60119fda",
          "current_body_photo":
              "https://firebasestorage.googleapis.com/v0/b/explore-dating.appspot.com/o/Userphotos%2F7Hsr2gfBRvaByEJrudUmP3HsOWI3%2Fcurrentbodyphoto%2Fchoosenbodyphoto.jpg?alt=media&token=397a0b86-b89d-42b8-9e01-6253f820a279",
        }
      });
    });
    print("Done..");
  } catch (e) {
    print("Erro in bulk operation ${e.toString()}");
  }
}
