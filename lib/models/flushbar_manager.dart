// @dart=2.9
// Todo mangage all flushbar

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Widget flushBar(
    {@required String text,
    @required Color bgColor,
    @required double fontSize,
    @required BuildContext context,
    FontWeight fontWeight = FontWeight.w600,
    Color textColor = Colors.white,
    int seconds = 3}) {
  return Flushbar(
    messageText: Text(
      text,
      style: TextStyle(
          color: textColor, fontSize: fontSize, fontWeight: fontWeight),
    ),
    backgroundColor: bgColor,
    duration: Duration(seconds: seconds),
  )..show(context);
}

Widget flushBarCenterWithButton(
    {@required String text,
    @required Color bgColor,
    @required double fontSize,
    @required BuildContext context,
    FontWeight fontWeight = FontWeight.w600,
    Color textColor = Colors.white,
    int seconds = 3}) {
  return Flushbar(
    messageText: Center(
      child: Text(
        text,
        style: TextStyle(
            color: textColor, fontSize: fontSize, fontWeight: fontWeight),
      ),
    ),
    backgroundColor: bgColor,
    duration: Duration(seconds: seconds),
    mainButton: IconButton(
      icon: const Icon(Icons.help_rounded),
      color: Colors.white,
      tooltip: "help",
      onPressed: () {
        // * navigate to the website why we don't accept
      },
    ),
  )..show(context);
}
