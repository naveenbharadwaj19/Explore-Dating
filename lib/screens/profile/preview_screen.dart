// @dart=2.9
// todo : Other user prespective screen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/models/all_enums.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/screens/home/explore_screen.dart';
import 'package:explore/widgets/profilewidgets/preview_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

// ? OUPS -> other user prespective screen
// ? top -> head photo , name , age , location
// ? middle -> current body photo,
// ? lower -> grid of remaining body photos
// ? Wrap1 -> combine more than widget of about me data -> education level , education , work
// ? Wrap2 -> height,exercise,smoking,drinking,looking for,kids,zodiac signs

// * icon size -> 35
// * font size -> 18
// * title font color -> white70

// * 2 R
class PreviewScreen extends StatelessWidget {
  static const routeName = "preview";

  @override
  Widget build(BuildContext context) {
    final arugments = ModalRoute.of(context).settings.arguments as Map;
    final profileAboutMeDatas = FirebaseFirestore.instance
        .doc("Users/${arugments["uid"]}/Profile/profile");
    final profilePhotosData = FirebaseFirestore.instance
        .doc("Users/${arugments["uid"]}/Profile/profile/Photos/myphotos");
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
      body: FutureBuilder(
        future: profileAboutMeDatas.get(),
        builder: (context, aboutMeData) {
          if (aboutMeData.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingSpinner(),
            );
          }
          if (aboutMeData.hasError) {
            return Center(
              child: loadingSpinner(),
            );
          }
          return FutureBuilder(
            future: profilePhotosData.get(),
            builder: (context, photosData) {
              if (photosData.connectionState == ConnectionState.waiting) {
                return Center(
                  child: loadingSpinner(),
                );
              }
              if (photosData.hasError) {
                return Center(
                  child: loadingSpinner(),
                );
              }
              return !aboutMeData.data.exists || !photosData.data.exists
                  ? _errorMessage(context)
                  : _SliverList(
                      aboutMeData: aboutMeData.data,
                      photosData: photosData.data,
                      previewType: arugments["preview_type"],
                      index: arugments["index"],
                    );
            },
          );
        },
      ),
    );
  }
}

