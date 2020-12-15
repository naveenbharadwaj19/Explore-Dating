import 'package:Explore/data/auth_data.dart';
import 'package:Explore/models/spinner.dart';
import 'package:Explore/screens/acc_create_screen.dart';
import 'package:Explore/screens/emai_verf_screen.dart';
import 'package:Explore/screens/gender_screen.dart';
import 'package:Explore/screens/home_screen.dart';
import 'package:Explore/screens/location_screen.dart';
import 'package:Explore/screens/pick_photos_screen.dart';
import 'package:Explore/screens/signup_screen.dart';
import 'package:Explore/widgets/login_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

// * hex code for black - 0xff121212
// * hex code for yellow - 0xffF8C80D
// * Headline font - Domine Regular
// * Body font - OpenSans Light
// * loading spinner - cubegrid

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void pressedSignIn(){
    setState(() {
      manageSigninLogin = true;
    });
  
  }
  void pressedLogIn(){
      setState(() {
        manageSigninLogin = false;
      });
    }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Explore",
      theme: ThemeData(
        fontFamily: "OpenSans",
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapShot1) {
            if (snapShot1.connectionState == ConnectionState.waiting ||
            snapShot1.hasError){
              return loadingSpinner();
            }
            if (snapShot1.hasData) {
              return HomeScreen();
            }
            return manageSigninLogin == false ? WelcomeLoginScreen(pressedSignIn) : SignUpScreen(pressedLogIn);
          }),
      routes: {
        // WelcomeLoginScreen.routeName : (context) => PageTransition(child: null, type: null),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case WelcomeLoginScreen.routeName:
            return PageTransition(
              child: WelcomeLoginScreen(pressedSignIn),
              type: PageTransitionType.rightToLeftWithFade,
            );
            break;
          case SignUpScreen.routeName:
            return PageTransition(
                child: SignUpScreen(pressedLogIn),
                type: PageTransitionType.leftToRightWithFade);
            break;
          case EmailVerificationScreen.routeName:
            return PageTransition(
              child: EmailVerificationScreen(),
              type: PageTransitionType.rightToLeftWithFade,
            );
            break;
          case HomeScreen.routeName:
            return PageTransition(
              child: HomeScreen(),
              type: PageTransitionType.rightToLeftWithFade,
            );
            break;
          case AccCreatedScreen.routeName:
            return PageTransition(
              child: AccCreatedScreen(),
              type: PageTransitionType.bottomToTop,
            );
            break;
          case GenderScreen.routeName:
            return PageTransition(
              child: GenderScreen(),
              type: PageTransitionType.bottomToTop,
            );
            break;
          case LocationScreen.routeName:
            return PageTransition(
              child: LocationScreen(),
              type: PageTransitionType.bottomToTop,
            );
            break;
          case PickPhotoScreen.routeName:
            return PageTransition(
              child: PickPhotoScreen(),
              type: PageTransitionType.bottomToTop,
            );
            break;
          default:
            return null;
        }
      },
    );
  }
}

class WelcomeLoginScreen extends StatefulWidget {
  static const routeName = "login-screen";
  final Function pressedSignin;
  WelcomeLoginScreen(this.pressedSignin);

  @override
  _WelcomeLoginScreenState createState() => _WelcomeLoginScreenState();
}

class _WelcomeLoginScreenState extends State<WelcomeLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool showPasswordText = false;
  bool isLoading = false;

  void toggle() {
    setState(() {
      showPasswordText = !showPasswordText;
    });
  }

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
    emailAddress.dispose();
    password.dispose();
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
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  greetText(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  catchyText(),
                  emailTextField(emailAddress),
                  passwordTextField(showPasswordText, toggle, password),
                  forgotPassword(formKey, emailAddress, context),
                  loginButton(
                      formKey: formKey,
                      emailAddress: emailAddress,
                      password: password,
                      loadingOn: loadingOn,
                      loadingOff: loadingOff,
                      isloading: isLoading,
                      context: context),
                  googleSignUp(),
                  navigateToSignUpPage(context , widget.pressedSignin),
                  navigateToWebLink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
