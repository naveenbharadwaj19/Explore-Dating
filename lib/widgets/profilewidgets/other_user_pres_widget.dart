// @dart=2.9
// todo : Widgets of other user prespective
import 'package:auto_size_text/auto_size_text.dart';
import 'package:explore/icons/profile_icons_icons.dart';
import 'package:flutter/material.dart';

Widget oUPSAboutMe(dynamic aboutMeData, BuildContext context) {
  return SliverToBoxAdapter(
    child: aboutMeData["about_me"].isEmpty
        ? Container()
        : Column(
            children: [
              OtherUserPrespectiveScreenTitles.aboutMeTitle(),
              Container(
                // ? about me text
                height: aboutMeData["about_me"].length >= 20 ? null : 150,
                margin: const EdgeInsets.only(top: 15, left: 20, right: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).buttonColor, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
                  child: AutoSizeText(
                    "${aboutMeData["about_me"]}",
                    minFontSize: 18,
                    maxFontSize: 18,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
  );
}

Widget oUPSMyInterest(dynamic aboutMeData, BuildContext context) {
  return aboutMeData["my_interests"].isEmpty
      ? SliverToBoxAdapter(child: Container())
      : SliverPadding(
          padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 25,
            childAspectRatio: 3.3,
            children: List.generate(
              aboutMeData["my_interests"].length,
              (index) => Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).buttonColor, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 3, left: 10),
                      child: Icon(
                        IconData(
                            aboutMeData["my_interests"][index]
                                ["icon_codepoint"],
                            fontFamily: "ProfileMyInterestsIcons"),
                        color: Colors.white54,
                        size: 35,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: AutoSizeText(
                          "${aboutMeData["my_interests"][index]["name"]}",
                          minFontSize: 16,
                          maxFontSize: 18,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
}

Widget oUPSWarp1(dynamic aboutMeData, BuildContext context) {
  List wrap1() {
    List<Map> toRemove = [];
    List wrap1Data = [
      {
        "icon": ProfileIcons.education_level,
        "data": aboutMeData["education_level"],
      },
      {
        "icon": ProfileIcons.education,
        "data": aboutMeData["education"],
      },
      {
        "icon": ProfileIcons.work,
        "data": aboutMeData["work"],
      },
    ];
    // remove unfilled data
    wrap1Data.forEach((element) {
      if (element["data"].isEmpty) {
        toRemove.add(element);
      }
    });
    wrap1Data.removeWhere((element) => toRemove.contains(element));
    return wrap1Data;
  }

  return wrap1().isEmpty
      ? SliverToBoxAdapter(child: Container())
      : SliverPadding(
          padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 25,
            childAspectRatio: 3.3,
            children: List.generate(
              wrap1().length,
              (index) => Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).buttonColor, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 3, left: 10),
                      child: Icon(
                        wrap1()[index]["icon"],
                        color: Colors.white54,
                        size: 35,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: AutoSizeText(
                          "${wrap1()[index]["data"]}",
                          minFontSize: 16,
                          maxFontSize: 18,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
}

class OUPSWrap2 extends StatelessWidget {
  final dynamic aboutMeData;
  OUPSWrap2(this.aboutMeData);

  List wrap2() {
    List<Map> toRemove = [];
    List wrap2Data = [
      {
        "icon": ProfileIcons.height,
        "data": aboutMeData["height"],
      },
      {
        "icon": ProfileIcons.exercise,
        "data": aboutMeData["exercise"],
      },
      {
        "icon": ProfileIcons.smoking,
        "data": aboutMeData["smoking"],
      },
      {
        "icon": ProfileIcons.drinking,
        "data": aboutMeData["drinking"],
      },
      {
        "icon": ProfileIcons.looking_for,
        "data": aboutMeData["looking_for"],
      },
      {
        "icon": ProfileIcons.kids,
        "data": aboutMeData["kids"],
      },
      {
        "icon": ProfileIcons.zodiac_signs,
        "data": aboutMeData["zodiac_signs"],
      },
    ];
    // remove unfilled data
    wrap2Data.forEach((element) {
      if (element["data"].isEmpty) {
        toRemove.add(element);
      }
    });
    wrap2Data.removeWhere((element) => toRemove.contains(element));
    return wrap2Data;
  }

  @override
  Widget build(BuildContext context) {
    return wrap2().isEmpty
        ? SliverToBoxAdapter(child: Container())
        : SliverPadding(
            padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 25,
              childAspectRatio: 3.3,
              children: List.generate(
                wrap2().length,
                (index) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).buttonColor, width: 2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 3, left: 10),
                        child: Icon(
                          wrap2()[index]["icon"],
                          color: Colors.white54,
                          size: 35,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: AutoSizeText(
                            "${wrap2()[index]["data"]}",
                            minFontSize: 16,
                            maxFontSize: 18,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

Widget oUPSFrom(dynamic aboutMeData, BuildContext context) {
  final double width = MediaQuery.of(context).size.width;
  return SliverToBoxAdapter(
    child: aboutMeData["from.city"].isEmpty ||
            aboutMeData["from.state"].isEmpty ||
            aboutMeData["from.country"].isEmpty
        ? Container()
        : Container(
            margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
            width: width / 2,
            child: Row(
              children: [
                OtherUserPrespectiveScreenTitles.fromTitle(),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      "${aboutMeData["from.city"]}\n${aboutMeData["from.state"]}\n${aboutMeData["from.country"]}",
                      minFontSize: 18,
                      maxFontSize: 18,
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
  );
}

class OtherUserPrespectiveScreenTitles {
  static Widget aboutMeTitle() {
    return Container(
      // ? about me title
      margin: const EdgeInsets.only(top: 30, left: 35),
      alignment: Alignment.centerLeft,
      child: const Text(
        "About me",
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
    );
  }

  static Widget myInterestsTitle(dynamic aboutMeData) {
    return SliverToBoxAdapter(
      // ? my interests title
      child: aboutMeData["my_interests"].isEmpty
          ? Container()
          : Container(
              margin: const EdgeInsets.only(top: 30, left: 35),
              alignment: Alignment.centerLeft,
              child: const Text(
                "My interests",
                overflow: TextOverflow.fade,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
    );
  }

  static Widget myBasicInfoTitle(dynamic aboutMeData) {
    bool checkTitleStatus() {
      // if all fields are null disable title
      bool status = false;
      if (aboutMeData["education_level"].isEmpty &&
          aboutMeData["education"].isEmpty &&
          aboutMeData["work"].isEmpty &&
          aboutMeData["exercise"].isEmpty &&
          aboutMeData["smoking"].isEmpty &&
          aboutMeData["drinking"].isEmpty &&
          aboutMeData["height"].isEmpty &&
          aboutMeData["looking_for"].isEmpty &&
          aboutMeData["kids"].isEmpty &&
          aboutMeData["zodiac_signs"].isEmpty) {
            status = true;
          }
      return status;
    }

    return SliverToBoxAdapter(
      child: checkTitleStatus() ? Container() : Container(
        margin: const EdgeInsets.only(top: 30, left: 35),
        alignment: Alignment.centerLeft,
        child: const Text(
          "My basic info",
          overflow: TextOverflow.fade,
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      ),
    );
  }

  static Widget albumTitle(dynamic photosData) {
    List photosLst() {
      List photosLst = photosData["photos"];
      int index;
      photosLst.forEach((data) {
        // remove show feeds url and hash from list
        if (data["url"] == photosData["show_on_feeds"]["url"]) {
          int tempIndex = photosLst.indexOf(data);
          index = tempIndex;
        }
      });
      photosLst.removeAt(index);
      return photosLst;
    }

    return SliverToBoxAdapter(
      child: photosLst().isEmpty
          ? Container()
          : Container(
              margin: const EdgeInsets.only(top: 30, left: 35),
              alignment: Alignment.centerLeft,
              child: const Text(
                "My album",
                overflow: TextOverflow.fade,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
    );
  }

  static Widget fromTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10),
      child: const Text(
        "From",
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
    );
  }
}
