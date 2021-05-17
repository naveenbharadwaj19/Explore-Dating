// @dart=2.9
// todo photo handle for individual chat
import 'package:app_settings/app_settings.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:explore/server/chats/individual_chat_backend.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// ! change to default camera (in built camera) if there any problem in taking pictures from camera

class HandlePhotosForIndividualChat {
  static String photo;
  // ? by camera
  static Future<void> openCamera(String path,BuildContext context) async {
    try {
      final picker = ImagePicker();
      // * using 1 : 1 aspect ratio
      final imageFile = await picker.getImage(
        source: ImageSource.camera,
      );
      // final compressedImage = await FlutterNativeImage.compressImage(imageFile.path,targetWidth: 1080,targetHeight: 1080,quality: 100);
      final imageCropper = await ImageCropper.cropImage(
        maxWidth: 1080,
        maxHeight: 1080,
        sourcePath: imageFile.path,
        // compressQuality: 50,
        cropStyle: CropStyle.rectangle,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
            showCropGrid: false,
            hideBottomControls: true),
      );
      print("Path : ${imageCropper.path}");
      photo = imageCropper.path;
      if(photo.isNotEmpty){
        IndividualChatBackEnd.photoProcess(photo, path, context);
        Navigator.pop(context);
      }
    } catch (error) {
      print("Error in handlephotosforindividualchat  : ${error.toString()}");
      if (error.toString().contains("camera_access_denied")) {
        // ? if user denyed camera access
        _HandlePhotoPermission.cameraAccessDenied(context);
      } else {
        Flushbar(
          messageText: Center(
            child: const Text(
              "Something went wrong",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    }
  }

  //  ? by gallery
  static Future<void> openGallery(String path,BuildContext context) async {
    try {
      final picker = ImagePicker();
      // * using 1 : 1 aspect ratio
      final imageFile = await picker.getImage(
        source: ImageSource.gallery,
      );
      // final compressedImage = await FlutterNativeImage.compressImage(imageFile.path,targetWidth: 1080,targetHeight: 1080,quality: 100);
      final imageCropper = await ImageCropper.cropImage(
        maxWidth: 1080,
        maxHeight: 1080,
        sourcePath: imageFile.path,
        // compressQuality: 50,
        cropStyle: CropStyle.rectangle,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
            showCropGrid: false,
            hideBottomControls: true),
      );
      print("Path : ${imageCropper.path}");
      photo = imageCropper.path;
      if(photo.isNotEmpty){
        IndividualChatBackEnd.photoProcess(photo, path, context);
        Navigator.pop(context);
      }
    } catch (error) {
      print("Error in handlephotosforindividualchat : ${error.toString()}");
      if (error.toString().contains("photo_access_denied")) {
        // ? if user denyed photo & media access
        _HandlePhotoPermission.galleryAccessDenied(context);
      } else {
        Flushbar(
          messageText: Center(
            child: const Text(
              "Something went wrong",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(context);
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
