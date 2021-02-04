import 'package:explore/models/spinner.dart';
import 'package:explore/data/temp/auth_data.dart';
import 'package:explore/screens/basic_user_details_screen.dart';
import 'package:explore/screens/signup_screen.dart';
import 'package:explore/widgets/login_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

// * hex code for black - 0xff121212
// * hex code for yellow - 0xffF8C80D
// * Headline font - Domine Regular
// * Body font - nunito regular
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
  void pressedSignIn() {
    setState(() {
      manageSigninLogin = true;
    });
  }

  void pressedLogIn() {
    setState(() {
      manageSigninLogin = false;
    });
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          print("Active keyboard dismissed");
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        // ? bodytext1 = main text color -> white , primary color -> black , accent color -> white , title -> domine , white color
        // ? button color -> 
        debugShowCheckedModeBanner: false,
        title: "Explore",
        theme: ThemeData(
          fontFamily: "Nunito",
          primaryColor: Color(0xff121212),
          accentColor: Colors.white,
          buttonColor: Color(0xffF8C80D),
          textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white,),headline1:TextStyle(fontFamily: "Domine",color: Colors.white)),

        ),
        builder: (context, widget) => ResponsiveWrapper.builder(
          // ? warp all the heights and widths according to screen automatically
          widget,
          minWidth: 420,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.autoScale(420, name: MOBILE),
          ],
        ),
        home: StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapShot1) {
              if (snapShot1.connectionState == ConnectionState.waiting ||
                  snapShot1.hasError) {
                return loadingSpinner();
              }
              if (snapShot1.hasData) {
                return BasicDetailsScreens();
              }
              return manageSigninLogin == false
                  ? WelcomeLoginScreen(pressedSignin: pressedSignIn)
                  : SignUpScreen(pressedLogIn);
            }),
        routes: {
          // WelcomeLoginScreen.routeName : (context) => PageTransition(child: null, type: null),
        },
      ),
    );
  }
}

class WelcomeLoginScreen extends StatefulWidget {
  static const routeName = "login-screen";
  final Function pressedSignin;
  WelcomeLoginScreen({this.pressedSignin});

  @override
  _WelcomeLoginScreenState createState() => _WelcomeLoginScreenState();
}

class _WelcomeLoginScreenState extends State<WelcomeLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool showPasswordText = false;
  bool isLoading = false;
  bool isLoadingGoogle = false;
  final logoImage = Image.asset(
    "assets/app_images/explore_org_logo.png",
    fit: BoxFit.cover,
    // 200 , 170
    height: 200,
    width: 170,
  );

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

  void loadingOnGoogle() {
    setState(() {
      isLoadingGoogle = true;
    });
  }

  void loadingOffGoole() {
    setState(() {
      isLoadingGoogle = false;
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
                navigateToWebLink(),
                logoAppName(logoImage),
                // addDatingText(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
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
                googleSignUp(
                    isLoadingGoogle, loadingOnGoogle, loadingOffGoole, context),
                navigateToSignUpPage(context, widget.pressedSignin),
                // navigateToWebLink()
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
