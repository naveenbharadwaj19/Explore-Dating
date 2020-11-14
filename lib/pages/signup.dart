import 'package:Explore/widgets/Signup_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gender_selection/gender_selection.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Explore",
      theme: ThemeData(fontFamily: "OpenSans"),
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
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              fullnameTextField(),
              emailTextField(),
              GenderSelection(
                maleText: "", //default Male
                femaleText: "", //default Female
                linearGradient: pinkRedGradient,
                selectedGenderIconBackgroundColor: Colors.indigo, // default red
                checkIconAlignment:
                    Alignment.centerRight, // default bottomRight
                selectedGenderCheckIcon: null, // default Icons.check
                onChanged: (Gender gender) {
                  print(gender);
                },
                equallyAligned: true,
                animationDuration: Duration(milliseconds: 400),
                isCircular: true, // default : true,
                isSelectedGenderIconCircular: true,
                opacityOfGradient: 0.6,
                padding: const EdgeInsets.all(3),
                size: 120, //default : 120
              ),
              passwordTextField(showPasswordText, toggle),
              cpasswordTextField(showPasswordText, toggle),
              signupButton(),
              googleSignUp(),
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
