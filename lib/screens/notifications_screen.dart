// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/providers/notifications_state.dart';
import 'package:explore/serverless/notifications.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
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
      body: FutureBuilder(
        future: Notifications.showNotifications(),
        builder: (context, notificationSnapShot) {
          if (notificationSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: loadingSpinner());
          }
          if (notificationSnapShot.hasError) {
            print("Error in notification future builder");
            return Center(child: loadingSpinner());
          }
          return NotificationsFeeds(notificationSnapShot.data);
        },
      ),
    );
  }
}

class NotificationsFeeds extends StatelessWidget {
  final dynamic data;
  NotificationsFeeds(this.data);
  final acceptColor = Color(0xff121212); //Color(0xff1e8d3e) -> green
  final rejectColor = Color(0xff121212); // Color(0xffd83025) -> red
  @override
  Widget build(BuildContext context) {
    final notificationState = Provider.of<NotificationsState>(context);
    return data.isEmpty
        ? noNotifications() // when user has no notifications
        : ListView.builder(
            itemBuilder: (context, index) {
              return AbsorbPointer(
                absorbing: notificationState.lockSwipe ? true : false,
                child: Dismissible(
                  key: UniqueKey(), // ValueKey("notification-feeds")
                  background: Container(
                    // ? left to right -> not intersted
                    alignment: Alignment.centerLeft,
                    color: rejectColor,
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: const Icon(
                        Icons.cancel,
                        size: 40,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    // ? right to left -> intersted
                    alignment: Alignment.centerRight,
                    color: acceptColor,
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: const Icon(
                        Icons.check_circle,
                        size: 40,
                        color: Color(0xffF8C80D),
                      ),
                    ),
                  ),
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 15, right: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xCCF8C80D), width: 2), // 80 %
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            // ? head photo,name,age,acceptReject
                            _headPhoto(data: data, index: index),
                            _name(data: data, index: index),
                            age(data: data, index: index),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    // ? end to start -> right to left
                    // ? start to end -> left to right
                    if (direction == DismissDirection.endToStart) {
                      Notifications.notificationAccepted(
                          data: data, index: index);
                      notificationState.enableLockSwipe(
                          data: data, index: index);
                      popUpMessage(notificationState, context);
                    } else if (direction == DismissDirection.startToEnd) {
                      Notifications.notificationRejected(
                          data: data, index: index);
                      notificationState.enableLockSwipe(
                          data: data, index: index);
                      popUpMessage(notificationState, context);
                    }
                  },
                ),
              );
            },
            itemCount: data.length,
          );
  }
}

Widget _headPhoto({@required dynamic data, @required int index}) {
  return Container(
    // ? head photo
    margin: const EdgeInsets.only(left: 10),
    child: GestureDetector(
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Color(0xff121212),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: data[index]["head_photo"].toString(),
            fit: BoxFit.cover,
            placeholder: (context, url) => BlurHash(
              hash: data[index]["head_photo_hash"].toString(),
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
      onTap: () {
        // ? show user profile
        print("Clicked $index");
      },
    ),
  );
}

Widget _name({@required dynamic data, @required int index}) {
  return Container(
    // ? name
    margin: const EdgeInsets.only(left: 20),
    child: Text(
      "${data[index]["name"]},",
      style: TextStyle(color: Colors.white, fontSize: 20),
      maxLines: 1,
    ),
  );
}

Widget age({@required dynamic data, @required int index}) {
  return Container(
    // ? name
    margin: const EdgeInsets.only(left: 2),
    child: Text(
      "${data[index]["age"]}",
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}

Widget noNotifications() {
  return Container(
    child: Center(
      child: Text(
        "No hearts!!!",
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
    ),
  );
}

Widget popUpMessage(
    NotificationsState notificationState, BuildContext context) {
  // * lock swipe for 1 second to reduce traffic and latency
  return Flushbar(
    backgroundColor: Color(0xff121212),
    messageText: Center(
      child: Text(
        "Wait for a second",
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ),
    icon: Container(
      margin: const EdgeInsets.only(left: 15),
      child: CircularCountDownTimer(
        // ? countdown timer
        width: 40,
        height: 40,
        duration: 1,
        fillColor: Color(0xffF8C80D),
        ringColor: Color(0xff121212),
        backgroundColor: Color(0xff121212),
        strokeWidth: 2,
        textStyle: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        onComplete: () => notificationState.disableLockSwipe(),
      ),
    ),
    duration: Duration(seconds: 1),
  )..show(context);
}
