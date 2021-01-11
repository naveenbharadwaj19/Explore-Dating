import 'package:explore/data/auth_data.dart';
import 'package:explore/models/email_model.dart';
import 'package:explore/models/firestore_signup.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pinput/pin_put/pin_put.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const routeName = "email-page";

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _storeFourDigits = TextEditingController();
  final String _animationName = "SearchEmail";
  CountDownController _controller = CountDownController();
  bool isLoading = false;

  void loadingOn() {
    setState(() {
      isLoading = true;
    });
  }

  void loadingOff() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _storeFourDigits.dispose();
  }

  @override
  // ? Check setstate disposed properly
  void setState(fn) {
    // ignore: todo
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xff121212),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                child: FlareActor(
                  "assets/animations/SearchEmail.flr",
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  animation: _animationName,
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  // ! Fetch from database for emailaddress or add some other logic
                  emailAddressM == null ? "Verification code has been sent to your email" :
                  "Verification code has been sent to your email : $emailAddressM",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              PinPut(
                // ? pinput field
                controller: _storeFourDigits,
                fieldsCount: 4,
                inputDecoration: InputDecoration(
                    errorStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                followingFieldDecoration: BoxDecoration(
                    color: Color(0xffF8C80D),
                    borderRadius: BorderRadius.circular(5)),
                selectedFieldDecoration: BoxDecoration(
                    color: Color(0xffF8C80D),
                    borderRadius: BorderRadius.circular(5)),
                submittedFieldDecoration: BoxDecoration(
                    color: Color(0xffF8C80D),
                    borderRadius: BorderRadius.circular(5)),
                disabledDecoration: BoxDecoration(
                    color: Color(0xffF8C80D),
                    borderRadius: BorderRadius.circular(5)),
                fieldsAlignment: MainAxisAlignment.spaceEvenly,
                pinAnimationType: PinAnimationType.rotation,
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  // fontWeight: FontWeight.w500,
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Enter code";
                  } else if (value.length != storeGeneratedCode.length ||
                      !value.contains(storeGeneratedCode)) {
                    return "Enter valid code";
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.center,
                  child: CircularCountDownTimer(
                    // ? countdown timer
                    controller: _controller,
                    width: 90,
                    height: 100,
                    duration: 120,
                    fillColor: Color(0xffF8C80D),
                    color: Color(0xff121212),
                    backgroundColor: Color(0xff121212),
                    strokeWidth: 3,
                    isReverse: true,
                    isReverseAnimation: true,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    onComplete: () {
                      print("2 mins over code expired");
                      storeGeneratedCode = "";
                    },
                  ),
                ),
              ),
              FlatButton(
                child: Text(
                  "Send code again",
                  style: TextStyle(
                      color: Color(0xffF8C80D),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  // ! change email address to user email address while deployment
                  // ! when user close the app .While on this screen there might be no emailaddress on the menory so fix it while deployment
                  sendMail(
                      "claw2020@gmail.com", generateFourDigitCode());
                  _controller.restart(duration: 120);
                  _storeFourDigits.clear();
                },
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: 200,
                child: isLoading == true
                    ? SpinKitCubeGrid(
                        color: Colors.white,
                        size: 40,
                      )
                    : RaisedButton(
                          color: Color(0xffF8C80D),
                          textColor: Color(0xff121212),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Color(0xffF8C80D))),
                          child: Text(
                            "Verify",
                            style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.w600,
                                ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              print("Verified...");
                              OnlyDuringSignupFirestore.updateEmailAddress(
                                  loadingOn, loadingOff, context);
                            }
                          },
                        ),
                      ),
              Spacer(),
              Align(
                alignment: Alignment.bottomLeft,
                child: FlatButton(
                  child: Text(
                    "Back",
                    style: TextStyle(
                        color: Color(0xffF8C80D),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline),
                  ),
                  onPressed: () =>
                      _showAlertDialog(context, loadingOn, loadingOff),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_showAlertDialog(
    BuildContext context, Function loadingOn, Function loadingOff) {
  Widget goBack = FlatButton(
    child: Text(
      "Go Back",
      style: TextStyle(color: Colors.white),
    ),
    onPressed: () {
      // ? restting all values stored in memory
      nameM = "";
      emailAddressM = "";
      userNameM = "";
      passwordM = "";
      dobM = "";
      manageSigninLogin = false;
      FirebaseAuth.instance.currentUser.delete();
      print("User auth account deleted !");
      Navigator.pop(context);
      // ! try to change to future delay if it leads to any app performance issue
      // sleep(Duration(seconds:3));
      // deleteUserDuringSignUpProcess(context);
    },
  );
  Widget stayHere = FlatButton(
    child: Text(
      "Stay Here",
      style: TextStyle(color: Colors.white),
    ),
    onPressed: () => Navigator.pop(context),
  );
  Widget help = FlatButton(
    child: Text(
      "Help",
      style: TextStyle(color: Colors.white),
    ),
    onPressed: () {},
  );

  AlertDialog showAlert = AlertDialog(
    backgroundColor: Color(0xff121212),
    title: Text(
      "Alert",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    content: Text(
      "Are you sure want to go back ?",
      style: TextStyle(color: Colors.white),
    ),
    actions: [help, stayHere, goBack],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return showAlert;
      });
}
