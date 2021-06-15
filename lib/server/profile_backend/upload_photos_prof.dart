// @dart=2.9
// todo : Manage both head and body photos when user want to upload

import 'package:another_flushbar/flushbar.dart';
import 'package:app_settings/app_settings.dart';
import 'package:explore/models/all_urls.dart';
import 'package:explore/models/assign_errors.dart';
import 'package:explore/models/blur_hash_img.dart';
import 'package:explore/server/cloud_storage/download_photos_storage.dart';
import 'package:explore/server/https_cloud_functions.dart';
import 'package:explore/server/profile_backend/abt_me_backend.dart';
import 'package:explore/server/profile_backend/prof_photos_backend.dart';
import 'package:explore/server/cloud_storage/upload_photos_cloud_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// * ------ Photos--------------------
// * 1: user click either camera or gallery -> select the photo -> press tick button -> validate the photo
// * 2: -> upload the selected photo to cloud storage -> download the current fresh head photo -> create hash and url
// * 3: -> store them in neccessary areas in the database
//  * -------------------------------

class HandlePhotosForProfile {
  static String headPhotoPath;
  static String bodyPhotoPath;
  static Future uploadHeadPhotoCamera(BuildContext contextP) async {
    // * camera
    try {
      final picker = ImagePicker();
      final String uid = FirebaseAuth.instance.currentUser.uid;
      // * using 1 : 1 aspect ratio
      final imageFile = await picker.getImage(source: ImageSource.camera);
      // final compressedImage = await FlutterNativeImage.compressImage(imageFile.path,targetWidth: 400,targetHeight: 400,quality: 100);
      final imageCropper = await ImageCropper.cropImage(
        maxWidth: 400,
        maxHeight: 400,
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 50,
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Color(0xff121212),
            toolbarWidgetColor: Colors.white,
            showCropGrid: false,
            hideBottomControls: true),
      );
      print("Path : ${imageCropper.path}");
      headPhotoPath = imageCropper.path;
      // validate head photo using Ml

      try {
        if (headPhotoPath.isNotEmpty || headPhotoPath != null) {
          FirebaseVisionImage ml =
              FirebaseVisionImage.fromFilePath(headPhotoPath);
          FaceDetector detectFaces = FirebaseVision.instance.faceDetector();
          var processedFaces = await detectFaces.processImage(ml);

          if (processedFaces.isEmpty) {
            print("No face detected");
            Flushbar(
              messageText: Center(
                child: const Text(
                  "Upload different photo",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              backgroundColor: Color(0xff121212),
              duration: Duration(seconds: 3),
              mainButton: IconButton(
                icon: const Icon(Icons.help_rounded),
                color: Colors.white,
                tooltip: "help",
                onPressed: () => launchPhotoRules()
              ),
            )..show(contextP);
          } else if (processedFaces.isNotEmpty) {
            // * when face is detected
            print("Face detected ...");
            // upload the selected photo to cloud storage
            await uploadHeadPhotoToCloudStorage(headPhotoPath, contextP);
            // download the new head photo from cloud storage
            DownloadCloudStoragePhotos.headPhotoDownload(uid)
                .then((fetchedHeadPhoto) {
              // check if fetchedheadphoto contains error url
              if (!fetchedHeadPhoto.contains("Cannot get image url")) {
                encodeBlurHashImg(fetchedHeadPhoto).then((headPhotoHash) {
                  ProfileAboutMeBackEnd.uploadHeadPhoto(
                      headPhotoHash, fetchedHeadPhoto);
                  replicateHeadPhoto(fetchedHeadPhoto); // * R - number docs retrieved , W - no of docs retrieved (max 100)
                  // show upload successful message to the user
                  Flushbar(
                    messageText: Center(
                      child: const Text(
                        "Photo Uploaded Successfully",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    backgroundColor: Color(0xff121212),
                    duration: Duration(seconds: 2),
                  )..show(contextP);
                });
              }
            });
          }
        }
      } catch (error) {
        // error in validating head photo
        // ml error
        print("Error : ${error.toString()}");
        Flushbar(
          messageText: Text(
            AssignErrors.edml004,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 2),
        )..show(contextP);
      }
    } catch (error) {
      print("Error : ${error.toString()}");
      if (error.toString().contains("camera_access_denied")) {
        // ? if user denyed photo & media access
        _HandlePhotoPermission.cameraAccessDenied(contextP);
      }
    }
  }

  static Future uploadHeadPhotoGallery(BuildContext contextP) async {
    // * gallery
    try {
      final picker = ImagePicker();
      final String uid = FirebaseAuth.instance.currentUser.uid;
      // * using 1 : 1 aspect ratio
      final imageFile = await picker.getImage(source: ImageSource.gallery);
      // final compressedImage = await FlutterNativeImage.compressImage(imageFile.path,targetWidth: 400,targetHeight: 400,quality: 100);
      final imageCropper = await ImageCropper.cropImage(
        maxWidth: 400,
        maxHeight: 400,
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 50,
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Color(0xff121212),
            toolbarWidgetColor: Colors.white,
            showCropGrid: false,
            hideBottomControls: true),
      );
      print("Path : ${imageCropper.path}");
      headPhotoPath = imageCropper.path;
      // validate head photo using Ml

      try {
        if (headPhotoPath.isNotEmpty || headPhotoPath != null) {
          FirebaseVisionImage ml =
              FirebaseVisionImage.fromFilePath(headPhotoPath);
          FaceDetector detectFaces = FirebaseVision.instance.faceDetector();
          var processedFaces = await detectFaces.processImage(ml);

          if (processedFaces.isEmpty) {
            print("No face detected");
            Flushbar(
              messageText: Center(
                child: const Text(
                  "Upload different photo",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              backgroundColor: Color(0xff121212),
              duration: Duration(seconds: 3),
              mainButton: IconButton(
                icon: const Icon(Icons.help_rounded),
                color: Colors.white,
                tooltip: "help",
                onPressed: () => launchPhotoRules(),
              ),
            )..show(contextP);
          } else if (processedFaces.isNotEmpty) {
            // * when face is detected
            print("Face detected ...");
            // upload the selected photo to cloud storage
            await uploadHeadPhotoToCloudStorage(headPhotoPath, contextP);
            // download the new head photo from cloud storage
            DownloadCloudStoragePhotos.headPhotoDownload(uid)
                .then((fetchedHeadPhoto) {
              // check if fetchedheadphoto contains error url
              if (!fetchedHeadPhoto.contains("Cannot get image url")) {
                encodeBlurHashImg(fetchedHeadPhoto).then((headPhotoHash) {
                  ProfileAboutMeBackEnd.uploadHeadPhoto(
                      headPhotoHash, fetchedHeadPhoto);
                  replicateHeadPhoto(fetchedHeadPhoto); // * R - number docs retrieved , W - no of docs retrieved (max 100)
                  // show upload successful message to the user
                  Flushbar(
                    messageText: Center(
                      child: const Text(
                        "Photo Uploaded Successfully",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    backgroundColor: Color(0xff121212),
                    duration: Duration(seconds: 2),
                  )..show(contextP);
                });
              }
            });
          }
        }
      } catch (error) {
        // error in validating head photo
        // ml error
        print("Error : ${error.toString()}");
        Flushbar(
          messageText: Text(
            AssignErrors.edml004,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 2),
        )..show(contextP);
      }
    } catch (error) {
      print("Error : ${error.toString()}");
      if (error.toString().contains("photo_access_denied")) {
        // ? if user denyed photo & media access
        _HandlePhotoPermission.galleryAccessDenied(contextP);
      }
    }
  }

  static Future uploadBodyPhotoCamera(Function startBodyPhotoProcess,
      Function stopBodyPhotoProcess, BuildContext contextP) async {
    // * bodyphoto camera
    try {
      final picker = ImagePicker();
      final String uid = FirebaseAuth.instance.currentUser.uid;
      // * using 1 : 1 aspect ratio
      final imageFile = await picker.getImage(source: ImageSource.camera);
      // final compressedImage = await FlutterNativeImage.compressImage(imageFile.path,targetWidth: 400,targetHeight: 400,quality: 100);
      final imageCropper = await ImageCropper.cropImage(
        maxWidth: 1080,
        maxHeight: 1080,
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        // compressQuality: 50,
        cropStyle: CropStyle.rectangle,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Color(0xff121212),
            toolbarWidgetColor: Colors.white,
            showCropGrid: false,
            hideBottomControls: true),
      );
      print("Path : ${imageCropper.path}");
      bodyPhotoPath = imageCropper.path;
      String imgName = bodyPhotoPath.split("/").last;
      // validate head photo using Ml
      startBodyPhotoProcess();
      try {
        if (bodyPhotoPath.isNotEmpty || bodyPhotoPath != null) {
          FirebaseVisionImage ml =
              FirebaseVisionImage.fromFilePath(bodyPhotoPath);
          FaceDetector detectFaces = FirebaseVision.instance.faceDetector();
          var processedFaces = await detectFaces.processImage(ml);

          if (processedFaces.isEmpty) {
            print("No face detected");
            Flushbar(
              messageText: Center(
                child: const Text(
                  "Upload different photo",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              backgroundColor: Color(0xff121212),
              duration: Duration(seconds: 3),
              mainButton: IconButton(
                icon: const Icon(Icons.help_rounded),
                color: Colors.white,
                tooltip: "help",
                onPressed: () => launchPhotoRules(),
              ),
            )..show(contextP);
            stopBodyPhotoProcess();
          } else if (processedFaces.isNotEmpty) {
            // * when face is detected
            print("Face detected ...");
            // upload the selected photo to cloud storage
            await uploadBodyPhotoToCloudStorage(bodyPhotoPath, contextP);
            // download the new head photo from cloud storage
            DownloadCloudStoragePhotos.recentbodyPhotoDownload(imgName, uid)
                .then((fetchedBodyPhoto) {
              // check if fetchedBodyPhoto contains error url
              if (!fetchedBodyPhoto.contains("Cannot get image url")) {
                encodeBlurHashImg(fetchedBodyPhoto).then((bodyPhotoHash) {
                  ProfilePhotosBackEnd.uploadPhoto(
                      bodyPhotoHash, fetchedBodyPhoto);
                  stopBodyPhotoProcess();
                  // show upload successful message to the user
                  Flushbar(
                    messageText: Center(
                      child: const Text(
                        "Photo Uploaded Successfully",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    backgroundColor: Color(0xff121212),
                    duration: Duration(seconds: 2),
                  )..show(contextP);
                });
              }
            });
          }
        }
      } catch (error) {
        // error in validating head photo
        // ml error
        stopBodyPhotoProcess();
        print("Error : ${error.toString()}");
        Flushbar(
          messageText: Text(
            AssignErrors.edml004,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 2),
        )..show(contextP);
      }
    } catch (error) {
      print("Error : ${error.toString()}");
      stopBodyPhotoProcess();
      if (error.toString().contains("camera_access_denied")) {
        // ? if user denyed photo & media access
        _HandlePhotoPermission.cameraAccessDenied(contextP);
      }
    }
  }

  static Future uploadBodyPhotoGallery(Function startBodyPhotoProcess,
      Function stopBodyPhotoProcess, BuildContext contextP) async {
    // * bodyphoto gallery
    try {
      final picker = ImagePicker();
      final String uid = FirebaseAuth.instance.currentUser.uid;
      // * using 1 : 1 aspect ratio
      final imageFile = await picker.getImage(source: ImageSource.gallery);
      // final compressedImage = await FlutterNativeImage.compressImage(imageFile.path,targetWidth: 400,targetHeight: 400,quality: 100);
      final imageCropper = await ImageCropper.cropImage(
        maxWidth: 1080,
        maxHeight: 1080,
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        // compressQuality: 50,
        cropStyle: CropStyle.rectangle,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Color(0xff121212),
            toolbarWidgetColor: Colors.white,
            showCropGrid: false,
            hideBottomControls: true),
      );
      print("Path : ${imageCropper.path}");
      bodyPhotoPath = imageCropper.path;
      String imgName = bodyPhotoPath.split("/").last;
      // validate head photo using Ml
      startBodyPhotoProcess();
      try {
        if (bodyPhotoPath.isNotEmpty || bodyPhotoPath != null) {
          FirebaseVisionImage ml =
              FirebaseVisionImage.fromFilePath(bodyPhotoPath);
          FaceDetector detectFaces = FirebaseVision.instance.faceDetector();
          var processedFaces = await detectFaces.processImage(ml);

          if (processedFaces.isEmpty) {
            print("No face detected");
            Flushbar(
              messageText: Center(
                child: const Text(
                  "Upload different photo",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              backgroundColor: Color(0xff121212),
              duration: Duration(seconds: 3),
              mainButton: IconButton(
                icon: const Icon(Icons.help_rounded),
                color: Colors.white,
                tooltip: "help",
                onPressed: () => launchPhotoRules(),
              ),
            )..show(contextP);
            stopBodyPhotoProcess();
          } else if (processedFaces.isNotEmpty) {
            // * when face is detected
            print("Face detected ...");
            // upload the selected photo to cloud storage
            await uploadBodyPhotoToCloudStorage(bodyPhotoPath, contextP);
            // download the new head photo from cloud storage
            DownloadCloudStoragePhotos.recentbodyPhotoDownload(imgName, uid)
                .then((fetchedBodyPhoto) {
              // check if fetchedBodyPhoto contains error url
              if (!fetchedBodyPhoto.contains("Cannot get image url")) {
                encodeBlurHashImg(fetchedBodyPhoto).then((bodyPhotoHash) {
                  ProfilePhotosBackEnd.uploadPhoto(
                      bodyPhotoHash, fetchedBodyPhoto);
                  stopBodyPhotoProcess();
                  // show upload successful message to the user
                  Flushbar(
                    messageText: Center(
                      child: const Text(
                        "Photo Uploaded Successfully",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    backgroundColor: Color(0xff121212),
                    duration: Duration(seconds: 2),
                  )..show(contextP);
                });
              }
            });
          }
        }
      } catch (error) {
        // error in validating head photo
        // ml error
        stopBodyPhotoProcess();
        print("Error : ${error.toString()}");
        Flushbar(
          messageText: Text(
            AssignErrors.edml004,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 2),
        )..show(contextP);
      }
    } catch (error) {
      print("Error : ${error.toString()}");
      stopBodyPhotoProcess();
      if (error.toString().contains("photo_access_denied")) {
        // ? if user denyed photo & media access
        _HandlePhotoPermission.galleryAccessDenied(contextP);
      }
    }
  }
}

// * mangage photo permission messages
class _HandlePhotoPermission {
  static Widget cameraAccessDenied(BuildContext context) {
    return Flushbar(
      messageText: const Text(
        "Allow permission for camera in app settings",
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 3),
      mainButton: IconButton(
        icon: const Icon(Icons.open_in_new),
        color: Colors.white,
        tooltip: "settings",
        onPressed: () {
          // * open app setting to allow permission
          AppSettings.openAppSettings();
        },
      ),
    )..show(context);
  }

  static Widget galleryAccessDenied(BuildContext context) {
    return Flushbar(
      messageText: const Text(
        "Allow permission for storage in app settings",
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 3),
      mainButton: IconButton(
        icon: const Icon(Icons.open_in_new),
        color: Colors.white,
        tooltip: "settings",
        onPressed: () {
          // * open app setting to allow permission
          AppSettings.openAppSettings();
        },
      ),
    )..show(context);
  }
}
