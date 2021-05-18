// @dart=2.9
import 'package:explore/icons/filter_icons.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/screens/chats/chat_screen.dart';
import 'package:explore/screens/home/explore_screen.dart';
import 'package:explore/widgets/filter_widget.dart';
import 'package:explore/screens/profile/user_pres_screen.dart';
import 'package:explore/screens/settings/settings_screen.dart';
import 'package:explore/widgets/bottom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// todo: Manage all screens of bottom navigation bar
class BottomNavigationBarScreens extends StatefulWidget {
  @override
  _BottomNavigationBarScreensState createState() =>
      _BottomNavigationBarScreensState();
}

class _BottomNavigationBarScreensState
    extends State<BottomNavigationBarScreens> {
  int index = 0;

  void tapped(int idx) {
    setState(() {
      index = idx;
    });
  }

  final List widgetsTapped = [
    ExploreAppBarScreen(),
    ChatScreen(),
    UserPrespectiveScreen(),
    SettingsScreen()
  ];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    ErrorWidget.builder = ((e) {
      print("Bad document during main home screen .Error suppressed");
      return Center(
        child: loadingSpinner(),
      );
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: widgetsTapped[index],
      bottomNavigationBar: bottomWidgets(index, tapped, context),
    );
  }
}

class ExploreAppBarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black12, // status bar color
          statusBarIconBrightness: Brightness
              .light, // text brightness -> light for dark app -> vice versa
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 70,
        title: Container(
          margin: const EdgeInsets.only(top: 5),
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(children: [
              const TextSpan(
                text: "Explore\n",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: "Domine",
                    decoration: TextDecoration.none),
              ),
              const TextSpan(
                text: "Dating",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Domine",
                    decoration: TextDecoration.none),
              ),
            ]),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Filter.sliders),
            color: Colors.white,
            iconSize: 30,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            tooltip: "Filters",
            onPressed: () => filterScreen(context: context),
          ),
        ],
      ),
      body: ExploreScreen(),
    );
  }
}
