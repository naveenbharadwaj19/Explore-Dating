import 'package:Explore/main.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';

Widget logoAppName() {
  return Row(
    // ? logo and text
    children: [
      Container(
        child: Image.asset(
          "assets/app_images/explore_plain_logo.png",
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
  );
}

Widget fullnameTextField() {
  // ? Full name
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 50,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: "Full Name",
            hintStyle:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.w700)),
      ),
    ),
  );
}

Widget emailTextField() {
  // ? Email address
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 50,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: "Email address",
            hintStyle:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.w700)),
      ),
    ),
  );
}

Widget userName() {
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 50,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: "User Name",
            hintStyle:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.w700)),
      ),
    ),
  );
}

Widget passwordTextField(bool _passwordvisible, Function _toggle) {
  // ? password
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 50,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        obscureText: !_passwordvisible,
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
          suffixIcon: IconButton(
            color: Color(0xffF8C80D),
            icon: Icon(_passwordvisible
                ? Icons.lock_open_rounded
                : Icons.lock_outline_rounded),
            onPressed: _toggle,
          ),
        ),
      ),
    ),
  );
}

Widget confirmPasswordTextField(bool _passwordvisible, Function _toggle) {
  // ? password
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 50,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        obscureText: !_passwordvisible,
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: "Confirm Password",
          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
          suffixIcon: IconButton(
            color: Color(0xffF8C80D),
            icon: Icon(_passwordvisible
                ? Icons.lock_open_rounded
                : Icons.lock_outline_rounded),
            onPressed: _toggle,
          ),
        ),
      ),
    ),
  );
}

class DOB extends StatefulWidget {
  // ? Date of birth
  @override
  _DOBState createState() => _DOBState();
}

class _DOBState extends State<DOB> {
  DateTime today = DateTime.now();

  String formattedDate() {
    return DateFormat("dd/MM/yyyy").format(today).toString();
  }

  _selectDate(BuildContext context) async {
    // ? holo date picker
    final DateTime picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: today,
      firstDate: DateTime(1990),
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
      });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-0.3, 0.0),
      child: Container(
        margin: EdgeInsets.only(top: 25),
        height: 50,
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
                formattedDate(),
                style: TextStyle(
                    fontFamily: "OpenSans", fontWeight: FontWeight.w700),
              ),
              onPressed: () => _selectDate(context),
            ),
          ],
        ),
      ),
    );
  }
}

Widget ageCondition(bool agreeAge,Function toogleAge) {
  return Container(
        margin: EdgeInsets.only(top: 15,left: 20),
          child: Row(
          children: [
            CircularCheckBox(
              // ? circle check box
              value: agreeAge,
              checkColor: Color(0xffF8C80D),
              activeColor: Color(0xff121212),
              inactiveColor: Colors.white,
              onChanged: (val) => toogleAge(),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text("I agree i'm above 18+",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),),
            )
          ],
        ),
      );
}

Widget termsAndConditions(bool tAndC, Function toogleTerms){
  return Container(
      margin: EdgeInsets.only(top: 5,left: 20),
        child: Row(
        children: [
          CircularCheckBox(
            // ? circle check box
            value: tAndC,
            checkColor: Color(0xffF8C80D),
            activeColor: Color(0xff121212),
            inactiveColor: Colors.white,
            onChanged: (val) => toogleTerms(),
          ),
          FlatButton(
            child: Text(
              "I agree to terms and conditions",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline),
            ),
            onPressed: () {}),
        ],
      ),
    );
}

Widget nextButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 25),
    child: RaisedButton(
      color: Color(0xffF8C80D),
      textColor: Color(0xff121212),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: BorderSide(color: Color(0xffF8C80D))),
      child: Text(
        "Next",
        style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w700),
      ),
      onPressed: () {},
    ),
  );
}

Widget navigateToLoginPage(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            "Already have an account ?",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          child: FlatButton(
            child: Text(
              "Login",
              style: TextStyle(
                  color: Color(0xffF8C80D),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline),
            ),
            onPressed: () => Navigator.pushReplacementNamed(
                context, WelcomeLoginScreen.routeName),
          ),
        ),
      ],
    ),
  );
}

Widget helpGuide() {
  return Align(
    alignment: Alignment.bottomLeft,
    child: IconButton(
      icon: Icon(Icons.help_outline_sharp),
      color: Colors.white,
      iconSize: 27,
      onPressed: () {},
      tooltip: "Help",
    ),
  );
}