// @dart=2.9
// todo Mange notification page state
import 'package:flutter/foundation.dart';

class NotificationsState with ChangeNotifier {
  bool lockSwipe = false; // bool expression

  void enableLockSwipe({@required dynamic data , @required int index}){
    data.removeAt(index); // remove the element from the array
    lockSwipe = true; // lock the swipe
    notifyListeners();
  }
  void disableLockSwipe(){
    lockSwipe = false; // unlock the swipe
    notifyListeners();
  }
}