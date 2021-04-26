// @dart=2.9
// todo : ALl photos widgets

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/icons/eye_icons_icons.dart';
import 'package:explore/icons/gallery_icon_icons.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/models/vibration.dart';
import 'package:explore/providers/profile_state.dart';
import 'package:explore/screens/explore_screen.dart';
import 'package:explore/serverless/delete_photos_cloud_storage.dart';
import 'package:explore/serverless/profile_backend/prof_photos_backend.dart';
import 'package:explore/serverless/profile_backend/upload_photos_prof.dart';
import 'package:explore/serverless/upload_photos_cloud_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PhotosWidgets extends StatelessWidget {
  final bool showPhotosInfo;
  PhotosWidgets(this.showPhotosInfo);
  final DocumentReference photosData = FirebaseFirestore.instance.doc(
      "Users/${FirebaseAuth.instance.currentUser.uid}/Profile/profile/Photos/myphotos");
  @override
  Widget build(BuildContext context) {
    return showPhotosInfo
        ? _AlertDialogue()
        : StreamBuilder(
            stream: photosData.snapshots(),
            builder: (context, photosSnapShot) {
              if (photosSnapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: loadingSpinner(),
                );
              }
              if (photosSnapShot.hasError) {
                print("Error in photos widgets user prespective");
                return Center(
                  child: loadingSpinner(),
                );
              }
              return _MyPhotos(photosSnapShot);
            },
          );
  }
}

