import 'package:alarm_test/models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void removeUser() {
    _user = null;
    notifyListeners();
  }
}
