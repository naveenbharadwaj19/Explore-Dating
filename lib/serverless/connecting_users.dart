// todo : Algorithm for getting matched user id

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/data/temp/filter_datas.dart' show radius;
import 'package:explore/data/temp/store_basic_match.dart'
    show scrollUserDetails;
import 'package:explore/models/location.dart';
import '../serverless/download_photos_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class ConnectingUsers {
  static final int limit = 8;
  // * connect users with there basic details like gender ,showme , age
  static Future basicUserConnection() async {
    try {
      var matchMakingResults = FirebaseFirestore.instance
          .collection("Matchmaking/simplematch/MenWomen");

      String uid = FirebaseAuth.instance.currentUser.uid;
      // * 200 == Whole country
      if (radius == 200) {
        print("Showing people all around the country");

        readAll().then((ssValues) async {
          // access secure storage
          int fromAge = int.parse(ssValues["from_age"]);
          int toAge = int.parse(ssValues["to_age"]);

          if (ssValues["gender"] == ssValues["show_me"]) {
            // query same gender and showme -> homosexual
            print("Homosexual query");
            var queryedResults = await matchMakingResults
                .where("gender", isEqualTo: ssValues["gender"])
                .where("show_me", isEqualTo: ssValues["show_me"])
                .where("age", isGreaterThanOrEqualTo: fromAge)
                .where("age", isLessThanOrEqualTo: toAge)
                .limit(limit)
                .get();
            // get uid's
            queryedResults.docs.forEach(
              (homoQuery) {
                if (homoQuery.get("uid") != ssValues["current_uid"]) {
                  print("homo : ${homoQuery.get("uid")}");
                  // decode geopoint of the user from firestore
                  var geoPoint =
                      homoQuery.get("current_coordinates.geopoint") as GeoPoint;
                  double fetchedLatitude = geoPoint.latitude;
                  double fetchedLongitude = geoPoint.longitude;
                  // address
                  LocationModel.getAddress(fetchedLatitude, fetchedLongitude)
                      .then((userAddress) {
                    if (userAddress != null) {
                      //  head and body photo
                      DownloadCloudStorage.headImageDownload(
                              homoQuery.get("uid"))
                          .then((headImg) {
                        if (headImg.isNotEmpty || headImg != null) {
                          DownloadCloudStorage.bodyImageDownload(
                                  homoQuery.get("uid"))
                              .then((bodyImg) {
                            if (bodyImg.isNotEmpty || bodyImg != null) {
                              // store to map
                              Map<String, dynamic> serializeDetails = {
                                "uid": homoQuery.get("uid"),
                                "gender": homoQuery.get("gender"),
                                "show_me": homoQuery.get("show_me"),
                                "age": homoQuery.get("age"),
                                "name": homoQuery.get("name"),
                                "headphoto": headImg,
                                "bodyphoto": bodyImg,
                                "city_state":
                                    "${userAddress.locality},${userAddress.adminArea}",
                              };
                              // add map to list
                              scrollUserDetails.add(serializeDetails);
                            }
                          });
                        }
                      });
                    }
                  });
                }
              },
            );
          } else if (ssValues["show_me"] == "Everyone") {
            // when user show me is set to everyone
            //  gender doesn't matter
            print("Everyone query");
            var queryedResults = await matchMakingResults
                .where("show_me", isEqualTo: "Everyone")
                .where("age", isGreaterThanOrEqualTo: fromAge)
                .where("age", isLessThanOrEqualTo: toAge)
                .limit(limit)
                .get();
            // get uid's
            queryedResults.docs.forEach((everyoneQuery) {
              if (everyoneQuery.get("uid") != ssValues["current_uid"]) {
                print("Eve: ${everyoneQuery.get("uid")}");
                // decode geopoint of the user from firestore
                var geoPoint = everyoneQuery.get("current_coordinates.geopoint")
                    as GeoPoint;
                double fetchedLatitude = geoPoint.latitude;
                double fetchedLongitude = geoPoint.longitude;
                // address
                LocationModel.getAddress(fetchedLatitude, fetchedLongitude)
                    .then((userAddress) {
                  if (userAddress != null) {
                    //  head and body photo
                    DownloadCloudStorage.headImageDownload(
                            everyoneQuery.get("uid"))
                        .then((headImg) {
                      if (headImg.isNotEmpty || headImg != null) {
                        DownloadCloudStorage.bodyImageDownload(
                                everyoneQuery.get("uid"))
                            .then((bodyImg) {
                          if (bodyImg.isNotEmpty || bodyImg != null) {
                            // store to map
                            Map<String, dynamic> serializeDetails = {
                              "uid": everyoneQuery.get("uid"),
                              "gender": everyoneQuery.get("gender"),
                              "show_me": everyoneQuery.get("show_me"),
                              "age": everyoneQuery.get("age"),
                              "name": everyoneQuery.get("name"),
                              "headphoto": headImg,
                              "bodyphoto": bodyImg,
                              "city_state":
                                  "${userAddress.locality},${userAddress.adminArea}",
                            };
                            // add map to list
                            scrollUserDetails.add(serializeDetails);
                          }
                        });
                      }
                    });
                  }
                });
              }
            });
          } else if ((ssValues["gender"] != ssValues["show_me"])) {
            // query for hetrosexual -> opposite genders
            print("hetrosexual query");
            var queryedResults = await matchMakingResults
                .where("gender", isEqualTo: ssValues["show_me"])
                .where("show_me", isEqualTo: ssValues["gender"])
                .where("age", isGreaterThanOrEqualTo: fromAge)
                .where("age", isLessThanOrEqualTo: toAge)
                .limit(limit)
                .get();

            queryedResults.docs.forEach((hetroQuery) {
              if (hetroQuery.get("uid") != ssValues["current_uid"]) {
                print("hetro : ${hetroQuery.get("uid")}");
                // decode geopoint of the user from firestore
                var geoPoint =
                    hetroQuery.get("current_coordinates.geopoint") as GeoPoint;
                double fetchedLatitude = geoPoint.latitude;
                double fetchedLongitude = geoPoint.longitude;
                // address
                LocationModel.getAddress(fetchedLatitude, fetchedLongitude)
                    .then((userAddress) {
                  if (userAddress != null) {
                    //  head and body photo
                    DownloadCloudStorage.headImageDownload(
                            hetroQuery.get("uid"))
                        .then((headImg) {
                      if (headImg.isNotEmpty || headImg != null) {
                        DownloadCloudStorage.bodyImageDownload(
                                hetroQuery.get("uid"))
                            .then((bodyImg) {
                          if (bodyImg.isNotEmpty || bodyImg != null) {
                            // store to map
                            Map<String, dynamic> serializeDetails = {
                              "uid": hetroQuery.get("uid"),
                              "gender": hetroQuery.get("gender"),
                              "show_me": hetroQuery.get("show_me"),
                              "age": hetroQuery.get("age"),
                              "name": hetroQuery.get("name"),
                              "headphoto": headImg,
                              "bodyphoto": bodyImg,
                              "city_state":
                                  "${userAddress.locality},${userAddress.adminArea}",
                            };
                            // add map to list
                            scrollUserDetails.add(serializeDetails);
                          }
                        });
                      }
                    });
                  }
                });
              }
            });
          }
        });
      }
      // * if radius changed by the user
      else if (radius != 200) {
        print("Fetching nearby users within ${radius.round()} km");
        var getCoordinates = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        var currentPostion = getCoordinates;
        Geoflutterfire geoFF = Geoflutterfire();
        // center point
        GeoFirePoint center = geoFF.point(
            latitude: currentPostion.latitude,
            longitude: currentPostion.longitude);
        var matchMakingRef = FirebaseFirestore.instance
            .collection("Matchmaking/simplematch/MenWomen");

        String field = "current_coordinates";
        var fetchAllNearbyUsers = geoFF
            .collection(collectionRef: matchMakingRef, limitby: limit)
            .within(center: center, radius: radius, field: field);
        // fetch all nearby users
        fetchAllNearbyUsers.forEach((nearByUsers) {
          nearByUsers.forEach((usersData) {
            if (usersData.get("uid") != uid) {
              // isolate current logged in user details
              // print(usersData.data());
              String fetchedUid = usersData.get("uid");
              readAll().then((ssValues) async {
                // access secure storage
                int fromAge = int.parse(ssValues["from_age"]);
                int toAge = int.parse(ssValues["to_age"]);

                if (ssValues["gender"] == ssValues["show_me"]) {
                  // homosexual query -> men == men same gender preference
                  var queryedResults = await matchMakingRef
                      .where("uid", isEqualTo: fetchedUid)
                      .where("gender", isEqualTo: ssValues["gender"])
                      .where("show_me", isEqualTo: ssValues["show_me"])
                      .where("age", isGreaterThanOrEqualTo: fromAge)
                      .where("age", isLessThanOrEqualTo: toAge)
                      .get();

                  queryedResults.docs.forEach((homoQuery) {
                    print("Homo : ${homoQuery.get("uid")}");

                    // decode geopoint of the user from firestore
                    var geoPoint = homoQuery.get("current_coordinates.geopoint")
                        as GeoPoint;
                    double fetchedLatitude = geoPoint.latitude;
                    double fetchedLongitude = geoPoint.longitude;
                    // address
                    LocationModel.getAddress(fetchedLatitude, fetchedLongitude).then((userAddress){
                      if(userAddress != null){
                        DownloadCloudStorage.headImageDownload(
                            homoQuery.get("uid"))
                        .then((headImg) {
                      if (headImg.isNotEmpty || headImg != null) {
                        DownloadCloudStorage.bodyImageDownload(
                                homoQuery.get("uid"))
                            .then((bodyImg) {
                          if (bodyImg.isNotEmpty || bodyImg != null) {
                            // store to map
                            Map<String, dynamic> serializeDetails = {
                              "uid": homoQuery.get("uid"),
                              "gender": homoQuery.get("gender"),
                              "show_me": homoQuery.get("show_me"),
                              "age": homoQuery.get("age"),
                              "name": homoQuery.get("name"),
                              "headphoto": headImg,
                              "bodyphoto": bodyImg,
                              "city_state":
                                  "${userAddress.locality},${userAddress.adminArea}",
                            };
                            // add map to list
                            scrollUserDetails.add(serializeDetails);
                          }
                        });
                      }
                    });
                      }
                    });
                  });
                } else if (ssValues["show_me"] == "Everyone") {
                  // everyone query
                  // gender is not considered
                  var everyoneQuery = await matchMakingRef
                      .where("uid", isEqualTo: fetchedUid)
                      .where("show_me", isEqualTo: "Everyone")
                      .where("age", isGreaterThanOrEqualTo: fromAge)
                      .where("age", isLessThanOrEqualTo: toAge)
                      .get();

                  everyoneQuery.docs.forEach((everyoneResult) {
                    print("Eve : ${everyoneResult.get("uid")}");
                    // decode geopoint of the user from firestore
                    var geoPoint = everyoneResult.get("current_coordinates.geopoint")
                        as GeoPoint;
                    double fetchedLatitude = geoPoint.latitude;
                    double fetchedLongitude = geoPoint.longitude;
                    // address
                    LocationModel.getAddress(fetchedLatitude, fetchedLongitude).then((userAddress){
                      if(userAddress != null){
                        DownloadCloudStorage.headImageDownload(
                            everyoneResult.get("uid"))
                        .then((headImg) {
                      if (headImg.isNotEmpty || headImg != null) {
                        DownloadCloudStorage.bodyImageDownload(
                                everyoneResult.get("uid"))
                            .then((bodyImg) {
                          if (bodyImg.isNotEmpty || bodyImg != null) {
                            // store to map
                            Map<String, dynamic> serializeDetails = {
                              "uid": everyoneResult.get("uid"),
                              "gender": everyoneResult.get("gender"),
                              "show_me": everyoneResult.get("show_me"),
                              "age": everyoneResult.get("age"),
                              "name": everyoneResult.get("name"),
                              "headphoto": headImg,
                              "bodyphoto": bodyImg,
                              "city_state":
                                  "${userAddress.locality},${userAddress.adminArea}",
                            };
                            // add map to list
                            scrollUserDetails.add(serializeDetails);
                          }
                        });
                      }
                    });
                      }
                    });
                  });
                } else if (ssValues["gender"] != ssValues["show_me"]) {
                  // hetro sexual -> opposite genders
                  var queryedResults = await matchMakingRef
                      .where("uid", isEqualTo: fetchedUid)
                      .where("gender", isEqualTo: ssValues["show_me"])
                      .where("show_me", isEqualTo: ssValues["gender"])
                      .where("age", isGreaterThanOrEqualTo: fromAge)
                      .where("age", isLessThanOrEqualTo: toAge)
                      .get();

                  queryedResults.docs.forEach((hetroQuery) {
                    print("hetro : ${hetroQuery.get("uid")}");
                    // decode geopoint of the user from firestore
                    var geoPoint = hetroQuery.get("current_coordinates.geopoint")
                        as GeoPoint;
                    double fetchedLatitude = geoPoint.latitude;
                    double fetchedLongitude = geoPoint.longitude;
                    // address
                    LocationModel.getAddress(fetchedLatitude, fetchedLongitude).then((userAddress){
                      if(userAddress != null){
                        DownloadCloudStorage.headImageDownload(
                            hetroQuery.get("uid"))
                        .then((headImg) {
                      if (headImg.isNotEmpty || headImg != null) {
                        DownloadCloudStorage.bodyImageDownload(
                                hetroQuery.get("uid"))
                            .then((bodyImg) {
                          if (bodyImg.isNotEmpty || bodyImg != null) {
                            // store to map
                            Map<String, dynamic> serializeDetails = {
                              "uid": hetroQuery.get("uid"),
                              "gender": hetroQuery.get("gender"),
                              "show_me": hetroQuery.get("show_me"),
                              "age": hetroQuery.get("age"),
                              "name": hetroQuery.get("name"),
                              "headphoto": headImg,
                              "bodyphoto": bodyImg,
                              "city_state":
                                  "${userAddress.locality},${userAddress.adminArea}",
                            };
                            // add map to list
                            scrollUserDetails.add(serializeDetails);
                          }
                        });
                      }
                    });
                      }
                    });
                  });
                }
              });
            }
          });
        });
      }
    } catch (error) {
      print("Error in ConnectingUsers -> matchusers : ${error.toString()}");
    }
  }
}
