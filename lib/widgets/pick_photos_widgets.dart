// @dart=2.9
import 'dart:io';

import 'package:explore/icons/gallery_icon_icons.dart';
import 'package:explore/models/handle_photos.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Widget headPhoto(BuildContext context,Function updateHeadPhoto) {
  // * head photo aka - top notch photo
  // ? arc package
  return Arc(
    height: 50,
    arcType: ArcType.CONVEY,
    clipShadows: [
      ClipShadow(
        color: Color(0x80F8C80D),
        elevation: 15
      ),
    ],
    child: Container(
      height: 350,
      color: Color(0xff121212),
      // ? to use the clippy flutter package use widgets inside the center widget
      child: Center(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Text(
              "-Profile-",
              style: const TextStyle(color: Color(0xffF8C80D), fontSize: 25),
            ),
          ),
          // ? circle and shadow
          Container(
            margin: const EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
              // ? shadow
              // color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    blurRadius: 7, color: Color(0x80F8C80D), spreadRadius: 4),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                print("Pressed head photo");
                _PhotoOptions.choosePhotoOptionsForHeadPhoto(context, updateHeadPhoto);
              },
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Color(0xffF8C80D),
                child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Color(0xff121212),
                    backgroundImage: HandlePhotos.headPhoto == null
                        ? null
                        : FileImage(File(HandlePhotos.headPhoto)),
                    child: HandlePhotos.headPhoto == null
                        ? Icon(
                            Icons.add,
                            color: Color(0xffF8C80D),
                            size: 40,
                          )
                        : null),
              ),
            ),
          ),
        ],
      )),
    ),
  );
}

Widget bodyPhoto(BuildContext context,Function updateBodyPhoto) {
  // * body photo
  return GestureDetector(
    onTap: () {
      print("Pressed body photo");
      _PhotoOptions.choosePhotoOptionsForBodyPhoto(context,updateBodyPhoto);
    },
    child: Container(
        alignment: Alignment.center,
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          // ? inside color
          color: Color(0xff121212),
          boxShadow: [
            // ? shadow color
            BoxShadow(
                blurRadius: 7, color: Color(0x80F8C80D), spreadRadius: 4),
          ],
          // ? outline border color
          border: Border.all(color: Color(0xffF8C80D), width: 4),
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
          image: HandlePhotos.bodyPhoto != null
          // * fit the choosen image properly
              ? DecorationImage(
                  image: FileImage(
                    File(HandlePhotos.bodyPhoto),
                  ),
                  // ! if photo doesn't fit properly change to fill
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: HandlePhotos.bodyPhoto == null
            ? Icon(
                Icons.add,
                color: Color(0xffF8C80D),
                size: 40,
              )
            : null),
  );
}

class _PhotoOptions {
  // ? to track when photo part user choosen (heady or body)
  static Future<void> choosePhotoOptionsForHeadPhoto(BuildContext context, Function updateHeadPhoto) {
    return showBarModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
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
                icon: Icon(
                  Icons.camera_alt_rounded,
                  size: 40,
                ),
                splashColor: Color(0xff121212),
                color: Color(0xff121212),
                textColor: Color(0xffF8C80D),
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
                  HandlePhotos.openCameraForHeadPhoto(updateHeadPhoto,context);
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            Container(
              // ? gallery button
              height: 70,
              width: 180,
              // ignore: deprecated_member_use
              child: RaisedButton.icon(
                icon: Icon(
                  GalleryIcon.picture,
                  size: 40,
                ),
                splashColor: Color(0xff121212),
                color: Color(0xff121212),
                textColor: Color(0xffF8C80D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                label: Text(
                  "Gallery",
                  style: const TextStyle(
                      // fontFamily: "OpenSans",
                      // fontWeight: FontWeight.w700,
                      fontSize: 25),
                ),
                onPressed: () {
                  print("Pressed gallery");
                  HandlePhotos.openGalleryForHeadPhoto(updateHeadPhoto,context);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> choosePhotoOptionsForBodyPhoto(BuildContext context,Function uploadBodyPhoto) {
    return showBarModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
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
                icon: Icon(
                  Icons.camera_alt_rounded,
                  size: 40,
                ),
                splashColor: Color(0xff121212),
                color: Color(0xff121212),
                textColor: Color(0xffF8C80D),
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
                  HandlePhotos.openCameraForBodyPhoto(uploadBodyPhoto,context);
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            Container(
              // ? gallery button
              height: 70,
              width: 180,
              // ignore: deprecated_member_use
              child: RaisedButton.icon(
                icon: Icon(
                  GalleryIcon.picture,
                  size: 40,
                ),
                splashColor: Color(0xff121212),
                color: Color(0xff121212),
                textColor: Color(0xffF8C80D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                label: Text(
                  "Gallery",
                  style: const TextStyle(
                      // fontFamily: "OpenSans",
                      // fontWeight: FontWeight.w700,
                      fontSize: 25),
                ),
                onPressed: () {
                  print("Pressed gallery");
                  HandlePhotos.openGalleryForBodyPhoto(uploadBodyPhoto,context);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
