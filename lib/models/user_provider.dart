import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = '';
  int _userId = 0;
  String _token = ''; // Ajout token

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  int get userId => _userId;
  String get token => _token; // Getter token

  void login(int id, String name, String token) {
    _userId = id;
    _username = name;
    _token = token;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _userId = 0;
    _username = '';
    _token = '';
    _isLoggedIn = false;
    notifyListeners();
  }
}
