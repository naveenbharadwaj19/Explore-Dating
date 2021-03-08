// todo manage UI state when user press signin login

import 'package:explore/data/temp/auth_data.dart';
import 'package:flutter/cupertino.dart';

class ManangeSigninLogin with ChangeNotifier {
  void pressedSignIn() {
    manageSigninLogin = true;
    notifyListeners();
  }

  void pressedLogIn() {
    manageSigninLogin = false;
    notifyListeners();
  }
}
