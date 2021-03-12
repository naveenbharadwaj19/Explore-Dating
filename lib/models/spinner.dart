import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

Widget loadingSpinner() {
  // * Cubegrid - default loading spinner
  return const SpinKitCubeGrid(
    color: Colors.white,
    size: 40,
  );
}

Widget whileHeadImageloadingSpinner() {
  return const SpinKitCubeGrid(
    color: Colors.white,
    size: 25,
  );
}

Widget infinitySpinner() {
  return Lottie.asset("assets/animations/infinity.json");
}

Widget loadFeeds() {
  // ? loading feeds
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: Column(
      children: [
        Stack(
          // ? yellow border and head photo
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xCCF8C80D),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30),
                  topRight: const Radius.circular(30),
                ),
              ),
            ),
            Container(
              // ? head photo
              margin: const EdgeInsets.only(top: 10, left: 15),
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xff121212),
                child: ClipOval(
                  child: whileHeadImageloadingSpinner(),
                ),
              ),
            ),
          ],
        ),
        Container(
          // ? middle box and lower box
          margin: const EdgeInsets.only(top: 150),
          child: loadingSpinner(),
        ),
      ],
    ),
  );
}
