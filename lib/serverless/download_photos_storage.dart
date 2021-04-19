// @dart=2.9
// todo : Manage downloads of cloud storage

import 'package:firebase_storage/firebase_storage.dart';

class DownloadCloudStoragePhotos {
  static Future<String> headPhotoDownload(String uid) async {
    try {
      String url = await FirebaseStorage.instance
          .ref("Userphotos/$uid/currentheadphoto/choosenheadphoto.jpg")
          .getDownloadURL();
      return url;
    } catch (error) {
      print("Error in downloading head image : ${error.toString()}");
      String errorUrl = "Cannot get image url";
      return errorUrl;
    }
  }

  static Future<String> bodyPhotoDownload(String uid) async {
    //  * current body photo download
    try {
      String url = await FirebaseStorage.instance
          .ref("Userphotos/$uid/currentbodyphoto/choosenbodyphoto.jpg")
          .getDownloadURL();
      return url;
    } catch (error) {
      print("Error in downloading body image : ${error.toString()}");
      String errorUrl = "Cannot get image url";
      return errorUrl;
    }
  }

  static Future<String> recentbodyPhotoDownload(
      String imgName, String uid) async {
    // * recently uploaded image
    try {
      String url = await FirebaseStorage.instance
          .ref("Userphotos/$uid/bodyphotos/$imgName")
          .getDownloadURL();
      return url;
    } catch (error) {
      print("Error in downloading body image : ${error.toString()}");
      String errorUrl = "Cannot get image url";
      return errorUrl;
    }
  }
}
