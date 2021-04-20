import 'package:flutter/foundation.dart';
import 'storage.dart';

import 'api.dart';
import 'classes.dart';

class AppState with ChangeNotifier {
  bool _ready = false;
  User? _user;

  String _login = '';
  String _passwd = '';
  String _fcmToken = '';

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  User? get user => _user;

  bool get ready => _ready;

  set ready(bool value) {
    _ready = value;
    notifyListeners();
  }


  String get login => _login;

  set login(String value) {
    _login = value;
    notifyListeners();
  }

  void logout() {
    api.logout();
    storage.deleteAll();
    _user = null;
    _login = '';
    _passwd = '';
    notifyListeners();
  }

  String get passwd => _passwd;

  set passwd(String value) {
    _passwd = value;
    notifyListeners();
  }

  String get fcmToken => _fcmToken;

  set fcmToken(String value) {
    _fcmToken = value;
    notifyListeners();
  }
}