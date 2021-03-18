// @dart=2.9
// Todo : Monitor secure storage filters datas and temp filters data

import 'package:explore/data/all_secure_storage.dart';
import 'package:flutter/material.dart';

double newRadius = 180;
RangeValues newAgeValues1 = RangeValues(18.0, 25.0);
String newCurrentShowMe = "Everyone";


Future fetchFiltersData() async {
  // * call all filters data :
  try {
    await fetchRadius();
    await fetchUserPreferredAge();
    await fetchShowMe();
  } catch (error) {
    print("Error in fetching filters data : ${error.toString()}");
  }
}

fetchRadius() {
  try {
    readValue("radius").then((v) {
      newRadius = double.parse(v);
    });
  } catch (error) {
    print("Error in fetchradius : ${error.toString()}");
  }
}

fetchUserPreferredAge() {
  try {
    readAll().then((v) {
      newAgeValues1 =
          RangeValues(double.parse(v["from_age"]), double.parse(v["to_age"]));
    });
  } catch (error) {
    print("Error in fetchuserpreferredage : ${error.toString()}");
  }
}

fetchShowMe() {
  try {
    readValue("show_me").then((v) {
      newCurrentShowMe = v;
    });
  } catch (error) {
    print("Error in fetchshowme : ${error.toString()}");
  }
}

