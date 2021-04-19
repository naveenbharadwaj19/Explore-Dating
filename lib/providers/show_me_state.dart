// @dart=2.9
// todo : Manage all show me states

import 'package:flutter/material.dart';

class ShowMeState extends ChangeNotifier{
  bool backEndProcess = false;
   startBackEndProcess(){
    backEndProcess = true;
    notifyListeners();
  }
  void stopBackEndProcess(){
    backEndProcess = false;
    notifyListeners();
  }
}
