// @dart=2.9
import 'package:another_flushbar/flushbar.dart';
import 'package:explore/data/temp/auth_data.dart';
import 'package:explore/models/auth.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

Widget logoAppName(Image logoImage) {
  return Row(
    // ? logo and text
    children: [
      Container(
        child: logoImage,
      ),
      RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          children: [
            TextSpan(text: "Explore\n",style: const TextStyle(color:Colors.white,fontSize: 40,fontFamily: "Domine",decoration: TextDecoration.none),),
            TextSpan(text: "Dating",style: const TextStyle(color:Colors.white,fontSize: 16,fontFamily: "Domine",decoration: TextDecoration.none),),
          ]
        ),
      ),
    ],
  );
}

Widget nameTextField(TextEditingController _name) {
  // ? name
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 60,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: _name,
        inputFormatters: [LengthLimitingTextInputFormatter(20)],
        textCapitalization: TextCapitalization.words,
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        // ! Need to use input text as WORDSANS
        style: const TextStyle(color: Colors.white),
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
          hintText: "Name",
          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return "Enter Name";
          } else if (value.length > 20) {
            return "Cannot Be More Than 20 Characters";
          }
          return null;
        },
      ),
    ),
  );
}

Widget emailTextField(TextEditingController _email) {
  // ? Email address
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 60,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: _email,
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        // ! Need to use input text as WORDSANS
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
          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
        ),
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

// Widget userNameTextField(TextEditingController _username) {
//   return Align(
//     alignment: Alignment(-0.3, 0.0),
//     child: Container(
//       height: 60,
//       width: 300,
//       // ! Need to use mediaquery to fix the width to avoid pixel overflow
//       margin: const EdgeInsets.only(top: 30),
//       child: TextFormField(
//         controller: _username,
//         inputFormatters: [LengthLimitingTextInputFormatter(30)],
//         enabled: true,
//         cursorColor: Colors.white,
//         cursorWidth: 3.0,
//         // ! Need to use input text as WORDSANS
//         style: const TextStyle(color: Colors.white),
//         keyboardType: TextInputType.emailAddress,
//         decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           hintText: "User Name",
//           hintstyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
//         ),
//         validator: (String value) {
//           // ! Need to check database whether username is available or not
//           if (value.isEmpty) {
//             return "Enter Some Text";
//           }
//           if (value.contains(" ")) {
//             return "Cannot Use Space";
//           } else if (value.length < 4) {
//             return "Enter Above 4 Characters";
//           } else if (value.length > 15) {
//             return "Cannot Be More Than 12 Characters";
//           }
//           return null;
//         },
//       ),
//     ),
//   );
// }

Widget passwordTextField(bool _passwordvisible, Function _toggle,
    TextEditingController _password, TextEditingController _confirmPassword) {
  // ? password
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 60,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: _password,
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        obscureText: !_passwordvisible,
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        // ! Need to use input text as WORDSANS
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
            return "Enter Password";
          } else if (value.length < 6) {
            return "Enter Above 6 Characters";
          } else if (_confirmPassword.text != value) {
            return "Password Does not Match";
          }
          return null;
        },
      ),
    ),
  );
}

Widget confirmPasswordTextField(bool _passwordvisible, Function _toggle,
    TextEditingController _confirmPassword, TextEditingController _password) {
  // ? password
  return Align(
    alignment: Alignment(-0.3, 0.0),
    child: Container(
      height: 60,
      width: 300,
      // ! Need to use mediaquery to fix the width to avoid pixel overflow
      margin: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: _confirmPassword,
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        obscureText: !_passwordvisible,
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        // ! Need to use input text as WORDSANS
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
          hintText: "Confirm Password",
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
            return "Enter Confirm Password";
          } else if (value.length < 6) {
            return "Enter Above 6 Characters";
          } else if (_password.text != value) {
            return "Password Does Not Match";
          }
          return null;
        },
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

  int getAbove18Year(){
    var now = new DateTime.now();
    String yearFormatter = DateFormat("y").format(now);
    int currentYear = int.parse(yearFormatter);
    int above18Year = currentYear - 18;
    return above18Year;
  }
  

  String formattedDate() {
    return DateFormat("dd/MM/yyyy").format(today).toString();
  }

  int _findAge() {
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
      lastDate:  DateTime(getAbove18Year(),today.month,today.day),
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
        dobM = formattedDate();
        ageM = _findAge();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      child: Align(
        alignment: Alignment(-0.3, 0.0),
        child: Container(
          margin: const EdgeInsets.only(top: 25),
          height: 60,
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
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                color: Color(0xffF8C80D),
                textColor: Color(0xff121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: BorderSide(color: Color(0xffF8C80D))),
                child: Text(
                  _findAge() < 18 ? "Enter age 18+" : formattedDate(),
                  style: const TextStyle(fontSize: 16
                      // fontWeight: FontWeight.w700
                      ),
                ),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget ageCondition(bool agreeAge, Function toogleAge) {
  return Container(
    margin: const EdgeInsets.only(top: 15, left: 25),
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
          child: Text(
            "I agree i'm above 18",
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        )
      ],
    ),
  );
}

Widget termsAndConditions(bool tAndC, Function toogleTerms) {
  return Container(
    margin: const EdgeInsets.only(top: 5, left: 25),
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
         // ignore: deprecated_member_use
        FlatButton(
            child: Text(
              "I agree to the terms and conditions",
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline),
            ),
            onPressed: () {
              // todo navigate to terms and conditions when pressed
            }),
      ],
    ),
  );
}

Widget nextButton(
    {@required GlobalKey<FormState> formKey,
    @required bool agreeAge,
    @required bool agreeTerms,
    @required TextEditingController emailAddress,
    @required TextEditingController password,
    @required Function loadingOn,
    @required Function loadingOff,
    @required bool isLoading,
    @required BuildContext context,
    @required TextEditingController name,}) {
  final cubeGrid = SpinKitCubeGrid(
    color: Colors.white,
    size: 40,
  );
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 25),
    child: isLoading == true
        ? cubeGrid
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
                "Next",
                style: const TextStyle(
                  // fontFamily: "OpenSans",
                  // fontWeight: FontWeight.w700,
                  fontSize: 16
                ),
              ),
              onPressed: () {
                if (formKey.currentState.validate() &&
                    agreeAge == true &&
                    agreeTerms == true) {
                  if (dobM == null || dobM.isEmpty) {
                    return Flushbar(
                      backgroundColor: Color(0xff121212),
                      messageText: Text(
                        "Enter birth date",
                        style: const TextStyle(
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      duration: Duration(seconds: 3),
                    )..show(context);
                  }
                  print("Validation passed for signup");
                  // * storing in memory
                  nameM = name.text;
                  emailAddressM = emailAddress.text;
                  passwordM = password.text;
                  // Navigator.pushNamed(context, EmailVerificationScreen.routeName);
                  AuthenticationFirebase.signInUser(
                      emailAddress: emailAddressM,
                      password: passwordM,
                      loadingOn: loadingOn,
                      loadingOff: loadingOff,
                      ctx: context);
                }
              },
            ),
        ),
  );
}

Widget navigateToLoginPage(BuildContext context, Function pressedLogin) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            "Already have an account ?",
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
           // ignore: deprecated_member_use
          child: FlatButton(
            child: Text(
              "Login",
              style: const TextStyle(
                  color: Color(0xffF8C80D),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline),
            ),
            onPressed: () {
              pressedLogin();
            },
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
      icon: const Icon(Icons.help_outline_sharp),
      color: Colors.white,
      iconSize: 27,
      onPressed: () {},
      tooltip: "Help",
    ),
  );
}
