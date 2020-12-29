import 'package:Explore/icons/gallery_icon_icons.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Widget headPhoto(BuildContext context) {
  // * head photo aka - top notch photo
  // ? arc package
  return Arc(
    height: 50,
    arcType: ArcType.CONVEY,
    clipShadows: [
      ClipShadow(
        color: Color(0xff121212),
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
            margin: EdgeInsets.only(top:30),
            child: Text(
              "-Choose your style-",
              style: TextStyle(color: Color(0xffF8C80D), fontSize: 25),
            ),
          ),
          // ? circle and shadow
          Container(
            margin: EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
              // ? shadow
              // color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    blurRadius: 7, color: Color(0x80F41010), spreadRadius: 3.5),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                // * backend - when pressed head photo
                print("Pressed head photo");
                _choosePhotoOptions(context);
              },
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Color(0xffF8C80D),
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Color(0xff121212),
                  child: Icon(
                    Icons.add,
                    color: Color(0xffF8C80D),
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    ),
  );
}

Widget bodyPhoto(BuildContext context) {
  // * body photo
  return GestureDetector(
    onTap: () {
      // * backend  - when pressed body photo
      print("Pressed body photo");
      _choosePhotoOptions(context);
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
          BoxShadow(blurRadius: 7, color: Color(0x80F41010), spreadRadius: 3.5),
        ],
        // ? outline border color
        border: Border.all(color: Color(0xffF8C80D), width: 4),
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Icon(
        Icons.add,
        color: Color(0xffF8C80D),
        size: 40,
      ),
    ),
  );
}

Future _choosePhotoOptions(BuildContext context) {
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
            margin: EdgeInsets.only(top: 50),
            height: 70,
            width: 180,
            child: RaisedButton.icon(
              icon: Icon(Icons.camera_alt_rounded,size: 40,),
              splashColor: Color(0xff121212),
              color: Color(0xff121212),
              textColor: Color(0xffF8C80D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text(
                "Camera",
                style: TextStyle(
                    // fontFamily: "OpenSans",
                    // fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              onPressed: () {
                print("Pressed camera");
              },
            ),
          ),
          Padding(padding: EdgeInsets.all(20),),
          Container(
            // ? gallery button
            height: 70,
            width: 180,
            child: RaisedButton.icon(
              icon: Icon(GalleryIcon.picture,size: 40,),
              splashColor: Color(0xff121212),
              color: Color(0xff121212),
              textColor: Color(0xffF8C80D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text(
                "Gallery",
                style: TextStyle(
                    // fontFamily: "OpenSans",
                    // fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              onPressed: () {
                print("Pressed gallery");
              },
            ),
          ),
        ],
      ),
    ),
  );
}
