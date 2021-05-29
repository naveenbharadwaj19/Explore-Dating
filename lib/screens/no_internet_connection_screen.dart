// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget noInternetConnection(String animationName2, BuildContext context) {
  return Material(
    color: Theme.of(context).primaryColor,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/animations/no_wifi.json",
            fit: BoxFit.cover,
            height: 200,
            width: 200,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            "No internet connectivity.Please check for internet connection",
            maxLines: 2,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          )
        ],
      ),
    ),
  );
}
