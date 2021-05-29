// @dart=2.9
import 'package:explore/data/temp/auth_data.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:explore/server/signup_backend/firestore_signup.dart';
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
                  style: const TextStyle(
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
                textStyle: const TextStyle(
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
                    ringColor: Color(0xff121212),
                    backgroundColor: Color(0xff121212),
                    strokeWidth: 3,
                    isReverse: true,
                    isReverseAnimation: true,
                    textStyle: const TextStyle(
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
              // ignore: deprecated_member_use
              FlatButton(
                child: const Text(
                  "Send code again",
                  style: const TextStyle(
                      color: Color(0xffF8C80D),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  // ! change email address to user email address while deployment
                  // ! when user close the app .While on this screen there might be no emailaddress on the menory so fix it while deployment
                  // sendMail(
                  //     "claw2020@gmail.com", generateFourDigitCode());
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
                    // ignore: deprecated_member_use
                    : RaisedButton(
                          color: Color(0xffF8C80D),
                          textColor: Color(0xff121212),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Color(0xffF8C80D))),
                          child: const Text(
                            "Verify",
                            style: const TextStyle(
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
                 // ignore: deprecated_member_use
                child: FlatButton(
                  child: const Text(
                    "Back",
                    style: const TextStyle(
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
       // ignore: deprecated_member_use
  Widget goBack = FlatButton(
    child: const Text(
      "Go Back",
      style: const TextStyle(color: Colors.white),
    ),
    onPressed: () {
      // ? restting all values stored in memory
      nameM = "";
      emailAddressM = "";
      passwordM = "";
      dobM = "";
      manageSigninLogin = false;
      // deleteAuthDetails(context);
      Navigator.pop(context);
      // ! try to change to future delay if it leads to any app performance issue
      // sleep(Duration(seconds:3));
      // deleteUserDuringSignUpProcess(context);
    },
  );
   // ignore: deprecated_member_use
  Widget stayHere = FlatButton(
    child: const Text(
      "Stay Here",
      style: const TextStyle(color: Colors.white),
    ),
    onPressed: () => Navigator.pop(context),
  );
   // ignore: deprecated_member_use
  Widget help = FlatButton(
    child: const Text(
      "Help",
      style: const TextStyle(color: Colors.white),
    ),
    onPressed: () {},
  );

  AlertDialog showAlert = AlertDialog(
    backgroundColor: Color(0xff121212),
    title: const Text(
      "Alert",
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    content: const Text(
      "Are you sure want to go back ?",
      style: const TextStyle(color: Colors.white),
    ),
    actions: [help, stayHere, goBack],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return showAlert;
      });
}
