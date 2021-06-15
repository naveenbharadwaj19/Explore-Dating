// @dart=2.9
import 'package:explore/icons/auth_icons_icons.dart';
import 'package:explore/models/all_urls.dart';
import 'package:explore/models/auth.dart';
import 'package:explore/models/spinner.dart';
import 'package:flutter/material.dart';
import 'dart:math';

Widget logoAppName(Image logoImage) {
  return Row(
    //  logo and text
    children: [
      Container(
        child: logoImage,
      ),
      RichText(
        textAlign: TextAlign.right,
        text: TextSpan(children: [
          const TextSpan(
            text: "Explore\n",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
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
    ],
  );
}

Widget greetText() {
  return Align(
    // ? catch text
    alignment: Alignment(-0.7, 0.0),
    child: Container(
      margin: const EdgeInsets.only(top: 5),
      child: const Text(
        "Hey There,",
        style: const TextStyle(
          fontFamily: "Domine",
          fontSize: 30,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget catchyText() {
  return Container(
    margin: EdgeInsets.only(top: 8),
    child: Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 38, right: 2),
      child: Text(
        _selectedCatchyText,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 22, color: Colors.white),
      ),
    ),
  );
}

Widget googleButton(
    {@required bool isLoadingGoogle,
    @required Function loadingOnGoogle,
    @required Function loadingOffGoogle,
    @required BuildContext context}) {
  return Container(
    margin: const EdgeInsets.only(top: 50),
    height: 50,
    width: 300,
    child: isLoadingGoogle
        ? loadingSpinner()
        // ignore: deprecated_member_use
        : RaisedButton.icon(
            icon: const Icon(
              AuthIcons.google,
              color: Colors.white,
              size: 30,
            ),
            color: Color(0xffAF0D0D),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(
                color: Color(0xffAF0D0D),
              ),
            ),
            label: const Text(
              "Continue with Google",
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () => GoogleAuthentication.signinWithGoogle(
                loadingOnGoogle, loadingOffGoogle, context),
          ),
  );
}

Widget faceBookButton(
    {@required bool isloadingFb,
    @required Function loadingOnFb,
    @required Function loadingOffFb,
    @required BuildContext context}) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    height: 50,
    width: 300,
    // ignore: deprecated_member_use
    child: isloadingFb ? loadingSpinner() : RaisedButton.icon(
      icon: const Icon(
        AuthIcons.facebook_1,
        color: Colors.white,
        size: 30,
      ),
      color: Color(0xff3B5998),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(
          color: Color(0xff3B5998),
        ),
      ),
      label: const Text(
        "Continue with Facebook",
        overflow: TextOverflow.fade,
        maxLines: 1,
        style: TextStyle(fontSize: 18),
      ),
      onPressed: () => FacebookAuthentication.signinFacebook(
          loadingOnFb, loadingOffFb, context),
    ),
  );
}

Widget faceBookInfo() {
  return Container(
    alignment: Alignment.bottomCenter,
    margin: const EdgeInsets.only(bottom: 7),
    child: const Text("We never post on Facebook",
        style: TextStyle(color: Colors.white70, fontSize: 14)),
  );
}

Widget navigateToWebSite() {
  return Container(
    alignment: Alignment.topRight,
    margin: const EdgeInsets.only(top: 20),
    child: IconButton(
      icon: Icon(Icons.language_rounded),
      color: Colors.white,
      iconSize: 27,
      tooltip: "Website",
      onPressed: () {
        // todo navigate to website
      },
    ),
  );
}

Widget bottomButtons() {
  // help,report bug
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          // help
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.only(bottom: 10),
          child: IconButton(
            icon: const Icon(
              Icons.help_outlined,
              size: 25,
              color: Colors.white70,
            ),
            tooltip: "Help",
            onPressed: () => launchFaq(),
          ),
        ),
        Container(
          //  report bug
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.only(bottom: 10),
          child: IconButton(
              splashColor: Colors.red[600],
              icon: const Icon(
                Icons.bug_report_rounded,
                size: 25,
                color: Colors.white70,
              ),
              tooltip: "Report bug",
              onPressed: () => reportBug()),
        ),
      ],
    ),
  );
}

List<String> _catchyText = [
  "Are you ready to explore?",
  "Make your pitch",
  "So many fishes in the sea…",
  "The world is yours to explore",
  "It’s a big world out there with lots of people, go explore",
  "Stop explaining, start exploring"
];

final _random = Random();

String _selectedCatchyText = _catchyText[_random.nextInt(_catchyText.length)];
