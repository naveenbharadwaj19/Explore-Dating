// todo : Feeds of dating

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/temp/filter_datas.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/icons/report_filter_icons_icons.dart';
import 'package:explore/icons/star_rounded_icon_icons.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/providers/pageview_logic.dart';
import 'package:explore/serverless/connecting_users.dart';
import 'package:explore/serverless/geohash_custom_radius.dart';
import 'package:explore/serverless/hearts.dart';
import 'package:explore/serverless/notifications.dart';
import 'package:explore/serverless/stars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    final pageViewLogic = Provider.of<PageViewLogic>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      // ? refresh when filters value update // -> 1
      stream: FirebaseFirestore.instance
          .doc("Users/${FirebaseAuth.instance.currentUser.uid}/Filters/data")
          .snapshots(),
      builder: (context1, filterSnapShot) {
        if (filterSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(
              "Loading",
              style: TextStyle(color: Color(0xff121212), fontSize: 30),
            ),
          );
        }
        if (filterSnapShot.hasError) {
          print("Error in filters collection stream builder");
          return loadFeeds();
        }

        if (scrollUserDetails.isEmpty &&
            filterSnapShot.data["radius"] == 180 &&
            pageViewLogic.callConnectingUsers) {
          print("WC : Feeds are empty loading feeds");
          ConnectingUsers.basicUserConnection(context);
          pageViewLogic.callConnectingUsers = false;
        }
        if (scrollUserDetails.isEmpty &&
            filterSnapShot.data["radius"] != 180 &&
            pageViewLogic.callConnectingUsers) {
          print(
              "CR : Feeds are empty loading feeds within ${filterSnapShot.data["radius"]}");
          ConnectingUsers.basicUserConnection(context);
          pageViewLogic.callConnectingUsers = false;
        }
        return Feeds(filterSnapShot.data["radius"]);
      },
    );
  }
}

class Feeds extends StatelessWidget {
  final int filterSnapShotRadius;
  Feeds(this.filterSnapShotRadius);
  @override
  Widget build(BuildContext context) {
    final pageViewLogic = Provider.of<PageViewLogic>(context);
    return FutureBuilder(
      // ? 2 -> hold future to update scroll items
      future: pageViewLogic.holdFuture == true
          ? Future.delayed(Duration(seconds: 2))
          : Future.delayed(Duration(seconds: 1)),
      builder: (context2, pauseSnapShot) {
        if (pauseSnapShot.connectionState == ConnectionState.waiting &&
            pageViewLogic.holdFuture == true) {
          pageViewLogic.holdFuture = false;
          return loadFeeds();
        }
        if (pauseSnapShot.connectionState == ConnectionState.waiting &&
            pageViewLogic.holdFuture == false &&
            pageViewLogic.screenMotion == true) {
          // print("spinner 2");
          pageViewLogic.screenMotion = false; // turn off
          return loadFeeds();
        }

        if (pauseSnapShot.hasError) {
          print("Error in loading scroll items");
          return loadFeeds();
        }
        return ValueListenableBuilder(
            valueListenable: pageViewLogic.holdExexution,
            builder: (_, value, child) {
              if (value) {
                print("spinner 3");
                return loadFeeds();
              }
              return scrollUserDetails.isEmpty // ? 3
                  ? nothingToExplore(filterSnapShotRadius, context) // ? 4
                  : PageView.builder(
                      // ? 5
                      key: PageStorageKey(
                          "scroll-feeds-${pageViewLogic.pageStorageKeyNo}"),
                      
                      physics: PageScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      dragStartBehavior:
                          DragStartBehavior.down, // drage behavior
                      onPageChanged: (index) {
                        if (newRadius == 180 &&
                            ConnectingUsers.latestUid.isNotEmpty) {
                          // ? fetch data only if uid is not empty
                          if (scrollUserDetails.length == index + 1) {
                            // whole country
                            pageViewLogic.screenMotion =
                                true; // turn on rebuild
                            ConnectingUsers.paginateBasicUserConnection(
                                context);
                            pageViewLogic.updateIncrement();
                          }
                        } else if (newRadius != 180 &&
                            CustomRadiusGeoHash.latestUid.isNotEmpty) {
                          // custom radius -> geohash
                          // ? fetch data only if uid is not empty
                          if (scrollUserDetails.length == index + 1) {
                            pageViewLogic.screenMotion =
                                true; // turn on rebuild
                            ConnectingUsers.paginateBasicUserConnection(
                                context);
                            pageViewLogic.updateIncrement();
                          }
                        }
                      },
                      itemBuilder: (context, index) {
                        print(
                            "index : ${index + 1} len : ${scrollUserDetails.length}"); // todo : remove these before deployment
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
            });
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
              child: LowerBox(index)),
        ),
      ],
    ),
  );
}

