// @dart=2.9
import 'package:another_flushbar/flushbar.dart';
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/data/temp/filter_datas.dart'
    show
        newRadius,
        newAgeValues1,
        newCurrentShowMe,
        oldRadius,
        oldAgeValues1,
        oldCurrentShowMe;
import 'package:explore/data/temp/store_basic_match.dart'
    show scrollUserDetails;
import 'package:explore/providers/pageview_logic.dart';
import 'package:explore/server/match_backend/connecting_users.dart';
import 'package:explore/server/filters_info.dart';
import 'package:explore/server/match_backend/geohash_custom_radius.dart';
import 'package:provider/provider.dart';
import '../server/update_show_me.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> filterScreen({BuildContext context}) {
  return showBarModalBottomSheet(
      backgroundColor: Color(0xff121212),
      context: context,
      builder: (context) => FilterBottomSheetWidgets(context));
}

class FilterBottomSheetWidgets extends StatefulWidget {
  final BuildContext context2;
  FilterBottomSheetWidgets(this.context2);
  @override
  _FilterBottomSheetWidgetsState createState() =>
      _FilterBottomSheetWidgetsState();
}

class _FilterBottomSheetWidgetsState extends State<FilterBottomSheetWidgets> {
  RangeValues ageValues = newAgeValues1;
  double distanceKm = newRadius;
  String currentShowme = newCurrentShowMe;
  int index = 0;

