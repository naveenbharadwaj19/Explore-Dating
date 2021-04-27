// @dart=2.9
// todo : my interests in about widgets

import 'package:auto_size_text/auto_size_text.dart';
import 'package:explore/data/my_interests_data.dart';
import 'package:explore/serverless/profile_backend/abt_me_backend.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future myInterestsPopUpBottomSheet(Color yellow, BuildContext context) {
  return showBarModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      builder: (context) => MyInterestsPopUp(yellow));
}

class MyInterestsPopUp extends StatefulWidget {
  final Color yellow;
  MyInterestsPopUp(this.yellow);
  @override
  _MyInterestsPopUpState createState() => _MyInterestsPopUpState();
}

class _MyInterestsPopUpState extends State<MyInterestsPopUp> {
  List selectedInterests = [];
  int indexState = 0;
  void updateButton(idx) {
    setState(() {
      indexState = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      color: Theme.of(context).primaryColor,
      height: height - 70,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.topCenter,
                  child: const Text(
                    "Choose Your Interests",
                    overflow: TextOverflow.fade,
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
                  // ? how much interests left -> text
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(top: 10, right: 20, bottom: 10),
                  child: Text(
                    "$timesInterestsClicked/6",
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          // ? place interests title and sliver grid here
          // can only use slivers
          _categoryTitle("Pets"),
          _interestsData(MyInterestsData.pets, widget.yellow, selectedInterests,
              updateButton, context), // pets
          _categoryTitle("Creativity"),
          _interestsData(MyInterestsData.creativity, widget.yellow,
              selectedInterests, updateButton, context), // creativity
          _categoryTitle("Sports"),
          _interestsData(MyInterestsData.sports, widget.yellow,
              selectedInterests, updateButton, context), // sports
          _categoryTitle("Hangouts"),
          _interestsData(MyInterestsData.hangouts, widget.yellow,
              selectedInterests, updateButton, context), // hanouts
          _categoryTitle("Staying in"),
          _interestsData(MyInterestsData.stayingIn, widget.yellow,
              selectedInterests, updateButton, context), // staying in
          _categoryTitle("Film & Tv"),
          _interestsData(MyInterestsData.filmTv, widget.yellow,
              selectedInterests, updateButton, context), // film & tv
          _categoryTitle("Reading"),
          _interestsData(MyInterestsData.reading, widget.yellow,
              selectedInterests, updateButton, context), // reading
          _categoryTitle("Musics"),
          _interestsData(MyInterestsData.musics, widget.yellow,
              selectedInterests, updateButton, context), // musics
          _categoryTitle("Food & Drinks"),
          _interestsData(MyInterestsData.foodDrink, widget.yellow,
              selectedInterests, updateButton, context), // foodDrink
          _categoryTitle("Travelling"),
          _interestsData(MyInterestsData.travelling, widget.yellow,
              selectedInterests, updateButton, context), // travelling
          _categoryTitle("Value & Traits"),
          _interestsData(MyInterestsData.valueTraits, widget.yellow,
              selectedInterests, updateButton, context), // valueTraits
          const SliverToBoxAdapter(
            child: const Divider(
              color: Colors.white54,
            ),
          ),
          _laterSaveButton(selectedInterests, context),
        ],
      ),
    );
  }
}

Widget _categoryTitle(String categoryName) {
  return SliverToBoxAdapter(
    // ? categories title
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            categoryName,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Divider(
          color: Colors.white54,
        ),
      ],
    ),
  );
}

Widget _interestsData(List<Map<String, dynamic>> interestsData, Color yellow,
    List selectedInterests, Function updateButton, BuildContext context) {
  // ? categories datas
  return SliverGrid.count(
    crossAxisCount: 2,
    mainAxisSpacing: 7,
    crossAxisSpacing: 3,
    childAspectRatio: 3,
    children: List.generate(
      interestsData.length,
      (index) => GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            color: interestsData[index]["is_selected"]
                ? Color(0xffF8C80D)
                : Color(0xff121212),
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
                  interestsData[index]["icon"],
                  color: interestsData[index]["is_selected"]
                      ? Color(0xff121212)
                      : Colors.white70, // 70 % opacity
                  size: 35,
                ),
              ),
              Expanded(
                // ? names
                child: Container(
                  margin: const EdgeInsets.only(left: 5, right: 3, top: 5),
                  child: AutoSizeText(
                    "${interestsData[index]["name"]}",
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    minFontSize: 16,
                    maxFontSize: 18,
                    style: TextStyle(
                      color: interestsData[index]["is_selected"]
                          ? Color(0xff121212)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          if (timesInterestsClicked != 6 &&
              !interestsData[index]["is_selected"]) {
            // update the button color and save the selected interests
            selectedInterests.add({
              "icon_codepoint": interestsData[index]["icon"].codePoint,
              "name": interestsData[index]["name"]
            });
            print(interestsData[index]["name"]);
            interestsData[index]["is_selected"] = true;
            timesInterestsClicked += 1;
            updateButton(index);
          } else if (interestsData[index]["is_selected"]) {
            // unselect and select new interests
            int idx1;
            // get the unselected index and delete
            selectedInterests.forEach((element) {
              if (element["name"] == interestsData[index]["name"]) {
                var idx = selectedInterests.indexOf(element);
                idx1 = idx;
              }
            });
            if (idx1 != null) {
              selectedInterests.removeAt(idx1);
              print("Removed : ${interestsData[index]["name"]}");
              interestsData[index]["is_selected"] = false;
              timesInterestsClicked -= 1;
              updateButton(index);
            }
          }
          // print(selectedInterests);
        },
      ),
    ),
  );
}

Widget _laterSaveButton(List selectedInterests, BuildContext context) {
  return SliverToBoxAdapter(
    child: Container(
      // ? later and save button
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Container(
            // ? later button
            margin: const EdgeInsets.only(bottom: 20, left: 25),
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
                if (selectedInterests.isNotEmpty) {
                  ProfileAboutMeBackEnd.myInterests(selectedInterests);
                }
                // loop each categories and set is_selected to false
                MyInterestsData.pets.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                MyInterestsData.creativity.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                MyInterestsData.sports.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                MyInterestsData.hangouts.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                MyInterestsData.stayingIn.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                MyInterestsData.filmTv.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                MyInterestsData.reading.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                MyInterestsData.musics.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                MyInterestsData.foodDrink.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                MyInterestsData.travelling.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                MyInterestsData.valueTraits.forEach((element) {
                  if (element["is_selected"] == true) {
                    element["is_selected"] = false;
                  }
                });
                timesInterestsClicked = 0; // reset
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    ),
  );
}
