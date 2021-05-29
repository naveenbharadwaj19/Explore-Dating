// @dart=2.9
// todo : DOB screen only during google auth

import 'package:explore/data/temp/auth_data.dart' show ageM, dobM;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../server/signup_backend/firestore_signup.dart' show GooglePath;
import 'package:explore/widgets/signup_widget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:intl/intl.dart';

class DOBNameScreen extends StatefulWidget {
  @override
  _DOBNameScreen createState() => _DOBNameScreen();
}

class _DOBNameScreen extends State<DOBNameScreen> {
  bool agreeAge = false;
  bool agreeTerms = false;
  TextEditingController nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser.displayName ?? "");

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
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            _NameTextField(nameController), // name
            _DOB(), // dob
            Container(
              // cannot be undone message
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 10,left: 50),
              child: const Text("Note: This action cannot be undone",style: TextStyle(fontSize: 16,color: Colors.white70),),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5,left: 5),
              child: ageCondition(agreeAge, toggleAge),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: termsAndConditions(agreeTerms, toogleTerms),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 180,
                margin: const EdgeInsets.only(bottom: 30),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Theme.of(context).buttonColor,
                  textColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Theme.of(context).primaryColor)),
                  child: const Text(
                    "Continue",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    if (dobM == null || dobM.isEmpty || nameController.text.isEmpty) {
                      Flushbar(
                        backgroundColor: Theme.of(context).primaryColor,
                        messageText: const Text(
                          "Some fields are missing",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        duration: Duration(seconds: 3),
                      )..show(context);
                    } else if (agreeAge == true && agreeTerms == true) {
                      GooglePath.updateDobNameGoogle(dobM, ageM,nameController.text);
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

class _NameTextField extends StatelessWidget {
  final TextEditingController nameController;
  _NameTextField(this.nameController);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(top: 100, left: 5, right: 40),
      child: Align(
        alignment: Alignment(-0.3, 0.0),
        child: TextField(
          controller: nameController,
          inputFormatters: [
            LengthLimitingTextInputFormatter(25), // max characters 25
          ],
          minLines: 1,
          maxLines: 1,
          cursorColor: Colors.white,
          cursorWidth: 3.0,
          // ! Need to use input text as WORDSANS
          style: const TextStyle(color: Colors.white, fontSize: 18),
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Theme.of(context).buttonColor, width: 2),
            ),
            hintText: "Name",
            hintStyle: const TextStyle(
                color: Colors.white54, fontWeight: FontWeight.w700),
          ),
          onSubmitted: (String value) {
            FocusManager.instance.primaryFocus.unfocus();
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _DOB extends StatefulWidget {
  // ? Date of birth
  @override
  _DOBState createState() => _DOBState();
}

class _DOBState extends State<_DOB> {
  DateTime today = DateTime.now();

  int getAbove18Year() {
    var now = new DateTime.now();
    String yearFormatter = DateFormat("y").format(now);
    int currentYear = int.parse(yearFormatter);
    int above18Year = currentYear - 18;
    return above18Year;
  }

  String formattedDate() {
    return DateFormat("dd/MM/yyyy").format(today).toString();
  }

  int findAge() {
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
      lastDate: DateTime(getAbove18Year(), today.month, today.day),
      looping: true,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Theme.of(context).buttonColor,
      titleText: "Select Your Date of Birth",
      cancelText: "Cancel",
      confirmText: "Ok",
    );
    if (picked != null && picked != today)
      setState(() {
        today = picked;
        dobM = formattedDate();
        ageM = findAge();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-0.3, 0.0),
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        height: 60,
        width: 300,
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white, width: 1.5),
        )),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "Date of birth :",
                style: const TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              color: Theme.of(context).buttonColor,
              textColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                  side: BorderSide(color: Color(0xffF8C80D))),
              child: Text(
                findAge() < 18 ? "Select" : formattedDate(),
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: const TextStyle(fontSize: 16),
              ),
              onPressed: () => _selectDate(context),
            ),
          ],
        ),
      ),
    );
  }
}
