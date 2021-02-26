// Todo : Manage all Page view builder business logics

import 'package:flutter/foundation.dart';

class PageViewLogic with ChangeNotifier {
  int increment = 1;
  bool refresh = false;
  int pageStorageKeyNo = 1;
  void updateIncrement(){
    increment += 1;
    print("Pagination called : $increment");
    notifyListeners();
  }

  void startRefresh(){
    // ? when user press refresh
    refresh = true;
    print("Refreshing $refresh");
    notifyListeners();
    refresh = false;
  }
}