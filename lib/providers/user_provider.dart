import 'package:flutter/material.dart';
import 'package:food/model/user_info.dart';

class UserProvider extends ChangeNotifier {
  UserInfo? _userInfo;

  UserInfo? get userInfo => _userInfo;

  void setUserInfo(UserInfo? userInfo) {
    _userInfo = userInfo;
    notifyListeners();
  }

  void clearUserInfo() {
    _userInfo = null;
    notifyListeners();
  }
}
