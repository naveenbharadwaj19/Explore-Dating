// @dart=2.9
// todo get started screen

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class GetStartedScreen extends StatelessWidget {
  final List<Map> overView = [
    {
      "svg_": SvgPicture.asset(
        "assets/svg/waving_hand.svg",
        fit: BoxFit.cover,
        height: 100,
        width: 80,
      ),
      "content":
          "Bid adieu to the endless swiping and the endless waiting – with an easy scroll-through of the dating pool and an instant connection feature, Explore Dating is determined to bring to you the ultimate dating experience."
    },
    {
      "svg_": SvgPicture.asset(
        "assets/svg/scroll.svg",
        fit: BoxFit.cover,
        height: 70,
        width: 70,
      ),
      "content":
          """You can simply scroll down a list of profiles that meet your preferences and 'Star' the profiles you’re interested in and they get notified instantly. You can make the first move via message. The other person has 12 hours to respond. Yes, that's right. No more waiting around for days to get the green signal!

And this applies to you as well. You'll get notified when someone Stars and messages you, and you have the same 12 hours to make up your mind!
"""
    },
    {
      "svg_": SvgPicture.asset(
        "assets/svg/rules_card.svg",
        fit: BoxFit.cover,
        height: 80,
        width: 70,
      ),
      "content":
          """Once you've Starred someone it cannot be undone.The messages shall automatically disappear if the person doesn't respond in 12 hours.

Please be polite and respectful towards other and follow community guidelines. We value the privacy and safety of our users and strive towards building a positive environment to offer you a seamless dating experience.
"""
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: overView.length,
      loop: false,
      physics: PageScrollPhysics(),
      pagination: SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          color: Colors.white70,
          activeColor: Theme.of(context).buttonColor,
        ),
      ),
      itemBuilder: (context, index) {
        return Material(
          color: Theme.of(context).primaryColor,
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: [
                  Container(
                    // svgs
                    margin: const EdgeInsets.only(top: 80),
                    child: overView[index]["svg_"],
                  ),
                  Container(
                    // content
                    margin: EdgeInsets.only(
                        top: index == 0 ? 130 : 60, left: 25, right: 15),
                    child: Text(
                      overView[index]["content"],
                      maxLines: 17,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Spacer(),
                  index != 2
                      ? Container()
                      : Container(
                          // continue button
                          width: 180,
                          margin: const EdgeInsets.only(bottom: 25),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            color: Theme.of(context).buttonColor,
                            textColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    color: Theme.of(context).buttonColor)),
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () => _updateGetStarted(),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void _updateGetStarted() {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference userData = FirebaseFirestore.instance.doc("Users/$uid");
    userData.update({"access_check.get_started": true});
  } catch (error) {
    print("Error in updating getstarted field");
  }
}
