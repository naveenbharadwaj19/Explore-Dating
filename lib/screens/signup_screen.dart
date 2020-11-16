import 'package:Explore/widgets/signup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "signup-screen";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showPasswordText = false;
  bool agreeAge = false;
  bool agreeTerms = false;

  void toggle() {
    setState(() {
      showPasswordText = !showPasswordText;
    });
  }

  void toggleAge(){
    setState(() {
      agreeAge = !agreeAge;
    });
  }

  void toogleTerms(){
    setState(() {
      agreeTerms = !agreeTerms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Material(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
              Color(0xff121212).withOpacity(1), BlendMode.difference),
          // ? difference, overlay, softlight ---> suitable blendmodes
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/app_background_img/welcome_bg_2.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                logoAppName(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                ),
                fullnameTextField(),
                emailTextField(),
                userName(),
                passwordTextField(showPasswordText, toggle),
                confirmPasswordTextField(showPasswordText, toggle),
                DOB(),
                ageCondition(agreeAge,toggleAge),
                termsAndConditions(agreeTerms, toogleTerms),
                nextButton(),
                navigateToLoginPage(context),
                helpGuide(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
