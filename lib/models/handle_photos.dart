import 'package:app_settings/app_settings.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// ! change to default camera (in built camera) if there any problem in taking pictures from camera

class HandlePhotos {
  static String headPhoto;
  static String bodyPhoto;
  // ? head photo options
  static Future<void> openCameraForHeadPhoto(
      Function updateHeadPhoto, BuildContext context) async {
    try {
      final picker = ImagePicker();
      // * using 1 : 1 aspect ratio
      final imageFile = await picker.getImage(
          source: ImageSource.camera,);
      // final compressedImage = await FlutterNativeImage.compressImage(imageFile.path,targetWidth: 400,targetHeight: 400,quality: 100);
      final imageCropper = await ImageCropper.cropImage(
        maxWidth: 400,
        maxHeight: 400,
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 50,
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(toolbarColor: Color(0xff121212),toolbarWidgetColor: Colors.white,showCropGrid: false,hideBottomControls: true),
      );
      print("Path : ${imageCropper.path}");
      headPhoto = imageCropper.path;
      updateHeadPhoto();
    } catch (error) {
      print("Error : ${error.toString()}");
      if (error.toString().contains("camera_access_denied")) {
        // ? if user denyed camera access
        _HandlePhotoPermission.cameraAccessDenied(context);
      }
    }
  }

  static Future<void> openGalleryForHeadPhoto(
      Function updateHeadPhoto, BuildContext context) async {
    try {
      final picker = ImagePicker();
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
        androidUiSettings: AndroidUiSettings(toolbarColor: Color(0xff121212),toolbarWidgetColor: Colors.white,showCropGrid: false,hideBottomControls: true),
      );
      print("Path : ${imageCropper.path}");
      headPhoto = imageCropper.path;
      updateHeadPhoto();
    } catch (error) {
      print("Error : ${error.toString()}");
      if (error.toString().contains("photo_access_denied")) {
        // ? if user denyed photo & media access
        _HandlePhotoPermission.galleryAccessDenied(context);
      }
    }
  }

  // ? body photo options
  static Future<void> openCameraForBodyPhoto(
      Function updateBodyPhoto, BuildContext context) async {
    try {
      final picker = ImagePicker();
      // * using 1 : 1 aspect ratio
      final imageFile = await picker.getImage(
          source: ImageSource.camera,);
      // final compressedImage = await FlutterNativeImage.compressImage(imageFile.path,targetWidth: 1080,targetHeight: 1080,quality: 100);
      final imageCropper = await ImageCropper.cropImage(
        maxWidth: 1080,
        maxHeight: 1080,
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        // compressQuality: 50,
        cropStyle: CropStyle.rectangle,
        androidUiSettings: AndroidUiSettings(toolbarColor: Color(0xff121212),toolbarWidgetColor: Colors.white,showCropGrid: false,hideBottomControls: true),
      );
      print("Path : ${imageCropper.path}");
      bodyPhoto = imageCropper.path;
      updateBodyPhoto();
    } catch (error) {
      print("Error : ${error.toString()}");
      if (error.toString().contains("camera_access_denied")) {
        // ? if user denyed camera access
        _HandlePhotoPermission.cameraAccessDenied(context);
      }
    }
  }

  static Future<void> openGalleryForBodyPhoto(
      Function updateBodyPhoto, BuildContext context) async {
    try {
      final picker = ImagePicker();
      // * using 1 : 1 aspect ratio
      final imageFile = await picker.getImage(
          source: ImageSource.gallery,);
      // final compressedImage = await FlutterNativeImage.compressImage(imageFile.path,targetWidth: 1080,targetHeight: 1080,quality: 100);
      final imageCropper = await ImageCropper.cropImage(
        maxWidth: 1080,
        maxHeight: 1080,
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        // compressQuality: 50,
        cropStyle: CropStyle.rectangle,
        androidUiSettings: AndroidUiSettings(toolbarColor: Color(0xff121212),toolbarWidgetColor: Colors.white,showCropGrid: false,hideBottomControls: true),
      );
      print("Path : ${imageCropper.path}");
      bodyPhoto = imageCropper.path;
      updateBodyPhoto();
    } catch (error) {
      print("Error : ${error.toString()}");
      if (error.toString().contains("photo_access_denied")) {
        // ? if user denyed photo & media access
        _HandlePhotoPermission.galleryAccessDenied(context);
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
        style: TextStyle(color: Colors.white),
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
        style: TextStyle(color: Colors.white),
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
