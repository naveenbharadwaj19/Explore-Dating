import 'package:Explore/models/firestore_signup.dart';
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
              margin: EdgeInsets.only(top: 40),
              child: Text(
                "-Choose your gender-",
                style: TextStyle(color: Color(0xffF8C80D), fontSize: 25),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            GenderSelection(
              maleText: "Male",
              femaleText: "Female",
              maleImage: AssetImage("assets/app_images/male.png"),
              femaleImage: AssetImage("assets/app_images/female.png"),
              selectedGenderTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
              unSelectedGenderTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
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
                  print("Selected : Male");
                  selectedGender = "Male";
                  // OnlyDuringSignupFirestore.updateGenderPage("Male", context);
                } else if (gender.toString() == Gender.Female.toString()) {
                  print("Selected : Female");
                  selectedGender = "Female";
                  // OnlyDuringSignupFirestore.updateGenderPage("Female", context);
                }
              },
            ),
            Spacer(),
            Container(
              alignment: Alignment.center,
              // margin: EdgeInsets.only(top: 50),
              child: RaisedButton(
                color: Color(0xffF8C80D),
                textColor: Color(0xff121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: BorderSide(color: Color(0xffF8C80D))),
                child: Text(
                  "Other",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                onPressed: () => OnlyDuringSignupFirestore.pressedOtherGender(context),
              ),
            ),
            Spacer(),
            RaisedButton(
                color: Color(0xffF8C80D),
                textColor: Color(0xff121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: BorderSide(color: Color(0xffF8C80D))),
                child: Text(
                  "Confirm",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                onPressed: () => OnlyDuringSignupFirestore.updateGenderPage(selectedGender, context),
              ),
            Spacer(),
            Text(
              "Note : Once selected cannot be reversed",
              style: TextStyle(fontSize: 15, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class OtherGenderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Other gender page",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
