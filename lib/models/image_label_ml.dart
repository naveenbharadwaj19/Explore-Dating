// todo Ml
import 'package:Explore/models/assign_errors.dart';
import 'package:Explore/models/firestore_signup.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flushbar/flushbar.dart';
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
          messageText: Text(
            "Upload different photo",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
          mainButton: IconButton(
            icon: Icon(Icons.help_rounded),
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
        uploadHeadBodyPhotoTocloudStorage(
            imagePathHead, imagePathBody, context);
      }
    }
  } catch (error) {
    print("Error : ${error.toString()}");
    Flushbar(
      messageText: Text(
        AssignErrors.exphpml004,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 2),
    )..show(context);
  }
  loadingOff();
}
