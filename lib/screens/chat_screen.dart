// @dart=2.9
import 'dart:async';
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
      color: Colors.white54,
      child: Center(
        child: IconButton(
          icon: Icon(
            Icons.send,
            size: 30,
            color: Colors.red,
          ),
          onPressed: (){
            // bulkPhotoOperation();
            // 58956
            // checkNFSW();
            // FlutterIsolate.spawn(isolateFunction,{1:"10",2:"20"});
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
        "https://firebasestorage.googleapis.com/v0/b/explore-dating.appspot.com/o/test_nfsw%2Fsunny-leone-bday-20-139a.jpg?alt=media&token=ee793ff4-d2f3-4798-a212-6103bb81ba08";
    String api = "4e1479c2e46f75bda7e252dab7b9fc66";
    String uriEncode = Uri.encodeComponent(imgUrl);
    Uri uri = Uri.parse(
        "https://im-api1.webpurify.com/services/rest/?api_key=$api&format=json&method=webpurify.aim.imgcheck&cats=nudity,faces,celebrities,scam&imgurl=$uriEncode");

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


// void isolateFunction(Map mymap)async{
//   await Firebase.initializeApp();
//   print("Done ... :)");
//   var a = FirebaseAuth.instance.currentUser.uid;
//   print(a);
//   var names = await FirebaseFirestore.instance.collection("Users").get();
//   names.docs.forEach((element) { 
//     print(element.get("bio.name"));
//   });
// }