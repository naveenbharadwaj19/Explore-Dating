import 'package:explore/icons/filter_icons.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/screens/chat_screen.dart';
import 'package:explore/screens/explore_screen.dart';
import 'package:explore/widgets/filter_widget.dart';
import 'package:explore/screens/hmu_screen.dart';
import 'package:explore/screens/notifications_screen.dart';
import 'package:explore/screens/profile_screen.dart';
import 'package:explore/screens/settings_screen.dart';
import 'package:explore/widgets/bottom_widgets.dart';
import 'package:flutter/material.dart';

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
    ExploreAndHMUScreen(),
    ChatScreen(),
    NotificationsScreen(),
    ProfileScreen(),
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

// todo: manage Tab bar view -> Explore and HMU
class ExploreAndHMUScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            // automaticallyImplyLeading: false,
            title: RichText(
              textAlign: TextAlign.right,
              text: TextSpan(children: [
                const TextSpan(
                  text: "Explore\n",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: "Domine",
                      decoration: TextDecoration.none),
                ),
                const TextSpan(
                  text: "Dating",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Domine",
                      decoration: TextDecoration.none),
                ),
              ]),
            ),
            actions: [
              IconButton(
                icon: const Icon(Filter.sliders),
                color: Colors.white,
                iconSize: 30,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                tooltip: "Filter",
                onPressed: (){
                  filterScreen(context: context);
                }),
              
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 1.5,
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 20),
              tabs: [
                const Tab(
                  child: const Text(
                    "Explore",
                    style: TextStyle(fontFamily: "Domine"),
                  ),
                ),
                const Tab(
                  child: const Text(
                    "HMU",
                    style: TextStyle(fontFamily: "Domine"),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            // physics: NeverScrollableScrollPhysics(),
            children: [
              ExploreScreen(),
              HMUScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
