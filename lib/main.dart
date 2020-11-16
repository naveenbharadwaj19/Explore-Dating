import 'package:Explore/screens/signup_screen.dart';
import 'package:Explore/widgets/login_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

// * hex code for black - 0xff121212
// * hex code for yellow - 0xffF8C80D
// * Headline font - Domine Regular
// * Body font - OpenSans Light

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Explore",
      theme: ThemeData(
        fontFamily: "OpenSans"
      ),
      home: WelcomeLoginScreen(),
      routes: {
        // WelcomeLoginScreen.routeName : (context) => PageTransition(child: null, type: null),
        // SignUpScreen.routeName : (context) => SignUpScreen(),
      },
      onGenerateRoute: (settings){
        switch (settings.name){
          case WelcomeLoginScreen.routeName :
          return PageTransition(child: WelcomeLoginScreen(), type: PageTransitionType.rightToLeftWithFade,);
          break;
          case SignUpScreen.routeName :
          return PageTransition(child: SignUpScreen(), type: PageTransitionType.leftToRightWithFade);
          break;
          default :
          return null;
        }
      },
    );
  }
}

class WelcomeLoginScreen extends StatefulWidget {
  static const routeName = "login-screen";
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
              logoAppName(),
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
              googleSignUp(),
              navigateToSignUpPage(context),
              Spacer(),
              navigateToWebLink()
            ],
          ),
        ),
      ),
    );
  }
}
