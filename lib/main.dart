import 'package:Explore/widgets/logo_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

// * hex code for black - 0xff121212
// * hex code for yellow - 0xffF8C80D
// * Headline font - Domine Regular

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Explore",
      home: WelcomeLoginScreen(),
      routes: {},
    );
  }
}

class WelcomeLoginScreen extends StatefulWidget {
  @override
  _WelcomeLoginScreenState createState() => _WelcomeLoginScreenState();
}

class _WelcomeLoginScreenState extends State<WelcomeLoginScreen> {
  bool showPasswordText = false;
  void toggle(){
    setState(() {
      showPasswordText = !showPasswordText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(Color(0xff121212).withOpacity(1), BlendMode.difference),
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
              backgroundImageText(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              greetText(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              catchyText(),
              emailTextField(),
              passwordTextField(showPasswordText,toggle),
              loginButton(),
              navigateToSignUpPage(),
              Spacer(),
              navigateToWebLink()
            ],
          ),
        ),
      ),
    );
  }
}
