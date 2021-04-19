// @dart=2.9
// todo : Manage delete photos of cloud storage

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart'as path;

Future<void> deleteBodyPhotoFromCloudStorage(
    String url, BuildContext context) async {
  try {
    FirebaseStorage _storage = FirebaseStorage.instance;
    // String uid = FirebaseAuth.instance.currentUser.uid;
    String optimizeUrlPath = Uri.decodeFull(path.basename(url)).replaceAll(new RegExp(r'(\?alt).*'), ""); // remove unwanted objects from the url
    await _storage.ref().child(optimizeUrlPath).delete();
    print("body photo deleted from storage");
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
