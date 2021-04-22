// @dart=2.9
// Todo : popups of about widgets aka modal sheet


import 'package:auto_size_text/auto_size_text.dart';
import 'package:explore/data/zodiac_signs.dart';
import 'package:explore/serverless/profile_backend/abt_me_backend.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future educationLevelPopUpBottomSheet(Color yellow, BuildContext context) {
  return showBarModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      builder: (context) => EducationLevelPopUp(yellow));
}

class EducationLevelPopUp extends StatefulWidget {
  final Color yellow;
  EducationLevelPopUp(this.yellow);
  @override
  _EducationLevelPopUpState createState() => _EducationLevelPopUpState();
}

class _EducationLevelPopUpState extends State<EducationLevelPopUp> {
  String selectedEducationLevel = "";
  int index = 0;
  void updateButton(int idx) {
    // *1 - school , 2 - undergraduate , 3 - post graduate , 4 - graduated
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 420,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Education Level",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // ? school
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 1 ? Color(0xff121212) : widget.yellow,
              textColor: index != 1 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child: const AutoSizeText(
                "School",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedEducationLevel = "School";
                print(selectedEducationLevel);
                updateButton(1);
              },
            ),
          ),
          Container(
            // ? undergraduate
            margin: const EdgeInsets.only(top: 10),
            // width: 180, // * width is removed to occupy remaining space
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 2 ? Color(0xff121212) : widget.yellow,
              textColor: index != 2 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child: const AutoSizeText(
                "Under Graduate",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedEducationLevel = "Under Graduate";
                print(selectedEducationLevel);
                updateButton(2);
              },
            ),
          ),
          Container(
            // ? postgraduate
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 3 ? Color(0xff121212) : widget.yellow,
              textColor: index != 3 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child:  const AutoSizeText(
                "Post Graduate",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedEducationLevel = "Post Graduate";
                print(selectedEducationLevel);
                updateButton(3);
              },
            ),
          ),
          Container(
            // ? graduated
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 4 ? Color(0xff121212) : widget.yellow,
              textColor: index != 4 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child: const AutoSizeText(
                "Graduated",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedEducationLevel = "Graduated";
                print(selectedEducationLevel);
                updateButton(4);
              },
            ),
          ),
          const Spacer(),
          Row(
            // ? later and save button
            children: [
              Container(
                // ? later button
                margin: const EdgeInsets.only(left: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: widget.yellow, width: 2),
                  ),
                  child: const Text(
                    "Later",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Container(
                // ? vertical divder
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                height: 30,
                width: 3,
                color: Colors.white54,
              ),
              const Spacer(),
              Container(
                // ? save button
                margin: const EdgeInsets.only(right: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (selectedEducationLevel.isNotEmpty) {
                      ProfileAboutMeBackEnd.educationLevel(
                          selectedEducationLevel);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future smokingPopUpBottomSheet(Color yellow, BuildContext context) {
  return showBarModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      builder: (context) => SmokingPopUp(yellow));
}

class SmokingPopUp extends StatefulWidget {
  final Color yellow;
  SmokingPopUp(this.yellow);
  @override
  _SmokingPopUpState createState() => _SmokingPopUpState();
}

class _SmokingPopUpState extends State<SmokingPopUp> {
  String selectedSmokingOption = "";
  int index = 0;
  void updateButton(int idx) {
    // *1 - regularly , 2 - socially , 3 - never
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 350,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Do you smoke?",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // ? regularly
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 1 ? Color(0xff121212) : widget.yellow,
              textColor: index != 1 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xffF8C80D), width: 2),
              ),
              child: const AutoSizeText(
                "Regularly",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedSmokingOption = "Regularly";
                print(selectedSmokingOption);
                updateButton(1);
              },
            ),
          ),
          Container(
            // ? socially
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 2 ? Color(0xff121212) : widget.yellow,
              textColor: index != 2 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xffF8C80D), width: 2),
              ),
              child: const AutoSizeText(
                "Socially",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedSmokingOption = "Socially";
                print(selectedSmokingOption);
                updateButton(2);
              },
            ),
          ),
          Container(
            // ? never
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 3 ? Color(0xff121212) : widget.yellow,
              textColor: index != 3 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xffF8C80D), width: 2),
              ),
              child: const AutoSizeText(
                "Never",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedSmokingOption = "Never";
                print(selectedSmokingOption);
                updateButton(3);
              },
            ),
          ),
          const Spacer(),
          Row(
            // ? later and save button
            children: [
              Container(
                // ? later button
                margin: const EdgeInsets.only(left: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Later",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Container(
                // ? vertical divder
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                height: 30,
                width: 3,
                color: Colors.white54,
              ),
              const Spacer(),
              Container(
                // ? save button
                margin: const EdgeInsets.only(right: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (selectedSmokingOption.isNotEmpty) {
                      ProfileAboutMeBackEnd.smoking(selectedSmokingOption);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future drinkingPopUpBottomSheet(Color yellow, BuildContext context) {
  return showBarModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    builder: (context) => DrinkingPopUp(yellow),
  );
}

class DrinkingPopUp extends StatefulWidget {
  final Color yellow;
  DrinkingPopUp(this.yellow);
  @override
  _DrinkingPopUpState createState() => _DrinkingPopUpState();
}

class _DrinkingPopUpState extends State<DrinkingPopUp> {
  String selectedDrinkingOption = "";
  int index = 0;
  void updateButton(int idx) {
    // *1 - regularly , 2 - socially , 3 - never
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 350,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Do you drink?",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // ? regularly
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 1 ? Color(0xff121212) : widget.yellow,
              textColor: index != 1 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xffF8C80D), width: 2),
              ),
              child: const AutoSizeText(
                "Regularly",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedDrinkingOption = "Regularly";
                print(selectedDrinkingOption);
                updateButton(1);
              },
            ),
          ),
          Container(
            // ? socially
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 2 ? Color(0xff121212) : widget.yellow,
              textColor: index != 2 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xffF8C80D), width: 2),
              ),
              child: const AutoSizeText(
                "Socially",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedDrinkingOption = "Socially";
                print(selectedDrinkingOption);
                updateButton(2);
              },
            ),
          ),
          Container(
            // ? never
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 3 ? Color(0xff121212) : widget.yellow,
              textColor: index != 3 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xffF8C80D), width: 2),
              ),
              child: const AutoSizeText(
                "Never",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedDrinkingOption = "Never";
                print(selectedDrinkingOption);
                updateButton(3);
              },
            ),
          ),
          const Spacer(),
          Row(
            // ? later and save button
            children: [
              Container(
                // ? later button
                margin: const EdgeInsets.only(left: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Later",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Container(
                // ? vertical divder
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                height: 30,
                width: 3,
                color: Colors.white54,
              ),
              const Spacer(),
              Container(
                // ? save button
                margin: const EdgeInsets.only(right: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side:
                          const BorderSide(color: Color(0xffF8C80D), width: 2)),
                  child: const Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (selectedDrinkingOption.isNotEmpty) {
                      ProfileAboutMeBackEnd.drinking(selectedDrinkingOption);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future lookingForPopUpBottomSheet(Color yellow, BuildContext context) {
  return showBarModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    builder: (context) => LookingForPopUp(yellow),
  );
}

class LookingForPopUp extends StatefulWidget {
  final Color yellow;
  LookingForPopUp(this.yellow);
  @override
  _LookingForPopUpState createState() => _LookingForPopUpState();
}

class _LookingForPopUpState extends State<LookingForPopUp> {
  String selectedLookingForOption = "";
  int index = 0;
  void updateButton(int idx) {
    // *1 - Don't know yet , 2 - something casual , 3 - relationship , 4 - marriage
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 400,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Looking for?",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // ? don't know yet
            margin: const EdgeInsets.only(top: 10),
            width: 200,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 1 ? Color(0xff121212) : widget.yellow,
              textColor: index != 1 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xffF8C80D), width: 2),
              ),
              child: const AutoSizeText(
                "Don't know yet",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedLookingForOption = "Don't know yet";
                print(selectedLookingForOption);
                updateButton(1);
              },
            ),
          ),
          Container(
            // ? something casual
            margin: const EdgeInsets.only(top: 10),
            // width: 200, // * removed width to take remaining space
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 2 ? Color(0xff121212) : widget.yellow,
              textColor: index != 2 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xffF8C80D), width: 2),
              ),
              child: const AutoSizeText(
                "Something casual",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedLookingForOption = "Something casual";
                print(selectedLookingForOption);
                updateButton(2);
              },
            ),
          ),
          Container(
            // ? relationship
            margin: const EdgeInsets.only(top: 10),
            width: 200,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 3 ? Color(0xff121212) : widget.yellow,
              textColor: index != 3 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xffF8C80D), width: 2),
              ),
              child: const AutoSizeText(
                "Relationship",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedLookingForOption = "Relationship";
                print(selectedLookingForOption);
                updateButton(3);
              },
            ),
          ),
          Container(
            // ? marriage
            margin: const EdgeInsets.only(top: 10),
            width: 200,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 4 ? Color(0xff121212) : widget.yellow,
              textColor: index != 4 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xffF8C80D), width: 2),
              ),
              child: const AutoSizeText(
                "Marriage",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedLookingForOption = "Marriage";
                print(selectedLookingForOption);
                updateButton(4);
              },
            ),
          ),
          const Spacer(),
          Row(
            // ? later and save button
            children: [
              Container(
                // ? later button
                margin: const EdgeInsets.only(left: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Later",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Container(
                // ? vertical divder
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                height: 30,
                width: 3,
                color: Colors.white54,
              ),
              const Spacer(),
              Container(
                // ? save button
                margin: const EdgeInsets.only(right: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (selectedLookingForOption.isNotEmpty) {
                      ProfileAboutMeBackEnd.lookingFor(
                          selectedLookingForOption);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future exercisePopUpBottomSheet(Color yellow, BuildContext context) {
  return showBarModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      builder: (context) => ExercisePopUp(yellow));
}

class ExercisePopUp extends StatefulWidget {
  final Color yellow;
  ExercisePopUp(this.yellow);
  @override
  _ExercisePopUpState createState() => _ExercisePopUpState();
}

class _ExercisePopUpState extends State<ExercisePopUp> {
  String selectedExercise = "";
  int index = 0;
  void updateButton(int idx) {
    // *1 - vital , 2 - occasionally , 3 - never
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 350,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "How often do you exercise?",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // ? vital
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 1 ? Color(0xff121212) : widget.yellow,
              textColor: index != 1 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child: const AutoSizeText(
                "Vital",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedExercise = "Vital";
                print(selectedExercise);
                updateButton(1);
              },
            ),
          ),
          Container(
            // ? occasionally
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 2 ? Color(0xff121212) : widget.yellow,
              textColor: index != 2 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child: const AutoSizeText(
                "Occasionally",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedExercise = "Occasionally";
                print(selectedExercise);
                updateButton(2);
              },
            ),
          ),
          Container(
            // ? never
            margin: const EdgeInsets.only(top: 10),
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 3 ? Color(0xff121212) : widget.yellow,
              textColor: index != 3 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child: const AutoSizeText(
                "Never",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedExercise = "Never";
                print(selectedExercise);
                updateButton(3);
              },
            ),
          ),
          const Spacer(),
          Row(
            // ? later and save button
            children: [
              Container(
                // ? later button
                margin: const EdgeInsets.only(left: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: widget.yellow, width: 2),
                  ),
                  child: const Text(
                    "Later",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Container(
                // ? vertical divder
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                height: 30,
                width: 3,
                color: Colors.white54,
              ),
              const Spacer(),
              Container(
                // ? save button
                margin: const EdgeInsets.only(right: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (selectedExercise.isNotEmpty) {
                      ProfileAboutMeBackEnd.exercise(selectedExercise);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future kidsPopUpBottomSheet(Color yellow, BuildContext context) {
  return showBarModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      builder: (context) => KidsPopUp(yellow));
}

class KidsPopUp extends StatefulWidget {
  final Color yellow;
  KidsPopUp(this.yellow);
  @override
  _KidsPopUpState createState() => _KidsPopUpState();
}

class _KidsPopUpState extends State<KidsPopUp> {
  String selectedKidsOption = "";
  int index = 0;
  void updateButton(int idx) {
    // *1 - want someday , 2 - Don't want , 3 - have & want more ,4 - Have & don't want more
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 420,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Kids",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // ? want someday
            margin: const EdgeInsets.only(top: 10),
            width: 265,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 1 ? Color(0xff121212) : widget.yellow,
              textColor: index != 1 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child: const AutoSizeText(
                "Want someday",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedKidsOption = "Want someday";
                print(selectedKidsOption);
                updateButton(1);
              },
            ),
          ),
          Container(
            // ? don't want
            margin: const EdgeInsets.only(top: 10),
            width: 265,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 2 ? Color(0xff121212) : widget.yellow,
              textColor: index != 2 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child: const AutoSizeText(
                "Don't want",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedKidsOption = "Don't want";
                print(selectedKidsOption);
                updateButton(2);
              },
            ),
          ),
          Container(
            // ? have & want more
            margin: const EdgeInsets.only(top: 10),
            width: 265,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 3 ? Color(0xff121212) : widget.yellow,
              textColor: index != 3 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child: const AutoSizeText(
                "Have & want more",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedKidsOption = "Have & want more";
                print(selectedKidsOption);
                updateButton(3);
              },
            ),
          ),
          Container(
            // ? have & don't want more
            margin: const EdgeInsets.only(top: 10),
            width: 265,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: index != 4 ? Color(0xff121212) : widget.yellow,
              textColor: index != 4 ? Colors.white : Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: widget.yellow, width: 2),
              ),
              child: const AutoSizeText(
                "Have & don't want more",
                minFontSize: 18,
                maxFontSize: 20,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                selectedKidsOption = "Have & don't want more";
                print(selectedKidsOption);
                updateButton(4);
              },
            ),
          ),
          const Spacer(),
          Row(
            // ? later and save button
            children: [
              Container(
                // ? later button
                margin: const EdgeInsets.only(left: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: widget.yellow, width: 2),
                  ),
                  child: const Text(
                    "Later",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Container(
                // ? vertical divder
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                height: 30,
                width: 3,
                color: Colors.white54,
              ),
              const Spacer(),
              Container(
                // ? save button
                margin: const EdgeInsets.only(right: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (selectedKidsOption.isNotEmpty) {
                      ProfileAboutMeBackEnd.kids(selectedKidsOption);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future zodiacSignsPopUpBottomSheet(Color yellow, BuildContext context) {
  return showBarModalBottomSheet(
    enableDrag: false,
    isDismissible: false,
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    builder: (context) => ZodiacSignsPopUp(yellow),
  );
}

class ZodiacSignsPopUp extends StatefulWidget {
  final Color yellow;
  ZodiacSignsPopUp(this.yellow);
  @override
  _ZodiacSignsPopUpState createState() => _ZodiacSignsPopUpState();
}

class _ZodiacSignsPopUpState extends State<ZodiacSignsPopUp> {
  String selectedZodiacOption = "";
  int indexState = 0;
  void updateButton(int idx) {
    // *check zodiac signs list
    setState(() {
      indexState = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 460,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Zodiac signs",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Padding(padding: const EdgeInsets.only(top: 10)),
          SizedBox(
            // ? zodiac signs
            height: 300,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              mainAxisSpacing: 15,
              crossAxisSpacing: 5,
              children: List.generate(
                zodiacSigns.length,
                (index) => GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: zodiacSigns[index]["is_selected"]
                          ? widget.yellow
                          : Color(0xff121212),
                      border: Border.all(color: widget.yellow, width: 2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: AutoSizeText(
                      "${zodiacSigns[index]["name"]}",
                      minFontSize: 18,
                      maxFontSize: 20,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: zodiacSigns[index]["is_selected"]
                            ? Color(0xff121212)
                            : Colors.white,
                      ),
                    ),
                  ),
                  onTap: (){
                    selectedZodiacOption = zodiacSigns[index]["name"];
                        zodiacSigns[index]["is_selected"] = true;
                        print(selectedZodiacOption);
                        // set false to unselected zodiac signs
                        // to avoid multiple selection
                        zodiacSigns.forEach((datas) {
                          Map mapOfSelectedZodiacSign;
                          mapOfSelectedZodiacSign = zodiacSigns[index];
                          if (mapOfSelectedZodiacSign != datas) {
                            datas["is_selected"] = false;
                            
                          }
                        });
                        updateButton(index);
                  },
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(
            // ? later and save button
            children: [
              Container(
                // ? later button
                margin: const EdgeInsets.only(left: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Later",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    // loop thorough dict and change selected zodiac sign to false
                    zodiacSigns.forEach((datas) {
                      datas.forEach((k, v) {
                        if (v == true) {
                          datas["is_selected"] = false;
                        }
                      });
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              const Spacer(),
              Container(
                // ? vertical divder
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                height: 30,
                width: 3,
                color: Colors.white54,
              ),
              const Spacer(),
              Container(
                // ? save button
                margin: const EdgeInsets.only(right: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (selectedZodiacOption.isNotEmpty) {
                      ProfileAboutMeBackEnd.zodiacSigns(selectedZodiacOption);
                    }
                    // loop thorough dict and change selected zodiac sign to false
                    zodiacSigns.forEach((datas) {
                      datas.forEach((k, v) {
                        if (v == true) {
                          datas["is_selected"] = false;
                        }
                      });
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