class _MyPhotos extends StatelessWidget {
  final AsyncSnapshot<dynamic> photosSnapShot;
  _MyPhotos(this.photosSnapShot);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: photosSnapShot.data["photos"].length,
        itemBuilder: (context, index) => Container(
          height: 400, // max height of the photo
          margin: const EdgeInsets.only(top: 15),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            child: Stack(
              children: [
                Container(
                  // ? body photos
                  child: GestureDetector(
                    child: CachedNetworkImage(
                      // ! change to mediaquery height and width if any problem arise in photos
                      // height: MediaQuery.of(context).size.height,
                      height: double.infinity,
                      width: double.infinity,
                      imageUrl: photosSnapShot.data["photos"][index]["url"],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => BlurHash(
                        hash: photosSnapShot.data["photos"][index]["hash"],
                        imageFit: BoxFit.cover,
                        color: Color(0xff121212).withOpacity(0),
                        curve: Curves.slowMiddle,
                        // image: scrollUserDetails[index]["headphoto"],
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: loadingSpinner(),
                      ),
                    ),
                    onTap: () {
                      // * open body photo
                      Navigator.pushNamed(
                        context,
                        ViewBodyPhoto.routeName,
                        arguments: photosSnapShot.data["photos"][index]["url"],
                      );
                    },
                  ),
                ),
                _SetFeedDelete(photosSnapShot.data, index),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: photosSnapShot.data["total_photos_uploaded"] >= 50
          ? null // photos uploaded is greather than or equal to 50 disable FAB
          : Consumer<ProfileState>(
              builder: (_, profileState, __) => FloatingActionButton(
                backgroundColor: Color(0xCC121212), // 80 % opacity
                splashColor: Colors.transparent,
                child: Icon(
                  profileState.bodyPhotoUploadProcess
                      ? Icons.cloud_upload_outlined
                      : Icons.add,
                  size: 30,
                  color: Color(0xffF8C80D),
                ),
                tooltip: "Upload Photo",
                onPressed: () => profileState.bodyPhotoUploadProcess
                    ? null
                    : _bodyPhotoPopUpBottomSheet(
                        context,
                        profileState.startBodyPhotoProcess,
                        profileState.stopBodyPhotoProcess),
              ),
            ),
    );
  }
}

class _SetFeedDelete extends StatelessWidget {
  final dynamic fetchedPhotosData;
  final int index;
  _SetFeedDelete(this.fetchedPhotosData, this.index);
  @override
  Widget build(BuildContext context) {
    return Align(
      // ? feed ,delete
      alignment: Alignment.topRight, // black box alignment
      child: Container(
        width: 100, // black box height
        margin: const EdgeInsets.only(top: 20, right: 10), // control black box
        decoration: BoxDecoration(
          color: Color(0xE6121212), // 90 % opacity
          borderRadius: const BorderRadius.all(
            Radius.circular(60),
          ),
        ),
        child: Row(
          children: [
            Container(
              // ? feed icon
              margin:
                  const EdgeInsets.all(7), // * if set to feed icon change to 5
              child: GestureDetector(
                child: Icon(
                  fetchedPhotosData["show_on_feeds.hash"] ==
                          fetchedPhotosData["photos"][index]["hash"]
                      ? EyeIcons.eye_1
                      : EyeIcons.eye_slash,
                  size: 33,
                  color: fetchedPhotosData["show_on_feeds.hash"] ==
                          fetchedPhotosData["photos"][index]["hash"]
                      ? Color(0xffF8C80D)
                      : Colors.white54,
                ),
                onLongPress: () {
                  // * long press to set a photo in feeds
                  String hash = fetchedPhotosData["photos"][index]["hash"];
                  String url = fetchedPhotosData["photos"][index]["url"];
                  // check if feed icon is active on selected photo
                  if (fetchedPhotosData["show_on_feeds.hash"] != hash) {
                    ProfilePhotosBackEnd.updateShowOnFeedsData(hash, url);
                    uploadCurrentBodyPhotoToCloudStorage(url, context);
                    vibrate(10); // vibrate when pressed
                    print("New feed set");
                  }
                },
              ),
            ),
            Container(
              // ? delete icon
              margin: const EdgeInsets.all(5),
              child: Consumer<ProfileState>(
                builder: (_, profileState, __) => AbsorbPointer(
                  absorbing: profileState.bodyPhotoDeleteProcess
                      ? true
                      : false, // true when delete is processing
                  child: GestureDetector(
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 40,
                      color: profileState.bodyPhotoDeleteProcess
                          ? Colors.redAccent[700]
                          : Colors.white54,
                    ),
                    onTap: () {
                      String hash = fetchedPhotosData["photos"][index]["hash"];
                      String url = fetchedPhotosData["photos"][index]["url"];
                      if (fetchedPhotosData["photos"].length == 1) {
                        // when user try to delete last photo
                        _showAlertDialogDelete(
                          context,
                          "",
                          "To get good connections we need at least one photo",
                        );
                      }
                      if (fetchedPhotosData["show_on_feeds.hash"] == hash ||
                          fetchedPhotosData["show_on_feeds.url"] == url) {
                        // when user try to delete a photo where feed is set active
                        _showAlertDialogDelete(
                          context,
                          "Access Denied",
                          "Cannot delete set another photo to show in feed and try again",
                        );
                      } else {
                        // show alert dialog if user click yes delete the photo
                        _showAlertDialogDelete(
                            context, "Alert", "Are you sure want to delete?",
                            showDeleteAlert: true,
                            hash: hash,
                            url: url,
                            startDelete:
                                profileState.startBodyPhotoDeleteProcess,
                            stopDelete:
                                profileState.stopBodyPhotoDeleteProcess);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ? when FAB is pressed
Future _bodyPhotoPopUpBottomSheet(BuildContext contextP,
    Function startBodyPhotoProcess, Function stopBodyPhotoProcess) {
  // * contextP -> contextParent of UserPrespectiveScreen
  return showBarModalBottomSheet(
      context: contextP,
      backgroundColor: Theme.of(contextP).primaryColor,
      builder: (context) => _BodyPhotoPopup(
          startBodyPhotoProcess, stopBodyPhotoProcess, contextP));
}

class _BodyPhotoPopup extends StatelessWidget {
  final Function startBodyPhotoProcess;
  final Function stopBodyPhotoProcess;
  final BuildContext contextP;
  _BodyPhotoPopup(
      this.startBodyPhotoProcess, this.stopBodyPhotoProcess, this.contextP);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 300,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // ? camera button
            margin: const EdgeInsets.only(top: 50),
            height: 70,
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton.icon(
              icon: const Icon(
                Icons.camera_alt_rounded,
                size: 40,
                color: Color(0xffF8C80D),
              ),
              splashColor: Colors.white,
              color: Colors.white,
              textColor: Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text(
                "Camera",
                style: const TextStyle(
                    // fontFamily: "OpenSans",
                    // fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              onPressed: () {
                print("Pressed camera");
                HandlePhotosForProfile.uploadBodyPhotoCamera(
                    startBodyPhotoProcess, stopBodyPhotoProcess, contextP);
                Navigator.pop(context);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
          ), // outer spacing
          Container(
            // ? gallery button
            height: 70,
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton.icon(
              icon: const Icon(
                GalleryIcon.picture,
                size: 40,
                color: Color(0xffF8C80D),
              ),
              splashColor: Colors.white,
              color: Colors.white,
              textColor: Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text(
                "Gallery",
                style: const TextStyle(fontSize: 25),
              ),
              onPressed: () {
                print("Pressed gallery");
                HandlePhotosForProfile.uploadBodyPhotoGallery(
                    startBodyPhotoProcess, stopBodyPhotoProcess, contextP);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertDialogue extends StatelessWidget {
  showAlertDialogBox(BuildContext context) {
    Widget sure = Container(
      margin: const EdgeInsets.only(right: 15),
      // ignore: deprecated_member_use
      child: FlatButton(
        splashColor: Color(0xffF8C80D),
        child: const Text(
          "Ok",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => ProfilePhotosBackEnd.showPhotosInfo(),
      ),
    );
    Widget learnMore = Container(
      margin: const EdgeInsets.only(right: 15),
      // ignore: deprecated_member_use
      child: FlatButton(
          splashColor: Color(0x4DF8C80D), // 30 % opacity
          child: const Text(
            "Learn More",
            style: const TextStyle(
                color: Color(0xCCF8C80D), fontSize: 18), // 80 % opacity
          ),
          onPressed: () {}),
    );
    AlertDialog showAlert = AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        side: const BorderSide(color: Color(0xffF8C80D), width: 2),
      ),
      title: const Text(
        "Info",
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        // ! explain how photos work
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      actions: [learnMore, sure],
    );

    return showAlert;
  }

  @override
  Widget build(BuildContext context) {
    return showAlertDialogBox(context);
  }
}

void _showAlertDialogDelete(BuildContext context, String title, String content,
    {bool showDeleteAlert = false,
    Function startDelete,
    Function stopDelete,
    String hash = "",
    String url = ""}) {
  // * when feed icon is set active user tires to delete the photo
  // ignore: deprecated_member_use
  Widget okay = Container(
    margin: const EdgeInsets.only(right: 15),
    // ignore: deprecated_member_use
    child: FlatButton(
      splashColor: Color(0xCCF8C80D), // 80 % opacity
      child: const Text(
        "Ok",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () => Navigator.pop(context),
    ),
  );
  Widget yes = Container(
    margin: const EdgeInsets.only(right: 15),
    // ignore: deprecated_member_use
    child: FlatButton(
      splashColor: Color(0xCCF8C80D), // 80 % opacity
      child: const Text(
        "Yes",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {
        ProfilePhotosBackEnd.deletePhoto(hash, url, startDelete, stopDelete);
        deleteBodyPhotoFromCloudStorage(url, context);
        Navigator.pop(context);
      },
    ),
  );
  Widget no = Container(
    margin: const EdgeInsets.only(right: 15),
    // ignore: deprecated_member_use
    child: FlatButton(
      splashColor: Color(0xffF8C80D),
      child: const Text(
        "No",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () => Navigator.pop(context),
    ),
  );
  AlertDialog showAlert = AlertDialog(
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      side: const BorderSide(color: Color(0xffF8C80D), width: 2),
    ),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    content: Text(
      content,
      textAlign: TextAlign.start,
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white, fontSize: 18),
    ),
    actions: showDeleteAlert ? [no, yes] : [okay],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return showAlert;
      });
}
