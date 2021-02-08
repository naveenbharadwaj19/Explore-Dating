import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/data/temp/filter_datas.dart'
    show ageValues1, radius, currentShowMe;
import 'package:explore/data/temp/store_basic_match.dart'show scrollUserDetails;
import '../serverless/update_show_me.dart';
import 'package:flushbar/flushbar.dart';
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
  RangeValues ageValues = ageValues1;
  double distanceKm = radius;
  String currentShowme = currentShowMe;
  int index = 0;
  void updateSelectedShowMe(int idx) {
    // * 1 - men , 2 - women , 3 - everyone
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xff121212),
        // ! commented out height because whole widget is under scroll view
        // height: 600,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              child: const Text(
                "Filters",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              // ? Age widget
              margin: EdgeInsets.all(15),
              height: 135,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 1.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 20, top: 5),
                        child: const Text(
                          "Age",
                          style:
                              TextStyle(color: Color(0xffF8C80D), fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "From : ${ageValues.start.round()} To : ${ageValues.end.round()}",
                          style: TextStyle(color: Colors.white70, fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
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
                              valueIndicatorTextStyle: TextStyle(
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
                                ageValues1 = RangeValues(v.start, v.end);
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
              margin: EdgeInsets.all(15),
              height: 135,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 1.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 20, top: 5),
                        child: const Text(
                          "Radius",
                          style:
                              TextStyle(color: Color(0xffF8C80D), fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          distanceKm == 200
                              ? "Whole Country"
                              : "Cover up to ${distanceKm.round()} Km",
                          style: TextStyle(color: Colors.white70, fontSize: 20),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
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
                                valueIndicatorTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                            child: Slider(
                              min: 10,
                              max: 200,
                              divisions: 12,
                              label: "${distanceKm.round().toString()}",
                              value: distanceKm,
                              onChanged: (v) {
                                setState(() {
                                  distanceKm = v;
                                  radius = v;
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
              margin: EdgeInsets.all(15),
              height: 135,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 1.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 20, top: 5),
                        child: const Text(
                          "Show me",
                          style:
                              TextStyle(color: Color(0xffF8C80D), fontSize: 20),
                        ),
                      ),
                      // ? types of show me
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 35),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
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
                                  style: TextStyle(
                                    fontSize: 20,
                                    // fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onPressed: () {
                                  currentShowme = "Men";
                                  print("Selected : $currentShowme");
                                  updateSelectedShowMe(1);
                                },
                              ),
                            ),
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(left: 15),
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
                                  style: TextStyle(
                                    fontSize: 20,
                                    // fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onPressed: () {
                                  currentShowme = "Women";
                                  print("Selected : $currentShowme");
                                  updateSelectedShowMe(2);
                                },
                              ),
                            ),
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(left: 15),
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
                                  style: TextStyle(
                                    fontSize: 20,
                                    // fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onPressed: () {
                                  currentShowme = "Everyone";
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
              margin: EdgeInsets.all(10),
              width: 300,
              child: RaisedButton(
                color: Color(0xff121212),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xffF8C80D), width: 1.5)),
                child: const Text(
                  "Apply",
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  print("Filter Applied");
                  writeValue("radius", distanceKm.round().toString());
                  writeValue("from_age", ageValues.start.round().toString());
                  writeValue("to_age", ageValues.end.round().toString());
                  writeValue("show_me", currentShowme);
                  updateShowMeFirestore(currentShowme);
                  scrollUserDetails.clear();
                  Navigator.pop(context);
                  Flushbar(
                    messageText: Text(
                      "Filters Updated",
                      style: TextStyle(color: Colors.white,fontSize: 18),
                    ),
                    backgroundColor: Color(0xff121212),
                    duration: Duration(seconds: 2),
                  )..show(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
