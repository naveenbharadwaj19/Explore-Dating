// todo : Manage all profile states

import 'package:flutter/widgets.dart';

class ProfileState extends ChangeNotifier {
  bool bodyPhotoUploadProcess = false;
  bool bodyPhotoDeleteProcess = false;
  void startBodyPhotoProcess() {
    bodyPhotoUploadProcess = true;
    notifyListeners();
  }

  void stopBodyPhotoProcess() {
    bodyPhotoUploadProcess = false;
    notifyListeners();
  }

  void startBodyPhotoDeleteProcess() {
    bodyPhotoDeleteProcess = true;
    notifyListeners();
  }

  void stopBodyPhotoDeleteProcess() {
    bodyPhotoDeleteProcess = false;
    notifyListeners();
  }
}
