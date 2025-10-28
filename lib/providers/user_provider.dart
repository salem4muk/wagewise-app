import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String username;
  String role;

  User({
    required this.username,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'role': role,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json['username'],
        role: json['role'],
      );
}

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  static const _prefsKey = 'users';

  List<User> get users => _users;

  UserProvider() {
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(_prefsKey);
    if (usersString != null) {
      final List<dynamic> usersJson = jsonDecode(usersString);
      _users = usersJson.map((json) => User.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = jsonEncode(_users.map((user) => user.toJson()).toList());
    await prefs.setString(_prefsKey, usersString);
  }

  void addUser(User user) {
    _users.add(user);
    _saveToPrefs();
    notifyListeners();
  }

  void updateUser(int index, User user) {
    _users[index] = user;
    _saveToPrefs();
    notifyListeners();
  }

  void deleteUser(int index) {
    _users.removeAt(index);
    _saveToPrefs();
    notifyListeners();
  }
}
