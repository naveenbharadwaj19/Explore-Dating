import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingSpinner(){
  // * Cubegrid - default loading spinner
  return SpinKitCubeGrid(
    color: Colors.white,
    size: 40,
    );
}


Widget whileHeadImageloadingSpinner(){
  return SpinKitCubeGrid(
    color: Colors.white,
    size: 25,
    );
}