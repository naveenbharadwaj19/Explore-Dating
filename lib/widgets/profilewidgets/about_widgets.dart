// @dart=2.9
// todo : All about widgets

import 'package:auto_size_text/auto_size_text.dart';
import 'package:explore/icons/profile_icons_icons.dart';
import 'package:explore/widgets/profilewidgets/about_widgets_popup.dart';
import 'package:explore/widgets/profilewidgets/abt_widgets_forms.dart';
import 'package:explore/widgets/profilewidgets/from_about_widgets.dart';
import 'package:explore/widgets/profilewidgets/height_about_widgets.dart';
import 'package:explore/widgets/profilewidgets/my_interests.dart';
import 'package:flutter/material.dart';

// ? order:
// ? about me , my interest , education level , education , worktitle , height ,exercise ,smoking , drinking , looking for . from , kids  ,zodiac sign

class AboutWidgets extends StatelessWidget {
  final dynamic fetchedProfileData;
  AboutWidgets(this.fetchedProfileData);
  final Color yellow = Color(0xffF8C80D);
  final Color iconColor = Colors.white54;
  final double iconSize = 35;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Column(
          children: [
            // place the widgets here
            _aboutMe(
                fetchedProfileData, yellow, context), // individual color ,size
            _myInterests(
                yellow, context, fetchedProfileData), // individual color ,size
            _educationLevel(
                yellow, context, iconColor, iconSize, fetchedProfileData),
            _education(
                yellow, context, iconColor, iconSize, fetchedProfileData),
            _workTitle(
                yellow, context, iconColor, iconSize, fetchedProfileData),
            _height(yellow, context, iconColor, iconSize, fetchedProfileData),
            _exercise(yellow, context, iconColor, iconSize, fetchedProfileData),
            _smoking(yellow, context, iconColor, iconSize, fetchedProfileData),
            _drinking(yellow, context, iconColor, iconSize, fetchedProfileData),
            _lookingFor(
                yellow, context, iconColor, iconSize, fetchedProfileData),
            _from(yellow, context, iconColor, iconSize, fetchedProfileData),
            _kids(yellow, context, iconColor, iconSize, fetchedProfileData),
            _zodiacSign(
                yellow, context, iconColor, iconSize, fetchedProfileData),
          ],
        ),
      ],
    );
  }
}

