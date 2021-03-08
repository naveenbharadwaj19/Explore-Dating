import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget noInternetConnection(String animationName2) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: 200,
          child: FlareActor(
            "assets/animations/no_wifi.flr",
            fit: BoxFit.cover,
            animation: animationName2,
          ),
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
