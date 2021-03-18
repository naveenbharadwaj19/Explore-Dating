// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget noInternetConnection(String animationName2) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: 200,
          child: Lottie.asset("assets/animations/no_wifi.json",fit: BoxFit.cover,),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Text(
          "No internet connectivity.Please check for internet connection",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18,decoration: TextDecoration.none),
        )
      ],
    ),
  );
}
