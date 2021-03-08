import 'package:explore/models/handle_photos.dart';
import 'package:explore/models/image_label_ml.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/widgets/pick_photos_widgets.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class PickPhotoScreen extends StatefulWidget {
  static const routeName = "Photo-screen";

  @override
  _PickPhotoScreenState createState() => _PickPhotoScreenState();
}

class _PickPhotoScreenState extends State<PickPhotoScreen> {
  bool checkHeadPhotoUploaded = false;
  bool checkBodyPhotoUploaded = false;
  bool isLoading = false;

  void loadingOn() {
    setState(() {
      isLoading = true;
    });
  }

  void loadingOff() {
    setState(() {
      isLoading = false;
    });
  }

  void updateHeadPhoto() {
    setState(() {
      checkHeadPhotoUploaded = true;
    });
  }

  void updateBodyPhoto() {
    setState(() {
      checkHeadPhotoUploaded = true;
    });
  }

  @override
  // ? Check setstate disposed properly
  void setState(fn) {
    // ignore: todo
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          // ? dot image
          image: DecorationImage(
            image: AssetImage(
              "assets/app_images/photo_img_bg.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            headPhoto(context, updateHeadPhoto),
            bodyPhoto(context, updateBodyPhoto),
            Spacer(),
            Container(
              // ? confirm button
              width: 180,
              child: isLoading == true ? loadingSpinner() : RaisedButton(
                color: Color(0xffF8C80D),
                textColor: Color(0xff121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xffF8C80D))),
                child: Text(
                  "Confirm",
                  style: const TextStyle(
                      // fontFamily: "OpenSans",
                      // fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                onPressed: () {
                  print("Pressed confirm");
                  if (HandlePhotos.headPhoto == null ||
                      HandlePhotos.bodyPhoto == null) {
                    Flushbar(
                      messageText: Text(
                        "Please upload photos",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xff121212),
                      duration: Duration(seconds: 2),
                    )..show(context);
                  } else if (HandlePhotos.headPhoto != null ||
                      HandlePhotos.bodyPhoto != null) {
                    detectHeadPhotoAndStoreToCloud(HandlePhotos.headPhoto,
                        HandlePhotos.bodyPhoto, loadingOn, loadingOff, context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
