// @dart=2.9
import 'package:explore/widgets/signup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "signup-screen";
  final Function pressedLogin;
  SignUpScreen(this.pressedLogin);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  // final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool isLoading = false;
  bool showPasswordText = false;
  bool agreeAge = false;
  bool agreeTerms = false;
  final logoImage = Image.asset(
    "assets/app_images/explore_org_logo.png",
    fit: BoxFit.cover,
    height: 200,
    width: 170,
  );

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
    // userName.dispose();
    password.dispose();
    confirmPassword.dispose();
  }

  @override
  // * precache image to reduce the loading time
  void didChangeDependencies() {
    // ignore: todo
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(logoImage.image, context);
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
    return SingleChildScrollView(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: Container(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                logoAppName(logoImage),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                ),
                nameTextField(name),
                emailTextField(emailAddress),
                // userNameTextField(userName),
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
                  name: name,
                  context: context,
                ),
                navigateToLoginPage(context, widget.pressedLogin),
                helpGuide(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