class _OUPSTop extends StatelessWidget {
  // ? head photo , name , age , location
  final dynamic aboutMeData;
  _OUPSTop(this.aboutMeData);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          children: [
            Container(
              // ? head photo
              margin: const EdgeInsets.only(top: 20),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xff121212),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: aboutMeData["head_photo.url"],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => BlurHash(
                      hash: aboutMeData["head_photo.hash"],
                      imageFit: BoxFit.cover,
                      color: Color(0xff121212).withOpacity(0),
                      curve: Curves.slowMiddle,
                      // image: scrollUserDetails[index]["headphoto"].toString(),
                    ),
                    errorWidget: (context, url, error) =>
                        whileHeadImageloadingSpinner(),
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
                      "${aboutMeData["name"]},",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Container(
                    // ? age
                    margin: const EdgeInsets.only(left: 5),
                    child: Text(
                      "${aboutMeData["age"]}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // ? location
              // ! might cause pixel overflow
              margin: const EdgeInsets.only(top: 15),
              child: Container(
                alignment: Alignment.center,
                // ? city & state
                child: Text(
                  aboutMeData["location.city"].isEmpty ||
                          aboutMeData["location.state"].isEmpty
                      ? ""
                      : "${aboutMeData["location.city"]},${aboutMeData["location.state"]}", // can hold upto 43 characters max
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OUPSMiddle extends StatelessWidget {
  // ? current body photo
  final dynamic photosData;
  _OUPSMiddle(this.photosData);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      // ? current body photo
      child: Container(
        height: 400, // max height
        margin: const EdgeInsets.only(top: 30),
        child: GestureDetector(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            child: CachedNetworkImage(
              // ! change to mediaquery height and width if any problem arise in photos
              // height: MediaQuery.of(context).size.height,
              width: double.infinity,
              imageUrl: photosData["show_on_feeds"]["url"],
              fit: BoxFit.cover,
              placeholder: (context, url) => BlurHash(
                hash: photosData["show_on_feeds"]["hash"],
                imageFit: BoxFit.cover,
                color: Color(0xff121212).withOpacity(0),
                curve: Curves.slowMiddle,
                // image: scrollUserDetails[index]["headphoto"],
              ),
              errorWidget: (context, url, error) => Center(
                child: loadingSpinner(),
              ),
            ),
          ),
          onTap: () {
            // * open body photo
            Navigator.pushNamed(
              context,
              ViewBodyPhoto.routeName,
              arguments: photosData["show_on_feeds"]["url"],
            );
          },
        ),
      ),
    );
  }
}

class _OUPSLower extends StatelessWidget {
  // ? body photos
  final dynamic photosData;
  _OUPSLower(this.photosData);

  List photosLst() {
    List photosLst = photosData["photos"];
    int index;
    photosLst.forEach((data) {
      // remove show feeds url and hash from list
      if (data["url"] == photosData["show_on_feeds"]["url"]) {
        int tempIndex = photosLst.indexOf(data);
        index = tempIndex;
      }
    });
    photosLst.removeAt(index);
    return photosLst;
  }

  @override
  Widget build(BuildContext context) {
    return photosLst().isEmpty
        ? SliverToBoxAdapter(
            child: Container(),
          )
        : SliverPadding(
            padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
            sliver: SliverGrid.extent(
              maxCrossAxisExtent: 150,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
              children: List.generate(
                photosLst().length,
                (index) => Container(
                  child: GestureDetector(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        imageUrl: photosLst()[index]["url"],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => BlurHash(
                          hash: photosLst()[index]["hash"],
                          imageFit: BoxFit.cover,
                          color: Color(0xff121212).withOpacity(0),
                          curve: Curves.slowMiddle,
                          // image: scrollUserDetails[index]["headphoto"],
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: loadingSpinner(),
                        ),
                      ),
                    ),
                    onTap: () {
                      // * open body photo
                      Navigator.pushNamed(
                        context,
                        ViewBodyPhoto.routeName,
                        arguments: photosLst()[index]["url"],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
  }
}

class _SliverList extends StatelessWidget {
  // ? sliver list to mangage the scroll
  // entry point for preview
  final dynamic aboutMeData;
  final dynamic photosData;
  final PreviewType previewType;
  final int index;
  _SliverList(
      {@required this.aboutMeData,
      @required this.photosData,
      @required this.previewType,
      @required this.index});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _OUPSTop(aboutMeData), // head photo , name ...
        _OUPSMiddle(photosData), // current body photo
        oUPSAboutMe(
            aboutMeData, context), // about me ,title wraped inside the widget
        OtherUserPrespectiveScreenTitles.myInterestsTitle(aboutMeData), // title
        oUPSMyInterest(aboutMeData, context), // my interests
        OtherUserPrespectiveScreenTitles.myBasicInfoTitle(aboutMeData),
        oUPSWarp1(aboutMeData, context), // education lvl , education , work
        OUPSWrap2(aboutMeData), // gym, smoking,drinking, kids ...
        OtherUserPrespectiveScreenTitles.albumTitle(photosData), // title
        _OUPSLower(photosData), // group of body photos aka album
        oUPSFrom(aboutMeData, context), // from,title wraped inside the widget
        starReport(previewType, index), // star and report
      ],
    );
  }
}

Widget _errorMessage(BuildContext context) {
  return Center(
    child: Container(
      margin: const EdgeInsets.all(15),
      child: RichText(
        text: TextSpan(
          text:
              "Something went wrong.This might happen if profile was deleted.If you see this message often ",
          style: TextStyle(color: Colors.white, fontSize: 16),
          children: [
            TextSpan(
              text: "report as bug ",
              style: TextStyle(
                  color: Theme.of(context).buttonColor,
                  fontSize: 16,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // todo link report bug forum
                  print("open report bug forum");
                },
            ),
          ],
        ),
        textAlign: TextAlign.center,
        maxLines: 5,
        overflow: TextOverflow.clip,
      ),
    ),
  );
}
