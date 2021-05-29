// @dart=2.9
import 'package:explore/models/auth.dart';
import 'package:explore/models/spinner.dart';
import 'package:email_validator/email_validator.dart';
import 'package:explore/providers/sigin_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Widget logoAppName(Image logoImage) {
  return Row(
    // ? logo and text
    children: [
      Container(
        child: logoImage,
      ),
      RichText(
        textAlign: TextAlign.right,
        text: TextSpan(children: [
          const TextSpan(
            text: "Explore\n",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontFamily: "Domine",
                decoration: TextDecoration.none),
          ),
          const TextSpan(
            text: "Dating",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "Domine",
                decoration: TextDecoration.none),
          ),
        ]),
      ),
    ],
  );
}

Widget addDatingText() {
  return Container(
    // alignment: Alignment.topCenter,
    // margin: const EdgeInsets.only(left: 200),
    child: Text(
      "Dating",
      style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Domine"),
    ),
  );
}

Widget greetText() {
  return Align(
    // ? catch text
    alignment: Alignment(-0.7, 0.0),
    child: Text(
      "Hi There,",
      style: const TextStyle(
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
    alignment: Alignment(-0.6, 0.0),
    child: Text(
      "Ready to Explore?",
      style: const TextStyle(
          // fontFamily: "OpenSans",
          fontSize: 25,
          color: Colors.white,
          // fontWeight: FontWeight.w500,
          decoration: TextDecoration.none),
    ),
  );
}

Widget emailTextField(TextEditingController emailAddress) {
  // ? Email address
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 60,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: emailAddress,
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        // ! change input letters to WORDSANS
        style: const TextStyle(color: Colors.white),
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

Widget passwordTextField(
    bool _passwordvisible, Function _toggle, TextEditingController password) {
  // ? password
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 60,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: password,
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        obscureText: !_passwordvisible,
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        // ! change input letters to WORDSANS
        style: const TextStyle(color: Colors.white),
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
          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
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

Widget forgotPassword(GlobalKey<FormState> formKey,
    TextEditingController emailAddress, BuildContext context) {
  return Align(
    alignment: Alignment(0.5, 0.0),
     // ignore: deprecated_member_use
    child: FlatButton(
      child: Text(
        "Forgot password ?",
        style: const TextStyle(
          color: Color(0xffF8C80D),
          // fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: () {
        if (formKey.currentState.validate()) {
          AuthenticationFirebase.resetPassword(emailAddress, context);
        }
      },
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
        : Container(
            width: 125,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: Color(0xffF8C80D),
              textColor: Color(0xff121212),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color(0xffF8C80D))),
              child: Text(
                "Login",
                style: const TextStyle(
                    fontFamily: "Nunito",
                    // fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  print("Validation passed for login");
                  AuthenticationFirebase.loginUser(
                      emailAddress: emailAddress,
                      password: password,
                      loadingOn: loadingOn,
                      loadingOff: loadingOff,
                      ctx: context);
                }
              },
            ),
          ),
  );
}

Widget navigateToSignUpPage(BuildContext context, Function pressedSignin) {
  return ChangeNotifierProvider<ManangeSigninLogin>(
    create: (context) => ManangeSigninLogin(),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Don't have an account ?",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
             // ignore: deprecated_member_use
            child: FlatButton(
              child: Text(
                "SignUp",
                style: const TextStyle(
                    color: Color(0xffF8C80D),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline),
              ),
              onPressed: () {
                pressedSignin();
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget googleSignUp(bool isLoadingGoole, Function loadingOnGoole,
    Function loadingOffGoole, BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: isLoadingGoole == true
        ? loadingSpinner()
         // ignore: deprecated_member_use
        : FlatButton(
            child: SvgPicture.asset(
              "assets/svg/google_icon.svg",
              height: 45,
              fit: BoxFit.cover,
            ),
            onPressed: () => GoogleAuthenticationClass.signinWithGoogle(
                loadingOnGoole, loadingOffGoole, context),
          ),
  );
}

Widget navigateToWebLink() {
  return Container(
    alignment: Alignment.topRight,
    margin: const EdgeInsets.only(top: 20),
    child: IconButton(
      icon: Icon(Icons.language_rounded),
      color: Colors.white,
      iconSize: 27,
      tooltip: "Website",
      onPressed: () {},
    ),
  );
}
