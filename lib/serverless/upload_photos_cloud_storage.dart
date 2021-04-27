// @dart=2.9
// Todo : Manage all head and body photos to cloud storage
import 'dart:io';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future<void> uploadHeadPhotoToCloudStorage(
    String headPhotoPath, BuildContext context) async {
  try {
    FirebaseStorage _storage = FirebaseStorage.instance;
    final auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    String imgNameHead = "choosenheadphoto.jpg";
    // imagePathForHead.split("/").last;
    var reference1 =
        _storage.ref().child("Userphotos/$uid/currentheadphoto/$imgNameHead");

    await reference1.putFile(File(headPhotoPath));
    print("head photo uploaded to cloud storage successfully");
  } catch (error) {
    print("Error : ${error.toString()}");
    Flushbar(
      messageText: Text(
        "Something went wrong try again",
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}

Future<void> uploadCurrentBodyPhotoToCloudStorage(
    String url, BuildContext context) async {
  try {
    FirebaseStorage _storage = FirebaseStorage.instance;
    final auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    String imgName = "choosenbodyphoto.jpg";
    var reference1 =
        _storage.ref().child("Userphotos/$uid/currentbodyphoto/$imgName");
    var random = Random(); // generate random
    Directory tempDir =
        await getTemporaryDirectory(); // get temporary path from temporary directory.
    String tempPath = tempDir.path; // temp path
    File file = File('$tempPath' +
        (random.nextInt(100)).toString() +
        '.jpg'); // create a new file in temporary path with random file name.
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    await file.writeAsBytes(
        response.bodyBytes); // write bodyBytes received in response to file.
    await reference1.putFile(File(file.path)); // upload the file
    print("New current body photo uploaded to cloud storage successfully");
  } catch (error) {
    print("Error : ${error.toString()}");
    Flushbar(
      messageText: Text(
        "Something went wrong try again",
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}

Future<void> uploadBodyPhotoToCloudStorage(
    String bodyPhotoPath, BuildContext context) async {
  try {
    FirebaseStorage _storage = FirebaseStorage.instance;
    final auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    String imgName = bodyPhotoPath.split("/").last;
    var reference1 =
        _storage.ref().child("Userphotos/$uid/bodyphotos/$imgName");

    await reference1.putFile(File(bodyPhotoPath));
    print("New body photo uploaded to cloud storage successfully");
  } catch (error) {
    print("Error : ${error.toString()}");
    Flushbar(
      messageText: Text(
        "Something went wrong try again",
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
