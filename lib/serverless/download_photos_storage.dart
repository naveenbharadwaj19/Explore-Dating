// todo : Manage downloads of cloud storage

import 'package:firebase_storage/firebase_storage.dart';

class DownloadCloudStorage{
  static Future<String> headImageDownload(String uid) async{
    try{
    String url = await FirebaseStorage.instance.ref("Userphotos/$uid/currentheadphoto/choosenheadphoto.jpg").getDownloadURL();
    return url;
    } catch(error){
      print("Error in downloading head image : ${error.toString()}");
      return null;
    }
  }
  static Future<String> bodyImageDownload(String uid) async{
    try{
    String url = await FirebaseStorage.instance.ref("Userphotos/$uid/currentbodyphoto/choosenbodyphoto.jpg").getDownloadURL();
    return url;
    } catch(error){
      print("Error in downloading head image : ${error.toString()}");
      return null;
    }
  }
}