import 'package:explore/icons/bottom_navigation_bar_icons_icons.dart';
import 'package:explore/icons/home_icon_org_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

Widget bottomWidgets(int index, Function tapped, BuildContext context) {
  const double iconSize = 27;
  return SnakeNavigationBar.color(
    currentIndex: index,
    onTap: tapped,
    snakeShape: SnakeShape.indicator,
    snakeViewColor: Colors.white,
    backgroundColor: Theme.of(context).primaryColor,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white,
    items: [
      BottomNavigationBarItem(
        icon: const Icon(HomeIconOrg.homeiconorg,size: iconSize),
      ),
      BottomNavigationBarItem(
        icon: Icon(index == 1 ? BottomNavigationBarIcons.chat_inv: BottomNavigationBarIcons.chat, size: iconSize),
      ),
      BottomNavigationBarItem(
        icon: Icon(index == 2 ? BottomNavigationBarIcons.bell_alt : BottomNavigationBarIcons.bell, size: iconSize),
      ),
      BottomNavigationBarItem(
        icon: Icon(index == 3 ? BottomNavigationBarIcons.person : BottomNavigationBarIcons.person_outline, size: iconSize),
      ),
      BottomNavigationBarItem(
        icon: Icon(index == 4 ? BottomNavigationBarIcons.cog : BottomNavigationBarIcons.cog_outline, size: iconSize),
      ),
    ],
  );
}
