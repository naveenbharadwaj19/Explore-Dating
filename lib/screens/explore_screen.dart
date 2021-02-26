// todo : Feeds of dating

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/temp/filter_datas.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/icons/filter_report_icons.dart';
import 'package:explore/icons/star_rounded_icon_icons.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/providers/pageview_logic.dart';
import 'package:explore/serverless/connecting_users.dart';
import 'package:explore/serverless/geohash_custom_radius.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ? : topBox -> head photo ,name,age,location
// ? : middleBox -> body photo
//  ? lowerBox -> heart , star , report

class ExploreScreen extends StatelessWidget {
  // final Color yellow = Color(0xffF8C80D);
  // final Color black = Color(0xff121212);
  // final Color white = Color(0xffFFFFFF);

  @override
  Widget build(BuildContext context) {
    final pageViewLogic = Provider.of<PageViewLogic>(context);
    return StreamBuilder<DocumentSnapshot>(
      // ? refresh when filters value update // -> 1
      stream: FirebaseFirestore.instance
          .doc("Users/${FirebaseAuth.instance.currentUser.uid}/Filters/data")
          .snapshots(),
      builder: (context1, filterSnapShot) {
        if (filterSnapShot.connectionState == ConnectionState.waiting) {
          return loadFeeds();
        }
        if (filterSnapShot.hasError) {
          print("Error in filters collection stream builder");
          return loadingSpinner();
        }
        if (scrollUserDetails.isEmpty && filterSnapShot.data["radius"] == 200) {
          print("Feeds are empty loading feeds");
          ConnectingUsers.basicUserConnection();
        }
        if (scrollUserDetails.isEmpty && filterSnapShot.data["radius"] != 200) {
          print(
              "Feeds are empty loading feeds within ${filterSnapShot.data["radius"]}");
          ConnectingUsers.basicUserConnection();
        }
        return FutureBuilder(
          // ? 2
          // ? hold future for 1 second to update scroll items
          future: Future.delayed(Duration(seconds: 1)),
          builder: (context2, pauseSnapShot) {
            if (pauseSnapShot.connectionState == ConnectionState.waiting) {
              return loadFeeds();
            }
            if (pauseSnapShot.hasError) {
              print("Error in loading scroll items");
              return loadFeeds();
            }
            return scrollUserDetails.isEmpty // ? 3
                ? nothingToExplore(pageViewLogic.startRefresh, context) // ? 4
                : PageView.builder(
                    // ? 5
                    key: PageStorageKey(
                        "scroll-feeds-${pageViewLogic.pageStorageKeyNo}"),
                    physics: PageScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    dragStartBehavior: DragStartBehavior.down, // drage behavior
                    onPageChanged: (index) {
                      if (newRadius == 180 &&
                          ConnectingUsers.latestUid.isNotEmpty) {
                        // ? fetch data only if uid is not empty
                        if (scrollUserDetails.length == index + 1) { // whole country
                          ConnectingUsers.paginateBasicUserConnection();
                          pageViewLogic.updateIncrement();
                        }
                      } else if (newRadius != 180 &&
                          CustomRadiusGeoHash.latestUid.isNotEmpty) { // custom radius -> geohash
                        // ? fetch data only if uid is not empty
                        if (scrollUserDetails.length == index + 1) {
                          ConnectingUsers.paginateBasicUserConnection();
                          pageViewLogic.updateIncrement();
                        }
                      }
                    },
                    itemBuilder: (context3, index) {
                      print("index : ${index + 1}");
                      return Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            topBox(index),
                            Expanded(child: middleBox(index, context)),
                          ],
                        ),
                      );
                    },
                    itemCount: scrollUserDetails.length,
                  );
          },
        );
      },
    );
  }
}

