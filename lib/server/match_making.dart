// @dart=2.9
// todo Manage Matchmaking collection firestore
// * mm/MM - matchmaking collection
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/models/blur_hash_img.dart';
import 'package:explore/server/cloud_storage/download_photos_storage.dart';
import 'package:explore/server/https_cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart' show Geoflutterfire;

class MatchMakingCollection {
  static addCurrentUserMM(String selectedShowMe) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser.uid;
      // createMatchMakingServerSide("", "",selectedShowMe); // * 1R,3W
      // get head and body photos
        DownloadCloudStoragePhotos.headPhotoDownload(uid).then((headPhoto) {
          DownloadCloudStoragePhotos.currentBodyPhotoDownload(uid)
              .then((bodyPhoto) {
                createMatchMakingCF(headPhoto, bodyPhoto,selectedShowMe); // * 1R,3W 
          });
        });
    
    } catch (error) {
      print("Error in creating user matchmaking client side : ${error.toString()}");
    }
  }

  static updateLocationMM(double latitude, longitude, Placemark address) async {
    // * update current location of the user in matchmaking
    // * if photo fields have error will try to fix them
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      bool homo = false;
      String headPhotoHash = "";
      String bodyPhotoHash = "";
      var userMM = await FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen")
          .where("uid", isEqualTo: uid)
          .get();
      userMM.docs.forEach((element) async {
        // print("Updating user location in matchmaking ...");
        if (element.get("show_me").toString() ==
            element.get("gender").toString()) {
          homo = true;
        }
        String fullPath = element.reference.path;
        var myGeoData =
            Geoflutterfire().point(latitude: latitude, longitude: longitude);
        print("Path matchmaking : $fullPath");
        DocumentReference updateLocation =
            FirebaseFirestore.instance.doc(fullPath);
        DocumentReference updatePhotosField =
            FirebaseFirestore.instance.doc(fullPath);
        await updateLocation.update({
          "current_coordinates": myGeoData.data,
          "city": address.locality,
          "state": address.administrativeArea,
          "geohash_rounds": {
            "r1": myGeoData.hash.toString().substring(0, 5),
            "r2": myGeoData.hash.toString().substring(0, 4),
            "r3": myGeoData.hash.toString().substring(0, 3),
            "r4": myGeoData.hash.toString().substring(0, 2),
            "rh": homo,
          }
        });
        // check if photos fields have error if so try to update them
        if (element
                .get("photos.current_head_photo")
                .contains("Cannot get image url") ||
            element
                .get("photos.current_body_photo")
                .contains("Cannot get image url")) {
          print("photos field have error. So retrying to update them");
          DownloadCloudStoragePhotos.headPhotoDownload(uid).then((headPhoto) {
            DownloadCloudStoragePhotos.currentBodyPhotoDownload(uid)
                .then((bodyPhoto) async {
              if (!headPhoto.contains("Cannot get image url") &&
                  !bodyPhoto.contains("Cannot get image url")) {
                // encode photo to hash and update them
                await encodeBlurHashImg(headPhoto).then((hash) {
                  headPhotoHash = hash;
                });
                await encodeBlurHashImg(bodyPhoto).then((hash) {
                  bodyPhotoHash = hash;
                });
                if (headPhotoHash.isNotEmpty && bodyPhotoHash.isNotEmpty) {
                  // head and body hash is not empty
                  await updatePhotosField.update({
                    "photos.current_head_photo": headPhoto,
                    "photos.current_body_photo": bodyPhoto,
                    "photos.current_head_photo_hash": headPhotoHash,
                    "photos.current_body_photo_hash": bodyPhotoHash,
                  });
                  print(
                      "photos field of user matchmaking had error but now it has been fixed");
                }
              }
            });
          });
        }
      });
    } catch (error) {
      print("Error in userlocationmm ${error.toString()}");
    }
  }
}
