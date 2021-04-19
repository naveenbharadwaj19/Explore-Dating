// @dart=2.9
// todo Ml
import 'package:explore/models/assign_errors.dart';
import '../serverless/firestore_signup.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> detectHeadPhotoAndStoreToCloud(
    String imagePathHead,
    String imagePathBody,
    Function loadinOn,
    Function loadingOff,
    BuildContext context) async {
      loadinOn();
  try {
    if (imagePathHead.isNotEmpty || imagePathHead != null) {
      FirebaseVisionImage ml = FirebaseVisionImage.fromFilePath(imagePathHead);
      FaceDetector detectFaces = FirebaseVision.instance.faceDetector();
      var processedFaces = await detectFaces.processImage(ml);

      if (processedFaces.isEmpty) {
        print("No face detected");
        Flushbar(
          messageText:const Text(
            "Upload different photo",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
          mainButton: IconButton(
            icon: const Icon(Icons.help_rounded),
            color: Colors.white,
            tooltip: "help",
            onPressed: () {
              // * navigate to the website why we don't accept
            },
          ),
        )..show(context);
      } else if (processedFaces.isNotEmpty) {
        // * when face is detected
        print("Face detected ...");
        uploadPhotosTocloudStorageFirstTime(
            imagePathHead, imagePathBody, context);
      }
    }
  } catch (error) {
    print("Error : ${error.toString()}");
    Flushbar(
      messageText: Text(
        AssignErrors.exphpml004,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 2),
    )..show(context);
  }
  loadingOff();
}
