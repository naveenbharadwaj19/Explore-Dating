// @dart=2.9
// todo : user prespective profile screen

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:explore/icons/gallery_icon_icons.dart';
import 'package:explore/models/all_enums.dart';
import 'package:explore/models/location.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/screens/profile/preview_screen.dart';
import 'package:explore/server/profile_backend/abt_me_backend.dart';
import 'package:explore/server/profile_backend/upload_photos_prof.dart';
import 'package:explore/widgets/profilewidgets/about_widgets.dart';
import 'package:explore/widgets/profilewidgets/photos_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// ? topbox -> headphoto , name , age , location , screens

// * overall CRUD for user perspective page
// * 13R,13W -> about me widget
// * 1R,1W -> for head photo upload
// * 1 R - > everytime user navigates to profile
// * No of R , No W , evertime a body photo is uploaded , deleted max -> 50 photos (50W,50R)

class UserPrespectiveScreen extends StatelessWidget {
  final DocumentReference profilepath = FirebaseFirestore.instance
      .doc("Users/${FirebaseAuth.instance.currentUser.uid}/Profile/profile");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black12, // status bar color
          statusBarIconBrightness: Brightness
              .light, // text brightness -> light for dark app -> vice versa
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 70,
        title: Container(
          margin: const EdgeInsets.only(top: 5),
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(children: [
              const TextSpan(
                text: "Explore\n",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: "Domine",
                    decoration: TextDecoration.none),
              ),
              const TextSpan(
                text: "Dating",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Domine",
                    decoration: TextDecoration.none),
              ),
            ]),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: profilepath.snapshots(),
        builder: (context, profileSnapShot) {
          if (profileSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: loadingSpinner());
          }
          if (profileSnapShot.hasError) {
            print("Error in user prespective profile screen");
            return Center(child: loadingSpinner());
          }
          if (!profileSnapShot.data["do_not_show_again"]) {
            return _AlertDialogue(profileSnapShot.data);
          }
          return DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      // ? top box
                      Center(
                        child: Column(
                          children: [
                            Container(
                              // ? head photo
                              margin: const EdgeInsets.only(top: 20),
                              child: GestureDetector(
                                onTap: () {
                                  print("Pressed head photo");
                                  _headPhotoPopUp(context);
                                },
                                child: DottedBorder(
                                  color: Color(0xffF8C80D),
                                  strokeWidth: 2.5,
                                  dashPattern: [15, 10],
                                  borderType: BorderType.Circle,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Color(0xff121212),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: profileSnapShot
                                            .data["head_photo.url"],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => BlurHash(
                                          hash: profileSnapShot
                                              .data["head_photo.hash"],
                                          imageFit: BoxFit.cover,
                                          color:
                                              Color(0xff121212).withOpacity(0),
                                          curve: Curves.slowMiddle,
                                          // image: scrollUserDetails[index]["headphoto"].toString(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                          child: const Text(
                                              "Upload different photo",
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              // ? name,age
                              margin: const EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // ? name
                                    child: Text(
                                      "${profileSnapShot.data["name"]},",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    // ? age
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      "${profileSnapShot.data["age"]}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // ? location
                          
                              margin: const EdgeInsets.only(top: 15),
                              child: Container(
                                alignment: Alignment.center,
                                // ? city & state
                                child: Text(
                                  profileSnapShot
                                              .data["location.city"].isEmpty ||
                                          profileSnapShot
                                              .data["location.state"].isEmpty
                                      ? ""
                                      : "${profileSnapShot.data["location.city"]},${profileSnapShot.data["location.state"]}", // can hold upto 43 characters max
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ];
              },
              body: Column(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.all(20)),
                  TabBar(
                    tabs: [
                      const Text(
                        "About",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const Text(
                        "Photos",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        AboutWidgets(profileSnapShot.data),
                        PhotosWidgets(profileSnapShot.data["show_photos_info"]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Future _headPhotoPopUp(BuildContext contextP) {
  // * contextP -> contextParent of UserPrespectiveScreen
  return showBarModalBottomSheet(
      context: contextP,
      backgroundColor: Theme.of(contextP).primaryColor,
      builder: (context) => _HeadPhotoPopUp(contextP));
}

class _HeadPhotoPopUp extends StatelessWidget {
  final BuildContext contextP;
  _HeadPhotoPopUp(this.contextP);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 400,
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
                HandlePhotosForProfile.uploadHeadPhotoCamera(contextP);
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
                style: const TextStyle(
                    // fontFamily: "OpenSans",
                    // fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              onPressed: () {
                print("Pressed gallery");
                HandlePhotosForProfile.uploadHeadPhotoGallery(contextP);
                Navigator.pop(context);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
          ),
          Container(
            // ? preview button
            height: 70,
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton.icon(
              icon: const Icon(
                Icons.preview_rounded,
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
                "Preview",
                style: const TextStyle(
                    // fontFamily: "OpenSans",
                    // fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              onPressed: () {
                print("Pressed preview");
                Navigator.pushReplacementNamed(
                    context, PreviewScreen.routeName,
                    arguments: {
                      "uid": FirebaseAuth.instance.currentUser.uid,
                      "preview_type": PreviewType.previewOwnProfile,
                      "index":
                          9999 // user will not reach this index number in feeds
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertDialogue extends StatelessWidget {
  final dynamic fetchedProfileSnapShot;
  _AlertDialogue(this.fetchedProfileSnapShot);
  showAlertDialogBox(BuildContext context) {
    Widget sure = Container(
      margin: const EdgeInsets.only(right: 15),
      // ignore: deprecated_member_use
      child: FlatButton(
        splashColor: Color(0xffF8C80D),
        child: const Text(
          "Sure",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          if (fetchedProfileSnapShot["location.city"].isEmpty ||
              fetchedProfileSnapShot["location.state"].isEmpty) {
            // if location data is empty try again
            print("Profile location details is empty trying again");
            LocationModel.getLatitudeAndLongitude().then((currentPosition) {
              LocationModel.getAddress(
                      currentPosition.latitude, currentPosition.longitude)
                  .then((address) {
                if (address != null) {
                  // preventing location data to null
                  ProfileAboutMeBackEnd.updateProfileLocation(address); // * 1W
                }
              });
            });
          }
          ProfileAboutMeBackEnd.doNotShowAgainMessage();
        },
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
      title: const Text(
        "Whoops",
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "To get potential matches please fill out the missing fields",
        maxLines: 2,
        textAlign: TextAlign.justify,
        overflow: TextOverflow.clip,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      actions: [sure],
    );

    return showAlert;
  }

  @override
  Widget build(BuildContext context) {
    return showAlertDialogBox(context);
  }
}
