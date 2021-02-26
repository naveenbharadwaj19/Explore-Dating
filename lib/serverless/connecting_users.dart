// todo : Algorithm for getting matched user id
// ! entry point for connecting users (simplematch)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/data/temp/filter_datas.dart' show newRadius;
import 'package:explore/data/temp/store_basic_match.dart'
    show scrollUserDetails;
import 'package:explore/serverless/geohash_custom_radius.dart';
import 'package:flutter/widgets.dart';
import '../serverless/download_photos_storage.dart';

class ConnectingUsers {
  static int firstLimit = 4;
  static int paginateLimit = 4;
  static int latestAge;
  static String latestUid;
  static void resetLatestDocs() {
    latestAge = 0;
    latestUid = "";
  }

  static Future<QuerySnapshot> _homoQuery(
      {@required CollectionReference ref,
      @required String ssValueGender,
      @required String ssValueShowMe,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("gender", isEqualTo: ssValueGender)
        .where("show_me", isEqualTo: ssValueShowMe)
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .limit(firstLimit)
        .get();

    return query;
  }

  static Future<QuerySnapshot> _everyOneQuery(
      {@required CollectionReference ref,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("show_me", isEqualTo: "Everyone")
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .limit(firstLimit)
        .get();

    return query;
  }

  static Future<QuerySnapshot> _hetroQuery(
      {@required CollectionReference ref,
      @required String ssValueGender,
      @required String ssValueShowMe,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("gender", isEqualTo: ssValueShowMe)
        .where("show_me", isEqualTo: ssValueGender)
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .limit(firstLimit)
        .get();

    return query;
  }

  static Future<QuerySnapshot> _paginateHomoQuery(
      {@required CollectionReference ref,
      @required String ssValueGender,
      @required String ssValueShowMe,
      @required int latestAge,
      @required String latestUid,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("gender", isEqualTo: ssValueGender)
        .where("show_me", isEqualTo: ssValueShowMe)
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .startAfter([latestAge, latestUid])
        .limit(paginateLimit)
        .get();

    return query;
  }

  static Future<QuerySnapshot> _paginateEveryOneQuery(
      {@required CollectionReference ref,
      @required int latestAge,
      @required String latestUid,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("show_me", isEqualTo: "Everyone")
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .startAfter([latestAge, latestUid])
        .limit(paginateLimit)
        .get();

    return query;
  }

  static Future<QuerySnapshot> _paginateHetroQuery(
      {@required CollectionReference ref,
      @required String ssValueGender,
      @required String ssValueShowMe,
      @required int latestAge,
      @required String latestUid,
      @required int fromAge,
      @required int toAge}) async {
    QuerySnapshot query = await ref
        .where("gender", isEqualTo: ssValueShowMe)
        .where("show_me", isEqualTo: ssValueGender)
        .where("age", isGreaterThanOrEqualTo: fromAge)
        .where("age", isLessThanOrEqualTo: toAge)
        .orderBy("age")
        .orderBy("uid")
        .startAfter([latestAge, latestUid])
        .limit(paginateLimit)
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
      print("No more feeds to scroll in WC pagination");
      latestAge = 0;
      latestUid = "";
    }
  }

  static void _unZipAndAddToScrollDetails(
      {@required dynamic queryDataName,
      @required String ssValueUid,
      @required String nickName}) {
    // unzip data and add to scroll
    try {
      if (queryDataName.get("uid") != ssValueUid) {
        print(
            "$nickName : ${queryDataName.get("name")} ${queryDataName.get("uid")} age : ${queryDataName.get("age")}");

        //  head and body photo
        DownloadCloudStorage.headImageDownload(queryDataName.get("uid"))
            .then((headImg) {
          if (headImg.isNotEmpty || headImg != null) {
            DownloadCloudStorage.bodyImageDownload(queryDataName.get("uid"))
                .then((bodyImg) {
              if (bodyImg.isNotEmpty || bodyImg != null) {
                // store to map
                Map<String, dynamic> serializeDetails = {
                  "uid": queryDataName.get("uid"),
                  "gender": queryDataName.get("gender"),
                  "show_me": queryDataName.get("show_me"),
                  "age": queryDataName.get("age"),
                  "name": queryDataName.get("name"),
                  "headphoto": headImg,
                  "bodyphoto": bodyImg,
                  "city_state":
                      "${queryDataName.get("city")},${queryDataName.get("state")}",
                };
                // add map to list
                scrollUserDetails.add(serializeDetails);
              }
            });
          }
        });
      }
    } catch (error) {
      print("Error in unzipping data -> whole country ${error.toString()}");
    }
  }

  // * connect users with there basic details like gender ,showme , age
  static Future basicUserConnection() async {
    try {
      var matchMakingResults = FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen");

      // String uid = FirebaseAuth.instance.currentUser.uid;
      // * 200 == Whole country
      if (newRadius == 180) {
        print("Showing people all around the country");

        readAll().then((ssValues) async {
          // access secure storage
          int fromAge = int.parse(ssValues["from_age"]);
          int toAge = int.parse(ssValues["to_age"]);

          if (ssValues["gender"] == ssValues["show_me"]) {
            // query same gender and showme -> homosexual
            print("Homosexual query");
            var queryHomo = _homoQuery(
                ref: matchMakingResults,
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                fromAge: fromAge,
                toAge: toAge);
            // query results
            queryHomo.then((qH) => qH.docs.forEach((homoQueryData) =>
                _unZipAndAddToScrollDetails(
                    queryDataName: homoQueryData,
                    ssValueUid: ssValues["current_uid"],
                    nickName: "Homo")));
            // ? get latest documents
            await _getlatestDocuments(queryHomo);
          } else if (ssValues["show_me"] == "Everyone") {
            // when user show me is set to everyone
            //  gender doesn't matter
            print("Everyone query");
            var queryEveryOne = _everyOneQuery(
                ref: matchMakingResults, fromAge: fromAge, toAge: toAge);
            // query
            queryEveryOne.then((qEve) => qEve.docs.forEach(
                (everyOneQueryData) => _unZipAndAddToScrollDetails(
                    queryDataName: everyOneQueryData,
                    ssValueUid: ssValues["current_uid"],
                    nickName: "EveryOne")));
            // ? get latest documents
            await _getlatestDocuments(queryEveryOne);
          } else if ((ssValues["gender"] != ssValues["show_me"])) {
            // query for hetrosexual -> opposite genders
            print("hetrosexual query");
            var queryHetro = _hetroQuery(
                ref: matchMakingResults,
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                fromAge: fromAge,
                toAge: toAge);
            // query
            queryHetro.then((qHetro) => qHetro.docs.forEach((hetroQueryData) =>
                _unZipAndAddToScrollDetails(
                    queryDataName: hetroQueryData,
                    ssValueUid: ssValues["current_uid"],
                    nickName: "Hetro")));
            // ? get latest documents
            await _getlatestDocuments(queryHetro);
          }
        });
      }
      // * if radius changed by the user
      else if (newRadius != 180) {
        CustomRadiusGeoHash.nearByUsersGeoHash();
      }
    } catch (error) {
      print("Error in ConnectingUsers -> matchusers : ${error.toString()}");
    }
  }

  static Future paginateBasicUserConnection() async {
    // * query next batch profiles
    try {
      var matchMakingResults = FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen");
      // String uid = FirebaseAuth.instance.currentUser.uid;

      // * 200 == Whole country
      if (newRadius == 180) {
        print(
            "Showing people all around the country -> Pagination -> WC"); // WC -> whole country
        print("Last elements : $latestAge , $latestUid");
        readAll().then((ssValues) async {
          // access secure storage
          int fromAge = int.parse(ssValues["from_age"]);
          int toAge = int.parse(ssValues["to_age"]);

          if (ssValues["gender"] == ssValues["show_me"]) {
            // query same gender and showme -> homosexual
            print("Homosexual query");
            var queryHomo = _paginateHomoQuery(
                ref: matchMakingResults,
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query
            queryHomo.then((qH) => qH.docs.forEach((homoQueryData) =>
                _unZipAndAddToScrollDetails(
                    queryDataName: homoQueryData,
                    ssValueUid: ssValues["current_uid"],
                    nickName: "Homo")));
            // ? get latest documents
            await _getlatestDocuments(queryHomo);
          } else if (ssValues["show_me"] == "Everyone") {
            // when user show me is set to everyone
            //  gender doesn't matter
            print("Everyone query");
            var queryEveryOne = _paginateEveryOneQuery(
                ref: matchMakingResults,
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query
            queryEveryOne.then((qEve) => qEve.docs.forEach(
                (everyOneQueryData) => _unZipAndAddToScrollDetails(
                    queryDataName: everyOneQueryData,
                    ssValueUid: ssValues["current_uid"],
                    nickName: "EveryOne")));
            // ? get latest documents
            await _getlatestDocuments(queryEveryOne);
          } else if ((ssValues["gender"] != ssValues["show_me"])) {
            // query for hetrosexual -> opposite genders
            print("hetrosexual query");
            var queryHetro = _paginateHetroQuery(
                ref: matchMakingResults,
                ssValueGender: ssValues["gender"],
                ssValueShowMe: ssValues["show_me"],
                latestAge: latestAge,
                latestUid: latestUid,
                fromAge: fromAge,
                toAge: toAge);
            // query
            queryHetro.then((qHetro) => qHetro.docs.forEach((hetroQueryData) =>
                _unZipAndAddToScrollDetails(
                    queryDataName: hetroQueryData,
                    ssValueUid: ssValues["current_uid"],
                    nickName: "Hetro")));
            // ? get latest documents
            await _getlatestDocuments(queryHetro);
          }
        });
      } else if (newRadius != 180) {
        // * custom radius paginations -> geo hash
        CustomRadiusGeoHash.paginateNearByUsersGeoHash();
      }
    } catch (error) {
      print("Error in pagination basic user connection ${error.toString()}");
    }
  }
}
