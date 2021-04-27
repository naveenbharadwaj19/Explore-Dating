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

  static Future<String> currentBodyPhotoDownload(String uid) async {
    //  * current body photo download
    // * current body photo folder might lead to token expiration and 404 errors
    // * check bodyphotos folder first element and convert it to url
    try {
      var getFirstPhoto = await FirebaseStorage.instance
          .ref("Userphotos/$uid/bodyphotos").listAll();
      String url = await getFirstPhoto.items.first.getDownloadURL();
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
