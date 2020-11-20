import 'package:Explore/widgets/signup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "signup-screen";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool isLoading = false;
  // String userEmail;

  bool showPasswordText = false;
  bool agreeAge = false;
  bool agreeTerms = false;

  void loadingOn(){
    setState(() {
      isLoading = true;
    });
  }

  void loadingOff(){
    setState(() {
      isLoading = false;
    });
  }

  void toggle() {
    setState(() {
      showPasswordText = !showPasswordText;
    });
  }

  void toggleAge() {
    setState(() {
      agreeAge = !agreeAge;
    });
  }

  void toogleTerms() {
    setState(() {
      agreeTerms = !agreeTerms;
      
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    emailAddress.dispose();
    userName.dispose();
    password.dispose();
    confirmPassword.dispose();
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
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  logoAppName(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                  ),
                  nameTextField(name),
                  emailTextField(emailAddress),
                  userNameTextField(userName),
                  passwordTextField(
                      showPasswordText, toggle, password, confirmPassword),
                  confirmPasswordTextField(
                      showPasswordText, toggle, confirmPassword, password),
                  DOB(),
                  ageCondition(agreeAge, toggleAge),
                  termsAndConditions(agreeTerms, toogleTerms),
                  nextButton(
                      formKey: formKey,
                      agreeAge: agreeAge,
                      agreeTerms: agreeTerms,
                      emailAddress: emailAddress,
                      password: password,
                      loadingOn: loadingOn,
                      loadingOff: loadingOff,
                      isLoading: isLoading,
                      context: context,
                      
                      ),
                  navigateToLoginPage(context),
                  helpGuide(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
