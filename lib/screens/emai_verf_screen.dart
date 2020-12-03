import 'package:Explore/data/auth_data.dart';
import 'package:Explore/main.dart';
import 'package:Explore/models/auth.dart';
import 'package:Explore/models/email_model.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
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
                  "Verification code has been sent to your email : $emailAddressM",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
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
                    fontWeight: FontWeight.w600),
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
                  sendMail(
                      userNameM, "claw2020@gmail.com", generateFourDigitCode());
                  _controller.restart(duration: 120);
                  _storeFourDigits.clear();
                },
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: 150,
                child: isLoading == true
                    ? SpinKitCubeGrid(
                        color: Colors.white,
                        size: 40,
                      )
                    : RaisedButton(
                        color: Color(0xffF8C80D),
                        textColor: Color(0xff121212),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Color(0xffF8C80D))),
                        child: Text(
                          "Verify",
                          style: TextStyle(
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            print("Verified...");
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
                  onPressed: () => _showAlertDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_showAlertDialog(BuildContext context) {
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
      Navigator.pushNamed(context, WelcomeLoginScreen.routeName);
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
