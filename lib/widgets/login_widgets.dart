import 'package:Explore/models/auth.dart';
import 'package:Explore/screens/signup_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

Widget greetText() {
  return Align(
    // ? catch text
    alignment: Alignment(-0.7, 0.0),
    child: Text(
      "Hi There,",
      style: TextStyle(
          fontFamily: "Domine",
          fontSize: 30,
          color: Colors.white,
          decoration: TextDecoration.none),
    ),
  );
}

Widget catchyText() {
  return Align(
    // ? catch text
    alignment: Alignment(-0.57, 0.0),
    child: Text(
      "Ready to Explore ?",
      style: TextStyle(
          fontFamily: "OpenSans",
          fontSize: 25,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none),
    ),
  );
}

Widget emailTextField(TextEditingController emailAddress) {
  // ? Email address
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 50,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: emailAddress,
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
        validator: (String value) {
          if (value.isEmpty) {
            return "Enter Email Address";
          } else if (!EmailValidator.validate(value)) {
            return "Enter Valid Email Address";
          }
          return null;
        },
      ),
    ),
  );
}

Widget passwordTextField(bool _passwordvisible, Function _toggle,TextEditingController password) {
  // ? password
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 50,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: password,
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
        validator: (String value) {
          if (value.isEmpty) {
            return "Enter Some Text";
          } else if (value.length < 6) {
            return "Enter Above 6 Characters";
          }
          return null;
        },
      ),
    ),
  );
}

Widget loginButton(
    {@required GlobalKey<FormState> formKey,
    @required TextEditingController emailAddress,
    @required TextEditingController password,
    @required Function loadingOn,
    @required Function loadingOff,
    @required bool isloading,
    @required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 25),
    child: isloading == true
        ? SpinKitCubeGrid(
            color: Colors.white,
            size: 40,
          )
        : RaisedButton(
            color: Color(0xffF8C80D),
            textColor: Color(0xff121212),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: BorderSide(color: Color(0xffF8C80D))),
            child: Text(
              "Login",
              style: TextStyle(
                  fontFamily: "OpenSans", fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              if (formKey.currentState.validate()) {
                print("Successful login");
                FocusScope.of(context).unfocus();
                AuthenticationFirebase.loginUser(emailAddress: emailAddress, password: password, loadingOn: loadingOn, loadingOff: loadingOff, ctx: context);
              }
            },
          ),
  );
}

Widget navigateToSignUpPage(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            "Don't have an account ?",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          child: FlatButton(
            child: Text(
              "SignUp",
              style: TextStyle(
                  color: Color(0xffF8C80D),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline),
            ),
            onPressed: () =>
                Navigator.pushNamed(context, SignUpScreen.routeName),
          ),
        ),
      ],
    ),
  );
}

Widget googleSignUp() {
  return Align(
    alignment: Alignment.center,
    child: FlatButton(
      child: SvgPicture.asset(
        "lib/icons/google_icon.svg",
        height: 45,
        fit: BoxFit.cover,
      ),
      onPressed: () {},
    ),
  );
}

Widget navigateToWebLink() {
  return Align(
    alignment: Alignment.bottomLeft,
    child: IconButton(
      icon: Icon(Icons.language_rounded),
      color: Colors.white,
      iconSize: 27,
      tooltip: "Website",
      onPressed: () {},
    ),
  );
}