Widget topBox(int index) {
  return Container(
    height: 100,
    decoration: BoxDecoration(
      color: Color(0xCCF8C80D),
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(30),
        topRight: const Radius.circular(30),
      ),
    ),
    child: Stack(
      children: [
        Container(
          // ? head photo
          margin: const EdgeInsets.only(top: 10, left: 15),
          alignment: Alignment.topLeft,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xff121212),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: scrollUserDetails[index]["headphoto"].toString(),
                fit: BoxFit.cover,
                placeholder: (context, url) => whileHeadImageloadingSpinner(),
                errorWidget: (context, url, error) =>
                    whileHeadImageloadingSpinner(),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, left: 110),
          child: Row(
            // ? handle name and age widgets
            children: [
              Container(
                // ? name text
                child: GestureDetector(
                  child: Text(
                    "${scrollUserDetails[index]["name"]},",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xff121212),
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    print("Tapping $index");
                  },
                ),
              ),
              Container(
                // ? age text
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  "${scrollUserDetails[index]["age"]}",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xff121212),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 55, left: 95),
          // ? city and state
          padding: EdgeInsets.only(left: 15),
          child: Text(
            "${scrollUserDetails[index]["city_state"]}",
            style: const TextStyle(
                fontSize: 15,
                color: Color(0xff121212),
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}

Widget middleBox(int index, BuildContext context) {
  // print( MediaQuery.of(context).size.height);
  final double height = MediaQuery.of(context).size.height;
  return Container(
    child: Stack(
      children: [
        Container(
          child: GestureDetector(
            // ? body photo
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(30),
                bottomRight: const Radius.circular(30),
              ),
              child: CachedNetworkImage(
                // ! change to mediaquery height and width if any problem arise in photos
                // height: MediaQuery.of(context).size.height,
                height: double.infinity,
                width: double.infinity,
                imageUrl: scrollUserDetails[index]["bodyphoto"].toString(),
                fit: BoxFit.cover,
                placeholder: (context, url) => loadingSpinner(),
                errorWidget: (context, url, error) =>
                    Center(child: loadingSpinner()),
              ),
            ),
            onTap: () => Navigator.pushNamed(context, ViewBodyPhoto.routeName,
                arguments: scrollUserDetails[index]["bodyphoto"].toString()),
          ),
        ),
        // ? lower box inside image
        Positioned.fill(
          child: Align(
              alignment:
                  height < 700 ? Alignment.bottomCenter : Alignment(0.0, 1.0),
              child: lowerBox(index)),
        ),
      ],
    ),
  );
}

Widget lowerBox(int index) {
  final double heartIconSize = 50;
  final double reportIconSize = 60;
  final double starIconSize = 40;
  return Container(
    // ? heart , star , report widgets
    child: Container(
      // ? control black box
      width: 255,
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
        // ? 90 - opacity
        color: Color(0xE6121212),
        borderRadius: const BorderRadius.all(Radius.circular(60)),
      ),
      child: Row(
        children: [
          Container(
            // ? heart icon
            margin: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              child: Icon(
                Icons.favorite_border_rounded,
                color: Colors.red,
                size: heartIconSize,
              ),
              onTap: () {
                print("Pressed heart $index");
              },
            ),
          ),
          Container(
            // ? star icon
            margin: const EdgeInsets.only(left: 40, bottom: 3),
            child: GestureDetector(
              child: Icon(
                // Icons.star_border_outlined,
                StarRoundedIcon.star,
                color: Color(0xffF8C80D),
                size: starIconSize,
              ),
              onTap: () {
                print("Pressed star $index");
              },
            ),
          ),
          Container(
            // ? report icon
            margin: const EdgeInsets.only(left: 30, top: 15),
            child: GestureDetector(
              child: Icon(
                FilterReport.noun_caution_3320810,
                color: Colors.white54,
                size: reportIconSize,
              ),
              onTap: () {
                print("Pressed report $index");
              },
            ),
          ),
        ],
      ),
    ),
  );
}

// ? View body photo
class ViewBodyPhoto extends StatelessWidget {
  static const routeName = "view-body-photo";

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context).settings.arguments;
    return Container(
      // * show user original image
      color: Theme.of(context).primaryColor,
      child: GestureDetector(
        child: CachedNetworkImage(
          // height: 500,
          width: double.infinity,
          imageUrl: url,
          // fit: BoxFit.cover,
          placeholder: (context, url) => loadingSpinner(),
          errorWidget: (context, url, error) => loadingSpinner(),
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}

Widget nothingToExplore(Function refresh, BuildContext context) {
  // ? when no feeds to show
  return Container(
    child: Center(
      child: Column(
        children: [
          Container(
              // ? search icon
              margin: const EdgeInsets.only(top: 20),
              child: const Icon(
                Icons.search_rounded,
                size: 100,
                color: Colors.white,
              )),
          Container(
            // ? text message
            margin: const EdgeInsets.all(20),
            child: const Text(
              "You've explored nearby people.\n Try again or comeback later or change your filter.",
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            // ? refresh
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: IconButton(
              icon: const Icon(Icons.loop_rounded),
              color: Colors.white,
              iconSize: 35,
              disabledColor: Colors.transparent,
              splashColor: Theme.of(context).primaryColor,
              // ! any lack in UI performance change on pressed syntax
              onPressed: () => refresh(),
              tooltip: "Refresh",
            ),
          ),
        ],
      ),
    ),
  );
}
