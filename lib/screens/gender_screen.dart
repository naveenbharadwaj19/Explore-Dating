// @dart=2.9
import 'package:explore/data/temp/auth_data.dart';
import '../serverless/firestore_signup.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gender_selection/gender_selection.dart';

// ignore: must_be_immutable
class GenderScreen extends StatelessWidget {
  static const routeName = "gender-screen";
  String selectedGender = "";
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xff121212),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: const Text(
                "-I am a-",
                style: const TextStyle(color: Color(0xffF8C80D), fontSize: 25),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
            ),
            GenderSelection(
              maleText: "Men",
              femaleText: "Women",
              maleImage: AssetImage("assets/app_images/male.png"),
              femaleImage: AssetImage("assets/app_images/female.png"),
              selectedGenderTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
              unSelectedGenderTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
              size: 150,
              // selectedGenderCheckIcon: maleChoosen ? MaleIcon.male : FemaleIcon.female ,
              selectedGenderIconBackgroundColor: Color(0xffF8C80D),
              selectedGenderIconColor: Colors.black,
              selectedGenderIconSize: 20,
              isCircular: true,
              linearGradient: LinearGradient(
                  colors: [Color(0xffF8C80D), Color(0xffF8C80D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              opacityOfGradient: 0.3,
              onChanged: (gender) {
                if (gender.toString() == Gender.Male.toString()) {
                  print("Selected : Men");
                  selectedGender = "Men";
                  selectedGenderM = selectedGender;
                  // OnlyDuringSignupFirestore.updateGenderPage("Male", context);
                } else if (gender.toString() == Gender.Female.toString()) {
                  print("Selected : Women");
                  selectedGender = "Women";
                  selectedGenderM = selectedGender;
                  // OnlyDuringSignupFirestore.updateGenderPage("Female", context);
                }
              },
            ),
            Spacer(),
            // Container(
            //   alignment: Alignment.center,
            //   // margin: const EdgeInsets.only(top: 50),
            //   child: RaisedButton(
            //     color: Color(0xffF8C80D),
            //     textColor: Color(0xff121212),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(7),
            //         side: BorderSide(color: Color(0xffF8C80D))),
            //     child: const Text(
            //       "Other",
            //       style: const TextStyle(
            //         fontSize: 20,
            //         // fontWeight: FontWeight.w700,
            //       ),
            //     ),
            //     onPressed: () =>
            //         OnlyDuringSignupFirestore.pressedOtherGender(context),
            //   ),
            // ),
            // Spacer(),
            Container(
              width: 180,
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Color(0xffF8C80D),
                textColor: Color(0xff121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xffF8C80D))),
                child: const Text(
                  "Confirm",
                  style: const TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  if (selectedGender.isEmpty) {
                    return Flushbar(
                      messageText: const Text(
                        "Select your gender",
                        style: const TextStyle(
                            // fontFamily: "OpenSans",
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      backgroundColor: Color(0xff121212),
                      duration: Duration(seconds: 2),
                    )..show(context);
                  } else {
                    OnlyDuringSignupFirestore.updateGenderPage(
                        selectedGender, context);
                  }
                },
              ),
            ),
            Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: const Text(
                "Note : Once selected cannot be reversed",
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class OtherGenderScreen extends StatefulWidget {
//   @override
//   _OtherGenderScreenState createState() => _OtherGenderScreenState();
// }

// class _OtherGenderScreenState extends State<OtherGenderScreen> {
//   final double genderTextSize = 17;
//   final double spacing = 30;
//   final double _iconSize = 40;
//   String selectedOtherGender = "";
//   int trackGenderPressed = 0;

//   void updateClickedGenderColor(int assignedGenderNumber) {
//     // * 0 - nothing clicked , 1 - gay , 2 - lesbian , 3 - homo , 4 - bi , 5 - trans
//     setState(() {
//       trackGenderPressed = assignedGenderNumber;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Color(0xff121212),
//       // ? main column for the screen
//       child: Column(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 40),
//             child: const Text(
//               "-Other-",
//               style: const TextStyle(color: Color(0xffF8C80D), fontSize: 25),
//             ),
//           ),
//           // ? spacing between text and genders
//           // * gay , lesbian section
//           Padding(
//             padding: EdgeInsets.all(15),
//           ),
//           Column(
//             children: [
//               Row(
//                 // ? icons - gay , lesbian
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     icon: Icon(OtherGenders.gay),
//                     color: trackGenderPressed == 1
//                         ? Color(0xffF8C80D)
//                         : Colors.white,
//                     iconSize: _iconSize,
//                     splashColor: Color(0xffF8C80D),
//                     onPressed: () {
//                       selectedOtherGender = "Gay";
//                       updateClickedGenderColor(1);
//                       print("Selected gender: Gay");
//                     },
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(left: 30),
//                     child: IconButton(
//                       icon: Icon(OtherGenders.lesbian),
//                       color: trackGenderPressed == 2
//                           ? Color(0xffF8C80D)
//                           : Colors.white,
//                       iconSize: _iconSize,
//                       // ? reason to use splash raidus , padding is to center the icon when pressing
//                       padding: EdgeInsets.only(right: 15),
//                       splashRadius: 45,
//                       splashColor: Color(0xffF8C80D),
//                       onPressed: () {
//                         selectedOtherGender = "Lesbian";
//                         updateClickedGenderColor(2);
//                         print("Selected gender: Lesbian");
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 // ? text section - gay , lesbian
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(top: spacing),
//                     child: const Text(
//                       "Gay",
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: genderTextSize,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: spacing),
//                     child: const Text(
//                       "Lesbian",
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: genderTextSize,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           // ? spacing between text and genders
//           //  * homoe , bisexual section
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 30),
//           ),
//           Column(
//             children: [
//               Row(
//                 // ? icons - homo , bi
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     icon: Icon(OtherGenders.homo),
//                     color: trackGenderPressed == 3
//                         ? Color(0xffF8C80D)
//                         : Colors.white,
//                     iconSize: _iconSize,
//                     // ? reason to use splash raidus , padding is to center the icon when pressing
//                     padding: EdgeInsets.only(right: 15),
//                     splashRadius: 42,
//                     splashColor: Color(0xffF8C80D),
//                     onPressed: () {
//                       selectedOtherGender = "Homosexual";
//                       updateClickedGenderColor(3);
//                       print("Selected gender: Homosexual");
//                     },
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(left: 30),
//                     child: IconButton(
//                       icon: Icon(OtherGenders.bisexual),
//                       color: trackGenderPressed == 4
//                           ? Color(0xffF8C80D)
//                           : Colors.white,
//                       // ? bisexual icon is smaller compare to other genders icon so let the bixseual icon size be 45
//                       iconSize: 45,
//                       splashColor: Color(0xffF8C80D),
//                       onPressed: () {
//                         selectedOtherGender = "Bisexual";
//                         updateClickedGenderColor(4);
//                         print("Selected gender: Bisexual");
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 // ? text section - homo , bi
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(top: spacing),
//                     padding: EdgeInsets.only(left: 25),
//                     child: const Text(
//                       "Homosexual",
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: genderTextSize,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: spacing),
//                     padding: EdgeInsets.only(right: 25),
//                     child: const Text(
//                       "Bisexual",
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: genderTextSize,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Spacer(),
//           Container(
//             alignment: Alignment.center,
//             // margin: const EdgeInsets.only(top: 50),
//             child: RaisedButton(
//               color: Color(0xffF8C80D),
//               textColor: Color(0xff121212),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(7),
//                   side: BorderSide(color: Color(0xffF8C80D))),
//               child: const Text(
//                 "Confirm",
//                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//               ),
//               onPressed: () {
//                 if (selectedOtherGender.isEmpty) {
//                   return Flushbar(
//                     messageText: const Text(
//                       "Select your gender",
//                       style: const TextStyle(
//                           // fontFamily: "OpenSans",
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white),
//                     ),
//                     backgroundColor: Color(0xff121212),
//                     duration: Duration(seconds: 2),
//                   )..show(context);
//                 } else {
//                   OnlyDuringSignupFirestore.updateOtherGender(
//                       selectedOtherGender, context);
//                 }
//               },
//             ),
//           ),
//           Spacer(),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: FlatButton(
//               child: const Text(
//                 "Back",
//                 style: const TextStyle(
//                     color: Color(0xffF8C80D),
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     decoration: TextDecoration.underline),
//               ),
//               onPressed: () =>
//                   OnlyDuringSignupFirestore.backToMaleFemaleGenderPage(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
