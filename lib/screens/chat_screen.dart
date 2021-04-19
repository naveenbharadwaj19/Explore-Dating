// @dart=2.9
import 'dart:convert' show utf8,json;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/models/blur_hash_img.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white30,
      child: Center(
        child: IconButton(
          icon: Icon(
            Icons.send,
            size: 30,
            color: Colors.red,
          ),
          onPressed: () {
            // bulkPhotoOperation();
            // 58956
            checkNFSW();
          },
        ),
      ),
    );
  }
}

// ! remove
checkNFSW() async {
  try {
    String imgUrl =
        "https://firebasestorage.googleapis.com/v0/b/explore-dating.appspot.com/o/Userphotos%2FvZVqU8MzSfPhIUJrAH78BAk69MH2%2Fbodyphotos%2Fimage_cropper_1613025375026.jpg?alt=media&token=ee7f9abd-e3ec-45d2-a4cf-65bbf63645a7";
    String api = "4e1479c2e46f75bda7e252dab7b9fc66";
    Uri uri = Uri.parse(
        "https://im-api1.webpurify.com/services/rest/?api_key=$api&format=json&method=webpurify.aim.imgcheck&cats=nudity,faces&imgurl=$imgUrl");

    var response = await http.post(uri);
    var decodeResponse = utf8.decode(response.bodyBytes);
    var myJson = json.decode(decodeResponse);
    print(response.statusCode);
    print(myJson);
    print(myJson["rsp"]["nudity"]);
    
  } catch (e) {
    print("Error in nfsw : ${e.toString()}");
  }
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
