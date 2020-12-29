import 'package:Explore/widgets/pick_photos_widgets.dart';
import 'package:flutter/material.dart';

class PickPhotoScreen extends StatelessWidget {
  static const routeName = "Photo-screen";
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
            headPhoto(context),
            bodyPhoto(context),
            Spacer(),
            Container(
              // ? confirm button
              width: 180,
              child: RaisedButton(
                color: Color(0xffF8C80D),
                textColor: Color(0xff121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xffF8C80D))),
                child: Text(
                  "Confirm",
                  style: TextStyle(
                      // fontFamily: "OpenSans",
                      // fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
