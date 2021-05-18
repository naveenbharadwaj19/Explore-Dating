// Todo : Manage all Page view builder business logics

import 'package:flutter/foundation.dart';

class PageViewLogic with ChangeNotifier {
  int increment = 1;
  bool refresh = false;
  int pageStorageKeyNo = 1;
  bool holdFuture = true; // true -> hold future for 2 seconds
  bool screenMotion = false; // setting to true will rebuild
  ValueNotifier<bool> holdExecution =
      ValueNotifier(true); // hold until feeds are fetched
  bool callConnectingUsers = true; // call connecting users from backend
  bool lowerboxUi = false;
  void updateIncrement() {
    increment += 1;
    print("Pagination called : $increment");
    notifyListeners();
  }

  void startRefresh() {
    // ? when user press refresh
    refresh = true;
    print("Refreshing $refresh");
    notifyListeners();
    refresh = false;
  }

  void updateLowerBoxUi() {
    // ? update lower box ui
    lowerboxUi = true;
    notifyListeners();
  }
}