  //
  void updateSelectedShowMe(int idx) {
    // * 1 - men , 2 - women , 3 - everyone
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageViewLogic = Provider.of<PageViewLogic>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        color: Color(0xff121212),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              child: const Text(
                "Filters",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              // ? Age widget
              margin: const EdgeInsets.all(15),
              height: 135,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 1.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 20, top: 5),
                        child: const Text(
                          "Age",
                          style:
                              TextStyle(color: Color(0xffF8C80D), fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "From : ${ageValues.start.round()} To : ${ageValues.end.round()}",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        // ? age slide bar
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.white38,
                              thumbColor: Color(0xffF8C80D),
                              overlayColor: Color(0x40F8C80D),
                              activeTickMarkColor: Colors.white,
                              inactiveTickMarkColor: Colors.white38,
                              valueIndicatorColor: Colors.grey,
                              valueIndicatorTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              )),
                          child: RangeSlider(
                            values: ageValues,
                            min: 18,
                            max: 80,
                            onChanged: (v) {
                              setState(() {
                                ageValues = v;
                                // newAgeValues1 = RangeValues(v.start, v.end);
                                // oldAgeValues1 = RangeValues(v.start, v.end);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              // ? Radius & distance widget
              margin: const EdgeInsets.all(15),
              height: 135,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 1.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 20, top: 5),
                        child: const Text(
                          "Radius",
                          style:
                              TextStyle(color: Color(0xffF8C80D), fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          distanceKm == 180
                              ? "Whole Country"
                              : "Cover up to ${distanceKm.round()} Km",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 20),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          // ? Radius & distance slide bar
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white38,
                                thumbColor: Color(0xffF8C80D),
                                overlayColor: Color(0x40F8C80D),
                                activeTickMarkColor: Colors.white,
                                inactiveTickMarkColor: Colors.white38,
                                valueIndicatorColor: Colors.grey,
                                valueIndicatorTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                            child: Slider(
                              min: 5,
                              max: 180,
                              divisions: 12,
                              label: "${distanceKm.round().toString()}",
                              value: distanceKm,
                              onChanged: (v) {
                                setState(() {
                                  distanceKm = v;
                                  // newRadius = v;
                                });
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              // ? show me widget
              margin: const EdgeInsets.all(15),
              height: 135,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 1.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 20, top: 5),
                        child: const Text(
                          "Show me",
                          style:
                              TextStyle(color: Color(0xffF8C80D), fontSize: 20),
                        ),
                      ),
                      // ? types of show me
                      Container(
                        // ! change to left : 10 if overflow error pop up
                        margin:
                            const EdgeInsets.only(top: 35, left: 2, right: 2),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              height: 50,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                color: Color(
                                    index == 1 || currentShowme == "Men"
                                        ? 0xffF8C80D
                                        : 0xff121212),
                                textColor: index == 1 || currentShowme == "Men"
                                    ? Color(0xff121212)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                        color: Color(0xffF8C80D), width: 1.5)),
                                child: const Text(
                                  "Men",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    // fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onPressed: () {
                                  currentShowme = "Men";
                                  // oldCurrentShowMe = currentShowme;
                                  print("Selected : $currentShowme");
                                  updateSelectedShowMe(1);
                                },
                              ),
                            ),
                            Container(
                              height: 50,
                              margin: const EdgeInsets.only(left: 15),
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                color: Color(
                                    index == 2 || currentShowme == "Women"
                                        ? 0xffF8C80D
                                        : 0xff121212),
                                textColor:
                                    index == 2 || currentShowme == "Women"
                                        ? Color(0xff121212)
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                        color: Color(0xffF8C80D), width: 1.5)),
                                child: const Text(
                                  "Women",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    // fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onPressed: () {
                                  currentShowme = "Women";
                                  // oldCurrentShowMe = currentShowme;
                                  print("Selected : $currentShowme");
                                  updateSelectedShowMe(2);
                                },
                              ),
                            ),
                            Container(
                              height: 50,
                              margin: const EdgeInsets.only(left: 15),
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                color: Color(
                                    index == 3 || currentShowme == "Everyone"
                                        ? 0xffF8C80D
                                        : 0xff121212),
                                textColor:
                                    index == 3 || currentShowme == "Everyone"
                                        ? Color(0xff121212)
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                        color: Color(0xffF8C80D), width: 1.5)),
                                child: const Text(
                                  "Everyone",
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    // fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onPressed: () {
                                  currentShowme = "Everyone";
                                  // oldCurrentShowMe = currentShowme;
                                  print("Selected : $currentShowme");
                                  updateSelectedShowMe(3);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: 300,
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Color(0xff121212),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xffF8C80D), width: 1.5)),
                child: const Text(
                  "Apply",
                  style: const TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: oldRadius.round() == distanceKm.round() &&
                        oldAgeValues1.start.round() ==
                            ageValues.start.round() &&
                        oldAgeValues1.end.round() == ageValues.end.round() &&
                        oldCurrentShowMe == currentShowme
                    ? null
                    : () {
                        print("Filter Applied");
                        filterApplyBackend(pageViewLogic, context);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterApplyBackend(PageViewLogic pageViewLogic, BuildContext context) {
    // ? update old values
    oldRadius = distanceKm;
    oldAgeValues1 = ageValues;
    oldCurrentShowMe = currentShowme;
    // ? update new values
    newRadius = distanceKm;
    newAgeValues1 = ageValues;
    newCurrentShowMe = currentShowme;
    //
    pageViewLogic.pageStorageKeyNo += 1; // ? incremenent pagestorage key
    pageViewLogic.holdFuture = true; // change future duration to 1 seconds
    pageViewLogic.callConnectingUsers = true;
    scrollUserDetails.clear(); // clear scroll list // ? 1
    writeValue("radius", distanceKm.round().toString());
    writeValue("from_age", ageValues.start.round().toString());
    writeValue("to_age", ageValues.end.round().toString());
    writeValue("show_me", currentShowme);
    updateShowMeFirestore(currentShowme);
    filtersInformationUpdate(currentShowme, distanceKm.round(), ageValues);
    ConnectingUsers.resetLatestDocs(); // reset latest documents
    CustomRadiusGeoHash.resetLatestDocs(); // reset latest documents
    scrollUserDetails.clear(); // clear scroll list // ? 2
    Navigator.pop(context);
    Flushbar(
      messageText: Text(
        "Filters Updated",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      backgroundColor: Color(0xff121212),
      duration: Duration(seconds: 1),
    )..show(context);
  }
}
