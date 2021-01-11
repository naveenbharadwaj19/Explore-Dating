// todo : DOB screen only during google auth

import 'package:explore/data/auth_data.dart' show ageM,dobM;
import 'package:explore/models/firestore_signup.dart'show GooglePath;
import 'package:explore/widgets/signup_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:intl/intl.dart';

class GoogleDobScreen extends StatefulWidget {
  @override
  _GoogleDobScreenState createState() => _GoogleDobScreenState();
}

class _GoogleDobScreenState extends State<GoogleDobScreen> {
  bool agreeAge = false;
  bool agreeTerms = false;
  

  void toggleAge() {
    setState(() {
      agreeAge = !agreeAge;
    });
  }

  void toogleTerms() {
    setState(() {
      agreeTerms = !agreeTerms;
    });
  }

  @override
  // ? Check setstate disposed properly
  void setState(fn) {
    // ignore: todo
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xff121212),
        child: Column(
          children: [
            Row(
              // ? logo and text
              children: [
                Container(
                  child: Image.asset(
                    "assets/app_images/explore_org_logo.png",
                    fit: BoxFit.cover,
                    height: 200,
                    width: 170,
                  ),
                ),
                Text(
                  "Explore",
                  style: TextStyle(
                      fontFamily: "Domine",
                      fontSize: 40,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            DOBGoogle(),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: ageCondition(agreeAge, toggleAge),
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: termsAndConditions(agreeTerms, toogleTerms),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 180,
                margin: EdgeInsets.only(bottom: 30),
                child: RaisedButton(
                  color: Color(0xffF8C80D),
                  textColor: Color(0xff121212),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Color(0xffF8C80D))),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (dobM == null || dobM.isEmpty) {
                      Flushbar(
                        backgroundColor: Color(0xff121212),
                        messageText: Text(
                          "Enter birth date",
                          style: TextStyle(
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                    else if (agreeAge == true && agreeTerms == true) {
                      GooglePath.updateDobGoogle(dobM, ageM);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DOBGoogle extends StatefulWidget {
  // ? Date of birth
  @override
  _DOBGoogleState createState() => _DOBGoogleState();
}

class _DOBGoogleState extends State<DOBGoogle> {
  DateTime today = DateTime.now();

  String formattedDate() {
    return DateFormat("dd/MM/yyyy").format(today).toString();
  }

  int _findAge() {
    // ? check whether user is above 18+
    String getYear = formattedDate().substring(formattedDate().length - 4);
    int strToIntYear = int.parse(getYear);
    DateTime currentTimeStamp = DateTime.now();
    String formatYear = DateFormat("yyyy").format(currentTimeStamp).toString();
    int formatYearToInt = int.parse(formatYear);
    int findAge = formatYearToInt - strToIntYear;
    return findAge;
  }

  _selectDate(BuildContext context) async {
    // ? holo date picker
    final DateTime picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: today,
      firstDate: DateTime(1940),
      dateFormat: "dd-MMMM-yyyy",
      lastDate: DateTime.now(),
      looping: true,
      backgroundColor: Color(0xff121212),
      textColor: Color(0xffF8C80D),
      titleText: "Select Your Date of Birth",
      cancelText: "Cancel",
      confirmText: "Ok",
    );
    if (picked != null && picked != today)
      setState(() {
        today = picked;
        dobM = formattedDate();
        ageM = _findAge();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-0.3, 0.0),
      child: Container(
        margin: EdgeInsets.only(top: 25),
        height: 60,
        width: 300,
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.white),
        )),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "D.O.B : ",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
            RaisedButton(
              color: Color(0xffF8C80D),
              textColor: Color(0xff121212),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                  side: BorderSide(color: Color(0xffF8C80D))),
              child: Text(
                _findAge() < 18 ? "Enter age 18+" : formattedDate(),
                style: TextStyle(fontSize: 16
                    // fontWeight: FontWeight.w700
                    ),
              ),
              onPressed: () => _selectDate(context),
            ),
          ],
        ),
      ),
    );
  }
}
