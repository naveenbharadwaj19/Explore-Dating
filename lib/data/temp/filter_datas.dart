
// Todo : Monitor secure storage filters datas and temp filters data


import 'package:explore/data/all_secure_storage.dart';
import 'package:flutter/material.dart';

double radius;
RangeValues ageValues1;
String currentShowMe;

fetchFiltersData(){
  // * call all filters data :
  try{
  fetchRadius();
  fetchUserPreferredAge();
  fetchShowMe();
  } catch(error){
    print("Error in fetching filters data ${error.toString()}");
  }

}

 void fetchRadius(){
  readValue("radius").then((v){
    radius = double.parse(v);
  });
}


void fetchUserPreferredAge(){
  readAll().then((v){
    ageValues1 = RangeValues(double.parse(v["from_age"]),double.parse(v["to_age"]));
  });
}

void fetchShowMe(){
  readValue("show_me").then((v){
    currentShowMe = v;
  });
}