Widget _aboutMe(
    dynamic fetchedProfileData, Color yellow, BuildContext context) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? about me text
        margin: const EdgeInsets.only(top: 25, left: 30),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            const Icon(
              ProfileIcons.about_me,
              color: Colors.white54,
              size: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: const Text(
                "About me",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          print("Pressed about me");
          aboutMePopUpBottomSheet(
              context, yellow, fetchedProfileData["about_me"]);
        },
        child: Container(
          // ? about me textinput field
          margin: const EdgeInsets.only(top: 15, left: 30, right: 20),
          alignment: Alignment.topLeft,
          height: 160,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: yellow, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Text(
                "${fetchedProfileData["about_me"]}",
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _myInterests(
    Color yellow, BuildContext context, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  final String fontFamily = "MaterialIcons"; // ! change the fontfamily
  List myInterests = fetchedProfileData["my_interests"];
  return Column(
    children: [
      Container(
        // ? my interest text
        margin: const EdgeInsets.only(top: 25, left: 30),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            const Icon(
              ProfileIcons.my_interests,
              color: Colors.white54,
              size: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: const Text(
                "My Interests",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          print("Pressed my interests");
          myInterestsPopUpBottomSheet(yellow, context);
        },
        child: Container(
          // ? outer box
          margin: const EdgeInsets.only(top: 15, left: 30, right: 20),
          alignment: Alignment.topLeft,
          height: myInterests.length > 4
              ? 260
              : 200, // normal height 200 if interests > 4 height 260
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: yellow, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: GridView.count(
              // ? display my interests
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: List.generate(
                myInterests.length,
                (index) => Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: yellow, width: 2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        // ? icons
                        margin: const EdgeInsets.only(left: 10),
                        child: Icon(
                          IconData(myInterests[index]["icon_codepoint"],
                              fontFamily: fontFamily),
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      Expanded(
                        // ? names
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 5, right: 3, top: 5),
                          child: AutoSizeText(
                            "${myInterests[index]["name"]}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            minFontSize: 16,
                            maxFontSize: 18,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _educationLevel(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? education level text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "Education level",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              ProfileIcons.education_level,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("Pressed education level");
                educationLevelPopUpBottomSheet(yellow, context);
              },
              child: Container(
                height: 50,
                width: width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "${fetchedProfileData["education_level"]}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _education(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? education text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "Education",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              ProfileIcons.education,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("Pressed education");
                educationPopUpBottomSheet(context, yellow);
              },
              child: Container(
                height: fetchedProfileData["education"].length >= 16
                    ? 65
                    : 50, // normal height 50 if length of text is < 16 height = 65
                width: width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "${fetchedProfileData["education"]}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _workTitle(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? work title text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "Work",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              ProfileIcons.work,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("Pressed work title");
                workTitlePopupBottomSheet(context, yellow);
              },
              child: Container(
                height: fetchedProfileData["work"].length >= 16
                    ? 65
                    : 50, // normal height 50 if length of text is < 16 height = 65
                width: width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "${fetchedProfileData["work"]}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _height(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? height text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "Height",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              ProfileIcons.height,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("Pressed height");
                heightPopUpBottomSheet(yellow, fetchedProfileData, context);
              },
              child: Container(
                height: 50,
                width: width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    fetchedProfileData["height"].isEmpty
                        ? ""
                        : "${fetchedProfileData["height"]} ft",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _exercise(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? height text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "Exercise",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              ProfileIcons.exercise,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("Pressed exercise");
                exercisePopUpBottomSheet(yellow, context);
              },
              child: Container(
                height: 50,
                width: width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "${fetchedProfileData["exercise"]}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _smoking(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? smoking text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "Smoking",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              ProfileIcons.smoking,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("Pressed smoking");
                smokingPopUpBottomSheet(yellow, context);
              },
              child: Container(
                height: 50,
                width: width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "${fetchedProfileData["smoking"]}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _drinking(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? drinking text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "Drinking",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              ProfileIcons.drinking,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("Pressed drinking");
                drinkingPopUpBottomSheet(yellow, context);
              },
              child: Container(
                height: 50,
                width: width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "${fetchedProfileData["drinking"]}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _lookingFor(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? looking for text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "Looking For",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              ProfileIcons.looking_for,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("pressed looking for");
                lookingForPopUpBottomSheet(yellow, context);
              },
              child: Container(
                height: 50,
                width: width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "${fetchedProfileData["looking_for"]}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _from(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? from text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "From",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("Pressed from");
                fromPopUpBottomSheet(context, yellow);
              },
              child: Container(
                // ? about me textinput field
                height: fetchedProfileData["from.city"].isEmpty &&
                        fetchedProfileData["from.state"].isEmpty &&
                        fetchedProfileData["from.country"].isEmpty
                    ? 50
                    : 90, // normal height 50 , when city , state , country filled -> 90
                width: width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "${fetchedProfileData["from.city"]}\n${fetchedProfileData["from.state"]}\n${fetchedProfileData["from.country"]}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _kids(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? height text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "Kids",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              ProfileIcons.kids,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("Pressed kids");
                kidsPopUpBottomSheet(yellow, context);
              },
              child: Container(
                height: fetchedProfileData["kids"].length >= 17
                    ? 65
                    : 50, // normal height 50 if length of text is < 16 height = 65
                width: fetchedProfileData["kids"].length >= 17
                    ? width / 2 + 5
                    : width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: fetchedProfileData["kids"].length >= 17
                      ? const EdgeInsets.only(left: 4)
                      : const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "${fetchedProfileData["kids"]}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _zodiacSign(Color yellow, BuildContext context, Color iconColor,
    double iconSize, dynamic fetchedProfileData) {
  final double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        // ? zodiac sign text
        margin: const EdgeInsets.only(top: 25, left: 25),
        alignment: Alignment.topLeft,
        child: const Text(
          "Zodiac Signs",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 25, bottom: 25),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(
              ProfileIcons.zodiac_signs,
              color: iconColor,
              size: iconSize,
            ),
            GestureDetector(
              onTap: () {
                print("Pressed zodiac signs");
                zodiacSignsPopUpBottomSheet(yellow, context);
              },
              child: Container(
                height: 50,
                width: width / 2,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: yellow, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "${fetchedProfileData["zodiac_signs"]}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
