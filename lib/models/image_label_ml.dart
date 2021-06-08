// @dart=2.9
// todo Ml for pick photo screen
import 'package:explore/models/assign_errors.dart';
import '../server/signup_process.dart';
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
    if (imagePathHead.isNotEmpty || imagePathHead != null || imagePathBody.isNotEmpty || imagePathBody != null) {
      FirebaseVisionImage ml = FirebaseVisionImage.fromFilePath(imagePathHead); // head photo
      FaceDetector detectHeadFace = FirebaseVision.instance.faceDetector();
      FirebaseVisionImage ml2 = FirebaseVisionImage.fromFilePath(imagePathBody); // body photo
      FaceDetector detectBodyFace = FirebaseVision.instance.faceDetector();
      var processedHeadFace = await detectHeadFace.processImage(ml);
      var processBodyFace = await detectBodyFace.processImage(ml2);

      if (processedHeadFace.isEmpty || processBodyFace.isEmpty) {
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
              // todo navigate to the website why we don't accept
            },
          ),
        )..show(context);
      } else if (processedHeadFace.isNotEmpty && processBodyFace.isNotEmpty) {
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
        AssignErrors.edml004,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 2),
    )..show(context);
  }
  loadingOff();
}
