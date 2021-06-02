// @dart=2.9
// todo : Feeds of dating
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/temp/filter_datas.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/icons/report_filter_icons_icons.dart';
import 'package:explore/icons/star_rounded_icon_icons.dart';
import 'package:explore/models/all_enums.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/providers/pageview_logic.dart';
import 'package:explore/screens/profile/other_user_pres_screen.dart';
import 'package:explore/screens/report/report_screen.dart';
import 'package:explore/server/match_backend/connecting_users.dart';
import 'package:explore/server/match_backend/geohash_custom_radius.dart';
import 'package:explore/server/star_report_backend/stars.dart';
import 'package:explore/widgets/report/report_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// ? : topBox -> head photo ,name,age,location
// ? : middleBox -> body photo
//  ? lowerBox -> heart , star , report

class ExploreScreen extends StatelessWidget {
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
            valueListenable: pageViewLogic.holdExecution,
            builder: (_, value, child) {
              if (value) {
                print("spinner 3");
                return loadFeeds();
              }
              return scrollUserDetails.isEmpty // ? 3
                  ? _NothingToExploreScreen(filterSnapShotRadius) // ? 4
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
                              _TopBox(index),
                              Expanded(child: _MiddleBox(index)),
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

class _TopBox extends StatelessWidget {
  final int index;
  _TopBox(this.index);
  @override
  Widget build(BuildContext context) {
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
            child: GestureDetector(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xff121212),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: scrollUserDetails[index]["headphoto"].toString(),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => BlurHash(
                      hash: scrollUserDetails[index]["hp_hash"],
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
              onTap: () => Navigator.pushNamed(
                  context, OtherUserPrespectiveScreen.routeName,
                  arguments: {
                    "uid": scrollUserDetails[index]["uid"],
                    "preview_type": PreviewType.feeds,
                    "index": index
                  }),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700),
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
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiddleBox extends StatelessWidget {
  final int index;
  _MiddleBox(this.index);
  @override
  Widget build(BuildContext context) {
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
                  placeholder: (context, url) => BlurHash(
                    hash: scrollUserDetails[index]["bp_hash"],
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
              onTap: () => Navigator.pushNamed(
                  context, OtherUserPrespectiveScreen.routeName,
                  arguments: {
                    "uid": scrollUserDetails[index]["uid"],
                    "preview_type": PreviewType.feeds,
                    "index": index
                  }),
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
}

class LowerBox extends StatelessWidget {
  final int index;
  final PreviewType previewType;
  LowerBox(this.index, {this.previewType});
  final double heartIconSize = 50;
  final double reportIconSize = 65;
  final double starIconSize = 40;
  @override
  Widget build(BuildContext context) {
    return Container(
      // ? heart , star , report widgets
      child: Container(
        // ? control black box
        width: 150,
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
            Consumer<PageViewLogic>(
              builder: (_, pageViewLogic, __) => Container(
                // ? star icon
                margin: const EdgeInsets.only(left: 20, bottom: 3),
                child: GestureDetector(
                  child: scrollUserDetails[index]["star"]
                      ? Stars.starAnimation()
                      : Icon(
                          // Icons.star_border_outlined,
                          StarRoundedIcon.star,
                          color: Color(0xffF8C80D),
                          size: starIconSize,
                        ),
                  onTap: () {
                    // print("Pressed star idx of : $index");
                    Stars.storeStarInfo(
                        index: index,
                        previewType: previewType,
                        context: context);
                    pageViewLogic.updateLowerBoxUi();
                  },
                ),
              ),
            ),
            Container(
              // ? report icon
              margin: const EdgeInsets.only(left: 13, top: 3.8),
              child: GestureDetector(
                child: Icon(
                  ReportFilterIcons.report_100_px_new,
                  color: Colors.white54,
                  size: reportIconSize,
                ),
                onTap: () {
                  print("Pressed report $index");
                  if (scrollUserDetails[index]["lock_report"]) {
                    cannotReportHereFlushBar(context);
                  } else {
                    reportBottomSheet(scrollUserDetails[index]["name"],
                        scrollUserDetails[index]["uid"], context,
                        index: index,previewType: previewType);
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
          imageUrl: url,
          placeholder: (context, url) => Center(child: loadingSpinner()),
          errorWidget: (context, url, error) => Center(child: loadingSpinner()),
          // fit: BoxFit.cover,
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}

class _NothingToExploreScreen extends StatelessWidget {
  final int streamRadius;
  _NothingToExploreScreen(this.streamRadius);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 1)),
      builder: (context, nothingToExploreSnapShot) {
        if (nothingToExploreSnapShot.connectionState ==
            ConnectionState.waiting) {
          return loadFeeds();
        }
        return Container(
          margin: const EdgeInsets.only(top: 100),
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
                  margin: const EdgeInsets.all(20),
                  child: const Text(
                    "You've explored nearby people.\n Try again or change your filter or comeback later.",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  // ? refresh
                  width: 160,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  // ignore: deprecated_member_use
                  child: Consumer<PageViewLogic>(
                    // ignore: deprecated_member_use
                    builder: (context, pageViewLogic, child) => RaisedButton(
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
                        pageViewLogic.callConnectingUsers = true;
                        if (scrollUserDetails.isEmpty &&
                            streamRadius == 180 &&
                            pageViewLogic.callConnectingUsers) {
                          print(
                              "WC : Feeds are empty loading feeds -> nothing to explore widget");
                          ConnectingUsers.basicUserConnection(context);
                          pageViewLogic.callConnectingUsers = false;
                          pageViewLogic.holdFuture = true;
                          pageViewLogic.increment++;
                        }
                        if (scrollUserDetails.isEmpty &&
                            streamRadius != 180 &&
                            pageViewLogic.callConnectingUsers) {
                          print(
                              "CR : Feeds are empty loading feeds within $streamRadius -> nothing to explore widget");
                          ConnectingUsers.basicUserConnection(context);
                          pageViewLogic.callConnectingUsers = false;
                          pageViewLogic.holdFuture = true;
                          pageViewLogic.increment++;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
