// @dart=2.9
// todo : match nearby users with geohash

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/data/temp/filter_datas.dart' show newRadius;
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/providers/pageview_logic.dart';
import 'package:explore/server/notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomRadiusGeoHash {
  // * crgh - Custom Radius Geo Hash
  // * rh - round homo
  static int crghLimit = 10;
  static int paginateCRGHLimit = 4;
  static int latestAge;
  static String latestUid;
  static void resetLatestDocs() {
    latestAge = 0;
    latestUid = "";
  }

  static Future<QuerySnapshot> _homoQuery(
      {@required CollectionReference ref,
      @required String hashround,
      @required String roundName, // r1,r2,r3,r4
      @required String ssValueGender,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("geohash_rounds.$roundName", isEqualTo: hashround)
        .where("geohash_rounds.rh", isEqualTo: true)
        .where("gender", isEqualTo: ssValueGender)
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .limit(crghLimit)
        .get();

    return query;
  }

  static Future<QuerySnapshot> _everyOneQuery(
      {@required CollectionReference ref,
      @required String hashround,
      @required String roundName, // r1,r2,r3,r4
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("geohash_rounds.$roundName", isEqualTo: hashround)
        .where("show_me", isEqualTo: "Everyone")
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .limit(crghLimit)
        .get();
    return query;
  }

  static Future<QuerySnapshot> _hetroQuery(
      {@required CollectionReference ref,
      @required String hashround,
      @required String roundName, // r1,r2,r3,r4
      @required String ssValueGender,
      @required String ssValueShowMe,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("geohash_rounds.$roundName", isEqualTo: hashround)
        .where("gender", isEqualTo: ssValueShowMe)
        .where("show_me", isEqualTo: ssValueGender)
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .limit(crghLimit)
        .get();
    return query;
  }

  static Future<QuerySnapshot> _paginateHomoQuery(
      {@required CollectionReference ref,
      @required String hashround,
      @required String roundName, // r1,r2,r3,r4
      @required String ssValueGender,
      @required int latestAge,
      @required String latestUid,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("geohash_rounds.$roundName", isEqualTo: hashround)
        .where("geohash_rounds.rh", isEqualTo: true)
        .where("gender", isEqualTo: ssValueGender)
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .startAfter([latestAge, latestUid])
        .limit(paginateCRGHLimit)
        .get();

    return query;
  }

  static Future<QuerySnapshot> _paginateEveryOneQuery(
      {@required CollectionReference ref,
      @required String hashround,
      @required String roundName, // r1,r2,r3,r4
      @required int latestAge,
      @required String latestUid,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("geohash_rounds.$roundName", isEqualTo: hashround)
        .where("show_me", isEqualTo: "Everyone")
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .startAfter([latestAge, latestUid])
        .limit(paginateCRGHLimit)
        .get();
    return query;
  }

  static Future<QuerySnapshot> _paginateHetroQuery(
      {@required CollectionReference ref,
      @required String hashround,
      @required String roundName, // r1,r2,r3,r4
      @required String ssValueGender,
      @required String ssValueShowMe,
      @required int latestAge,
      @required String latestUid,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("geohash_rounds.$roundName", isEqualTo: hashround)
        .where("gender", isEqualTo: ssValueShowMe)
        .where("show_me", isEqualTo: ssValueGender)
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .startAfter([latestAge, latestUid])
        .limit(paginateCRGHLimit)
        .get();
    return query;
  }

  static Future<void> _getlatestDocuments(Future<QuerySnapshot> query) async {
    try {
      await query.then((latestDocs) {
        latestAge = latestDocs.docs[latestDocs.docs.length - 1].get("age");
        latestUid = latestDocs.docs[latestDocs.docs.length - 1].get("uid");
      });
    } on RangeError {
      print("No more feeds to scroll in geohash pagination");
      latestAge = 0;
      latestUid = "";
    }
  }

  static Future<void> _execution(
      {@required Future<QuerySnapshot> query,
      @required String ssValueUid,
      @required String nickName,
      @required BuildContext context}) async {
    try {
      final pageViewLogic = Provider.of<PageViewLogic>(context, listen: false);
      Stopwatch stopwatch = Stopwatch();
      // start timer
      stopwatch.start();
      pageViewLogic.holdExecution.value = true;
      await query.then((q) => q.docs.forEach((queryName) =>
          _unZipAndAddToScrollDetails(
              queryDataName: queryName,
              ssValueUid: ssValueUid,
              nickName: nickName)));
      // stop timer
      stopwatch.stop();
      pageViewLogic.holdExecution.value = false;
      print("Time executed to load feeds : ${stopwatch.elapsed.inSeconds}");
    } catch (error) {
      print("Error in execution : ${error.toString()}");
    }
  }

  static void _unZipAndAddToScrollDetails(
      {@required dynamic queryDataName,
      @required String ssValueUid,
      @required String nickName}) async {
    // unzip data and add to scroll
    try {
      await Notifications.queryNotifications(
          limit: CustomRadiusGeoHash.crghLimit,
          paginatelimit: CustomRadiusGeoHash.paginateCRGHLimit);
      if (!Notifications.doNotShowUid.contains(queryDataName.get("uid"))) {
        if (queryDataName.get("uid") != ssValueUid) {
          print(
              "$nickName : ${queryDataName.get("name")} ${queryDataName.get("uid")} age : ${queryDataName.get("age")}");
          // serialize data
          Map<String, dynamic> serializeDetails = {
            "uid": queryDataName.get("uid"),
            "gender": queryDataName.get("gender"),
            "show_me": queryDataName.get("show_me"),
            "age": queryDataName.get("age"),
            "name": queryDataName.get("name"),
            "headphoto": queryDataName.get("photos.current_head_photo"),
            "bodyphoto": queryDataName.get("photos.current_body_photo"),
            "city_state":
                "${queryDataName.get("city")},${queryDataName.get("state")}",
            "heart": false,
            "star": false,
            "lock_heart_star": false,
            "hp_hash": queryDataName
                .get("photos.current_head_photo_hash"), //headphoto hash
            "bp_hash": queryDataName
                .get("photos.current_body_photo_hash"), //bodyphoto hash
          };
          // add map to list
          scrollUserDetails.add(serializeDetails);
          // print("Scroll len : ${scrollUserDetails.length}");
        }
      }
    } catch (error) {
      print(
          "Error in unzipping data -> custom radius -> geohash : ${error.toString()}");
    }
  }

  static Future<void> nearByUsersGeoHash(BuildContext context) async {
    try {
      // String myUid = FirebaseAuth.instance.currentUser.uid;
      print("Fetching nearby users within ${newRadius.round()} km");
      var matchMakingRef = FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen");
      // ? read secure storage data
      readAll().then((ssValues) async {
        int fromAge = int.parse(ssValues["from_age"]); // from age
        int toAge = int.parse(ssValues["to_age"]); // to age
        // String geoHashField = "current_coordinates.geohash".toString(); // field to geohash
        String myGeoHash = ssValues["geohash"].toString();

        if (ssValues["gender"] == ssValues["show_me"]) {
          //  ? homo same gender -> man -> men , woman -> women
          print("HomoSexual Query");
          // ? different radius
          if (newRadius == 5) {
            // ? show very close users
            String geoHashRound1 = myGeoHash.substring(0, 5);
            print("R1 : $geoHashRound1");
            // query
            var queryHomo = _homoQuery(
                ref: matchMakingRef,
                hashround: geoHashRound1,
                roundName: "r1",
                ssValueGender: ssValues["gender"],
                fromAge: fromAge,
                toAge: toAge);
            // queryResults
            _execution(
                query: queryHomo,
                ssValueUid: ssValues["current_uid"],
                nickName: "Homo",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHomo);
          } else if (newRadius.round() <= 20) {
            // ? upto 20 KM
            String geoHashRound2 = myGeoHash.substring(0, 4);
            print("R2 : $geoHashRound2");
            // query
            var queryHomo = _homoQuery(
                ref: matchMakingRef,
                hashround: geoHashRound2,
                roundName: "r2",
                ssValueGender: ssValues["gender"],
                fromAge: fromAge,
                toAge: toAge);
            // queryResults
            _execution(
                query: queryHomo,
                ssValueUid: ssValues["current_uid"],
                nickName: "Homo",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHomo);
          } else if (newRadius.round() <= 122) {
            // ? upto 122 KM
            String geoHashRound3 = myGeoHash.substring(0, 3);
            print("R3 : $geoHashRound3");
            // query
            var queryHomo = _homoQuery(
                ref: matchMakingRef,
                hashround: geoHashRound3,
                roundName: "r3",
                ssValueGender: ssValues["gender"],
                fromAge: fromAge,
                toAge: toAge);
            // queryResults
            _execution(
                query: queryHomo,
                ssValueUid: ssValues["current_uid"],
                nickName: "Homo",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHomo);
          } else if (newRadius.round() <= 167) {
            // ? upto 167 KM

            String geoHashRound4 = myGeoHash.substring(0, 2);
            print("R4 : $geoHashRound4");
            // query
            var queryHomo = _homoQuery(
                ref: matchMakingRef,
                hashround: geoHashRound4,
                roundName: "r4",
                ssValueGender: ssValues["gender"],
                fromAge: fromAge,
                toAge: toAge);
            // queryResults
            _execution(
                query: queryHomo,
                ssValueUid: ssValues["current_uid"],
                nickName: "Homo",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHomo);
          }
        } else if (ssValues["show_me"] == "Everyone") {
          // ? Everyone
          print("Everyone Query");
          // ? different radius
          if (newRadius == 5) {
            // ? show very close users
            String geoHashRound1 = myGeoHash.substring(0, 5);
            print("R1 : $geoHashRound1");
            // query
            var queryEveryOne = _everyOneQuery(
                ref: matchMakingRef,
                hashround: geoHashRound1,
                roundName: "r1",
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryEveryOne,
                ssValueUid: ssValues["current_uid"],
                nickName: "EveryOne",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryEveryOne);
          } else if (newRadius.round() <= 20) {
            // ? upto 20 KM
            String geoHashRound2 = myGeoHash.substring(0, 4);
            print("R2 : $geoHashRound2");
            // query
            var queryEveryOne = _everyOneQuery(
                ref: matchMakingRef,
                hashround: geoHashRound2,
                roundName: "r2",
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryEveryOne,
                ssValueUid: ssValues["current_uid"],
                nickName: "EveryOne",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryEveryOne);
          } else if (newRadius.round() <= 122) {
            // ? upto 122 KM

            String geoHashRound3 = myGeoHash.substring(0, 3);
            print("R3 : $geoHashRound3");
            // query
            var queryEveryOne = _everyOneQuery(
                ref: matchMakingRef,
                hashround: geoHashRound3,
                roundName: "r3",
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryEveryOne,
                ssValueUid: ssValues["current_uid"],
                nickName: "EveryOne",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryEveryOne);
          } else if (newRadius.round() <= 167) {
            // ? upto 167 KM

            String geoHashRound4 = myGeoHash.substring(0, 2);
            print("R4 : $geoHashRound4");
            // query
            var queryEveryOne = _everyOneQuery(
                ref: matchMakingRef,
                hashround: geoHashRound4,
                roundName: "r4",
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryEveryOne,
                ssValueUid: ssValues["current_uid"],
                nickName: "EveryOne",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryEveryOne);
          }
        } else if ((ssValues["gender"] != ssValues["show_me"])) {
          // ? HetroSexual -> Man -> Woman , Woman -> Men
          print("HetroSexual Query");
          // ? different radius
          if (newRadius == 5) {
            // ? show very close users
            String geoHashRound1 = myGeoHash.substring(0, 5);
            print("R1 : $geoHashRound1");
            // query
            var queryHetro = _hetroQuery(
                ref: matchMakingRef,
                hashround: geoHashRound1,
                roundName: "r1",
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryHetro,
                ssValueUid: ssValues["current_uid"],
                nickName: "Hetro",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHetro);
          } else if (newRadius.round() <= 20) {
            // ? upto 20 KM
            String geoHashRound2 = myGeoHash.substring(0, 4);
            print("R2 : $geoHashRound2");
            // query
            var queryHetro = _hetroQuery(
                ref: matchMakingRef,
                hashround: geoHashRound2,
                roundName: "r2",
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryHetro,
                ssValueUid: ssValues["current_uid"],
                nickName: "Hetro",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHetro);
          } else if (newRadius.round() <= 122) {
            // ? upto 122 KM
            String geoHashRound3 = myGeoHash.substring(0, 3);
            print("R3 : $geoHashRound3");
            // query
            var queryHetro = _hetroQuery(
                ref: matchMakingRef,
                hashround: geoHashRound3,
                roundName: "r3",
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryHetro,
                ssValueUid: ssValues["current_uid"],
                nickName: "Hetro",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHetro);
          } else if (newRadius.round() <= 167) {
            // ? upto 167 KM
            String geoHashRound4 = myGeoHash.substring(0, 2);
            print("R4 : $geoHashRound4");
            // query
            var queryHetro = _hetroQuery(
                ref: matchMakingRef,
                hashround: geoHashRound4,
                roundName: "r4",
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryHetro,
                ssValueUid: ssValues["current_uid"],
                nickName: "Hetro",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHetro);
          }
        }
      });
    } catch (error) {
      print("Error in custom radius -> geohash ${error.toString()}");
    }
  }

  static Future<void> paginateNearByUsersGeoHash(BuildContext context) async {
    try {
      // String myUid = FirebaseAuth.instance.currentUser.uid;
      print(
          "Fetching nearby users within ${newRadius.round()} km -> pagination -> geohash");
      print("Latest documents $latestUid $latestAge");
      var matchMakingRef = FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen");
      // ? read secure storage data
      readAll().then((ssValues) async {
        int fromAge = int.parse(ssValues["from_age"]); // from age
        int toAge = int.parse(ssValues["to_age"]); // to age
        String myGeoHash = ssValues["geohash"].toString();

        if (ssValues["gender"] == ssValues["show_me"]) {
          //  ? homo same gender -> man -> men , woman -> women
          // print("HomoSexual Query");
          // ? different radius
          if (newRadius == 5) {
            // ? show very close users
            String geoHashRound1 = myGeoHash.substring(0, 5);
            print("R1 : $geoHashRound1");
            // query
            var queryHomo = _paginateHomoQuery(
                ref: matchMakingRef,
                hashround: geoHashRound1,
                roundName: "r1",
                ssValueGender: ssValues["gender"],
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // queryResults
            _execution(
                query: queryHomo,
                ssValueUid: ssValues["current_uid"],
                nickName: "Homo",
                context: context);
            // ? latest documents

            await _getlatestDocuments(queryHomo);
          } else if (newRadius.round() <= 20) {
            // ? upto 20 KM
            String geoHashRound2 = myGeoHash.substring(0, 4);
            print("R2 : $geoHashRound2");
            // query
            var queryHomo = _paginateHomoQuery(
                ref: matchMakingRef,
                hashround: geoHashRound2,
                roundName: "r2",
                ssValueGender: ssValues["gender"],
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // queryResults
            _execution(
                query: queryHomo,
                ssValueUid: ssValues["current_uid"],
                nickName: "Homo",
                context: context);
            // ? latest documents try and expect
            await _getlatestDocuments(queryHomo);
          } else if (newRadius.round() <= 122) {
            // ? upto 122 KM
            String geoHashRound3 = myGeoHash.substring(0, 3);
            print("R3 : $geoHashRound3");
            // query
            var queryHomo = _paginateHomoQuery(
                ref: matchMakingRef,
                hashround: geoHashRound3,
                roundName: "r3",
                ssValueGender: ssValues["gender"],
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // queryResults
            _execution(
                query: queryHomo,
                ssValueUid: ssValues["current_uid"],
                nickName: "Homo",
                context: context);
            // ? latest documents try and expect

            await _getlatestDocuments(queryHomo);
          } else if (newRadius.round() <= 167) {
            // ? upto 167 KM

            String geoHashRound4 = myGeoHash.substring(0, 2);
            print("R4 : $geoHashRound4");
            // query
            var queryHomo = _paginateHomoQuery(
                ref: matchMakingRef,
                hashround: geoHashRound4,
                roundName: "r4",
                ssValueGender: ssValues["gender"],
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // queryResults
            _execution(
                query: queryHomo,
                ssValueUid: ssValues["current_uid"],
                nickName: "Homo",
                context: context);
            // ? latest documents try and expect

            await _getlatestDocuments(queryHomo);
          }
        } else if (ssValues["show_me"] == "Everyone") {
          // ? Everyone
          // print("Everyone Query");
          // ? different radius
          if (newRadius == 5) {
            // ? show very close users
            String geoHashRound1 = myGeoHash.substring(0, 5);
            print("R1 : $geoHashRound1");
            // query
            var queryEveryOne = _paginateEveryOneQuery(
                ref: matchMakingRef,
                hashround: geoHashRound1,
                roundName: "r1",
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryEveryOne,
                ssValueUid: ssValues["current_uid"],
                nickName: "EveryOne",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryEveryOne);
          } else if (newRadius.round() <= 20) {
            // ? upto 20 KM
            String geoHashRound2 = myGeoHash.substring(0, 4);
            print("R2 : $geoHashRound2");
            // query
            var queryEveryOne = _paginateEveryOneQuery(
                ref: matchMakingRef,
                hashround: geoHashRound2,
                roundName: "r2",
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryEveryOne,
                ssValueUid: ssValues["current_uid"],
                nickName: "EveryOne",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryEveryOne);
          } else if (newRadius.round() <= 122) {
            // ? upto 122 KM

            String geoHashRound3 = myGeoHash.substring(0, 3);
            print("R3 : $geoHashRound3");
            // query
            var queryEveryOne = _paginateEveryOneQuery(
                ref: matchMakingRef,
                hashround: geoHashRound3,
                roundName: "r3",
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryEveryOne,
                ssValueUid: ssValues["current_uid"],
                nickName: "EveryOne",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryEveryOne);
          } else if (newRadius.round() <= 167) {
            // ? upto 167 KM
            String geoHashRound4 = myGeoHash.substring(0, 2);
            print("R4 : $geoHashRound4");
            // query
            var queryEveryOne = _paginateEveryOneQuery(
                ref: matchMakingRef,
                hashround: geoHashRound4,
                roundName: "r4",
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryEveryOne,
                ssValueUid: ssValues["current_uid"],
                nickName: "EveryOne",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryEveryOne);
          }
        } else if ((ssValues["gender"] != ssValues["show_me"])) {
          // ? HetroSexual -> Man -> Woman , Woman -> Men
          // print("HetroSexual Query");
          // ? different radius
          if (newRadius == 5) {
            // ? show very close users
            String geoHashRound1 = myGeoHash.substring(0, 5);
            print("R1 : $geoHashRound1");
            // query
            var queryHetro = _paginateHetroQuery(
                ref: matchMakingRef,
                hashround: geoHashRound1,
                roundName: "r1",
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryHetro,
                ssValueUid: ssValues["current_uid"],
                nickName: "Hetro",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHetro);
          } else if (newRadius.round() <= 20) {
            // ? upto 20 KM
            String geoHashRound2 = myGeoHash.substring(0, 4);
            print("R2 : $geoHashRound2");
            // query
            var queryHetro = _paginateHetroQuery(
                ref: matchMakingRef,
                hashround: geoHashRound2,
                roundName: "r2",
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryHetro,
                ssValueUid: ssValues["current_uid"],
                nickName: "Hetro",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHetro);
          } else if (newRadius.round() <= 122) {
            // ? upto 122 KM
            String geoHashRound3 = myGeoHash.substring(0, 3);
            print("R3 : $geoHashRound3");
            // query
            var queryHetro = _paginateHetroQuery(
                ref: matchMakingRef,
                hashround: geoHashRound3,
                roundName: "r3",
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryHetro,
                ssValueUid: ssValues["current_uid"],
                nickName: "Hetro",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHetro);
          } else if (newRadius.round() <= 167) {
            // ? upto 167 KM
            String geoHashRound4 = myGeoHash.substring(0, 2);
            print("R4 : $geoHashRound4");
            // query
            var queryHetro = _paginateHetroQuery(
                ref: matchMakingRef,
                hashround: geoHashRound4,
                roundName: "r4",
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query result
            _execution(
                query: queryHetro,
                ssValueUid: ssValues["current_uid"],
                nickName: "Hetro",
                context: context);
            // ? latest documents
            await _getlatestDocuments(queryHetro);
          }
        }
      });
    } catch (error) {
      print("Error in Paginating custom radius -> geohash ${error.toString()}");
    }
  }
}
