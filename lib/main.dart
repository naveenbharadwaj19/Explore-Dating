// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/providers/individual_chats_state.dart';
import 'package:explore/providers/pageview_logic.dart';
import 'package:explore/providers/profile_state.dart';
import 'package:explore/providers/show_me_state.dart';
import 'package:explore/screens/stream_user_screen.dart';
import 'package:explore/screens/chats/individual_chat_screen.dart';
import 'package:explore/screens/home/explore_screen.dart';
import 'package:explore/screens/profile/preview_screen.dart';
import 'package:explore/widgets/startup_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

// * hex code for black - 0xff121212
// * hex code for yellow - 0xffF8C80D
// * Headline font - Domine Regular
// * Body font - nunito regular
// * loading spinner - cubegrid

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseFirestore.instance.settings = Settings(host: "10.0.2.2:8080",sslEnabled: false); // ! comment out before production
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PageViewLogic>(
          create: (context) => PageViewLogic(),
        ),
        ChangeNotifierProvider<ShowMeState>(
          create: (context) => ShowMeState(),
        ),
        ChangeNotifierProvider<ProfileState>(
          create: (context) => ProfileState(),
        ),
        ChangeNotifierProvider<IndividualChatState>(
          create: (context) => IndividualChatState(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
        debugShowCheckedModeBanner: false,
        title: "Explore Dating",
        theme: ThemeData(
          fontFamily: "Nunito",
          primaryColor: Color(0xff121212),
          accentColor: Colors.white,
          buttonColor: Color(0xffF8C80D),
          textTheme: const TextTheme(
              bodyText1: TextStyle(
                color: Colors.white,
              ),
              headline1: const TextStyle(fontFamily: "Domine", color: Colors.white)),
        ),
        builder: (context, widget) => ResponsiveWrapper.builder(
          // ? warp all the heights and widths according to screen automatically
          widget,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.autoScale(420, name: MOBILE),
          ],
          backgroundColor: Theme.of(context).primaryColor,
        ),
        home: StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapShot1) {
              if (snapShot1.connectionState == ConnectionState.waiting ||
                  snapShot1.hasError) {
                return loadingSpinner();
              }
              if (snapShot1.hasData) {
                return StreamScreens();
              }
              return StartUpScreen();
            }),
        routes: {
          // WelcomeLoginScreen.routeName : (context) => PageTransition(child: null, type: null),
          ViewBodyPhoto.routeName: (context) => ViewBodyPhoto(),
          ViewPhoto.routeName: (context) => ViewPhoto(),
          PreviewScreen.routeName: (context) => PreviewScreen(),
          IndividualChatScreen.routeName: (context) => IndividualChatScreen(),
        },
      ),
    );
  }
}

class StartUpScreen extends StatefulWidget {
  static const routeName = "startup-screen";

  @override
  _StartUpScreenState createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  bool isLoadingGoogle = false;
  bool isLoadingFb = false;
  final logoImage = Image.asset(
    "assets/images/explore_dating.png",
    fit: BoxFit.cover,
    // 200 , 170
    height: 200,
    width: 170,
  );

  void loadingOnGoogle() {
    setState(() {
      isLoadingGoogle = true;
    });
  }

  void loadingOffGoogle() {
    setState(() {
      isLoadingGoogle = false;
    });
  }

  void loadingOnFb() {
    setState(() {
      isLoadingFb = true;
    });
  }

  void loadingOffFb() {
    setState(() {
      isLoadingFb = false;
    });
  }

  @override
  //  precache image to reduce the loading time
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
    return Material(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Spacer(),
          // navigateToWebSite(),
          logoAppName(logoImage),
          greetText(),
          catchyText(),
          Spacer(),
          googleButton(
              isLoadingGoogle: isLoadingGoogle,
              loadingOnGoogle: loadingOnGoogle,
              loadingOffGoogle: loadingOffGoogle,
              context: context), // google auth
          faceBookButton(
              isloadingFb: isLoadingFb,
              loadingOnFb: loadingOnFb,
              loadingOffFb: loadingOffFb,
              context: context), // facebook auth
          Spacer(),
          faceBookInfo(),
          Spacer(),
          bottomButtons(),
        ],
      ),
    );
  }
}
