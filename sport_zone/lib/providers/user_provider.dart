import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  String? _avatarUrl;

  String? get username => _username;
  String? get avatarUrl => _avatarUrl;

  void setUser({required String username, String? avatarUrl}) {
    _username = username;
    _avatarUrl = avatarUrl;
    notifyListeners();
  }

  void clear() {
    _username = null;
    _avatarUrl = null;
    notifyListeners();
  }
}
