import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = '';
  int _userId = 0;

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  int get userId => _userId;

  void login(int id, String name) {
    _userId = id;
    _username = name;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _userId = 0;
    _username = '';
    _isLoggedIn = false;
    notifyListeners();
  }
}