class LowerBox extends StatelessWidget {
  final int index;
  LowerBox(this.index);
  final double heartIconSize = 50;
  final double reportIconSize = 65;
  final double starIconSize = 40;
  @override
  Widget build(BuildContext context) {
    final pageViewLogic = Provider.of<PageViewLogic>(context);
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
                child: scrollUserDetails[index]["heart"] &&
                        scrollUserDetails[index]["lock_heart_star"]
                    ? Hearts.heartanimation(50)
                    : Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.red,
                        size: heartIconSize,
                      ),
                onTap: () async {
                  print("Pressed heart : $index");
                  await Hearts.storeHeartInfo(index: index, context: context);
                  pageViewLogic.updateLowerBoxUi();
                },
              ),
            ),
            Container(
              // ? star icon
              margin: const EdgeInsets.only(left: 40, bottom: 3),
              child: GestureDetector(
                child: scrollUserDetails[index]["star"] &&
                        scrollUserDetails[index]["lock_heart_star"]
                    ? Stars.starAnimation()
                    : Icon(
                        // Icons.star_border_outlined,
                        StarRoundedIcon.star,
                        color: Color(0xffF8C80D),
                        size: starIconSize,
                      ),
                onTap: () async {
                  print("Pressed star : $index");
                  await Stars.storeStarInfo(index: index, context: context);
                  pageViewLogic.updateLowerBoxUi();
                },
              ),
            ),
            Container(
              // ? report icon
              margin: const EdgeInsets.only(left: 30, top: 5),
              child: GestureDetector(
                child: Icon(
                  ReportFilterIcons.report_100_px_new,
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

Widget nothingToExplore(int streamRadius, BuildContext context) {
  // ? when no feeds to show
  final pageViewLogic = Provider.of<PageViewLogic>(context, listen: false);
  return FutureBuilder(
      future: Future.delayed(Duration(seconds: 1)),
      builder: (context, nothingToExploreSnapShot) {
        if (nothingToExploreSnapShot.connectionState ==
            ConnectionState.waiting) {
          return loadFeeds();
        }
        return Container(
          margin: const EdgeInsets.only(top:100),
          child: Center(
            child: Column(
              children: [
                Container(
                    // ? animation
                    child: Lottie.asset(
                      "assets/animations/nothing_to_explore.json",
                      fit: BoxFit.cover,
                      height: 70,
                      width: 70,
                      repeat: false,
                    )),
                Container(
                  // ? text message
                  margin: const EdgeInsets.all(25),
                  child: const Text(
                    "You've explored nearby people.\n Try again or change your filter.",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  // ? refresh
                  width: 160,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: RaisedButton(
                    color: Color(0xffF8C80D),
                    textColor: Color(0xff121212),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Color(0xffF8C80D))),
                    child: const Text(
                      "Try again",
                      style: const TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      scrollUserDetails.clear(); // reset scroll details
                      Notifications.resetLatestDocs(); // reset notifications doc
                      pageViewLogic.callConnectingUsers = true;
                      if (scrollUserDetails.isEmpty &&
                          streamRadius == 180 &&
                          pageViewLogic.callConnectingUsers) {
                        print(
                            "WC : Feeds are empty loading feeds -> nothing to explore widget");
                        ConnectingUsers.basicUserConnection(context);
                        pageViewLogic.callConnectingUsers = false;
                      }
                      if (scrollUserDetails.isEmpty &&
                          streamRadius != 180 &&
                          pageViewLogic.callConnectingUsers) {
                        print(
                            "CR : Feeds are empty loading feeds within $streamRadius -> nothing to explore widget");
                        ConnectingUsers.basicUserConnection(context);
                        pageViewLogic.callConnectingUsers = false;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
