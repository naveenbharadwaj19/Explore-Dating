// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/models/blur_hash_img.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white30,
      child: Center(
        child: IconButton(
          icon: Icon(Icons.send,color: Colors.red,size: 30,),
          onPressed: (){
            // bulkPhotoOperation();
          },
        ),
      ),
    );
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
          encodeBlurHashImg(url).then((blurHash)async{
            await editData.update({
              "photos.current_head_photo_hash" : blurHash,
            });
          });
          
        });
        var deleteCurrentbodyPhoto = await uploadUserPhotos
            .ref()
            .child("Userphotos/${element.get("uid")}/currentbodyphoto")
            .listAll();
        deleteCurrentbodyPhoto.items.forEach((bodyp) async {
          String url = await bodyp.getDownloadURL();
          encodeBlurHashImg(url).then((blurHash)async{
            await editData.update({
              "photos.current_body_photo_hash" : blurHash,
            });
          });
        });
      });

      print("Done..");
    } catch (e) {
      print("Erro in bulk photo operation ${e.toString()}");
    }
  }