import 'package:Explore/widgets/Signup_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Explore",
      theme: ThemeData(fontFamily: "OpenSans"),
      home: SignupScreen(),
      routes: {},
    );
  }
}

class SignupScreen extends StatefulWidget {
  @override
  _WelcomeLoginScreenState createState() => _WelcomeLoginScreenState();
}

class _WelcomeLoginScreenState extends State<SignupScreen> {
  bool showPasswordText = false;
  void toggle() {
    setState(() {
      showPasswordText = !showPasswordText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              fullnameTextField(),
              emailTextField(),
              passwordTextField(showPasswordText, toggle),
              cpasswordTextField(showPasswordText, toggle),
              signupButton(),
              navigateToSignInPage(),
            ],
          ),
        ),
      ),
    );
  }
}
