// Todo : Monitor secure storage filters datas and temp filters data

import 'package:explore/data/all_secure_storage.dart';
import 'package:flutter/material.dart';

double radius = 200;
RangeValues ageValues1 = RangeValues(18.0, 25.0);
String currentShowMe = "Everyone";

fetchFiltersData() {
  // * call all filters data :
  try {
    fetchRadius();
    fetchUserPreferredAge();
    fetchShowMe();
  } catch (error) {
    print("Error in fetching filters data : ${error.toString()}");
  }
}

fetchRadius(){
  try {
    readValue("radius").then((v) {
      radius = double.parse(v);
    });
  } catch (error) {
    print("Error in fetchradius : ${error.toString()}");
  }
}

fetchUserPreferredAge(){
  try {
    readAll().then((v) {
      ageValues1 =
          RangeValues(double.parse(v["from_age"]), double.parse(v["to_age"]));
    });
  } catch (error) {
    print("Error in fetchuserpreferredage : ${error.toString()}");
  }
}

fetchShowMe(){
  try {
    readValue("show_me").then((v) {
      currentShowMe = v;
    });
  } catch (error) {
    print("Error in fetchshowme : ${error.toString()}");
  }
}
