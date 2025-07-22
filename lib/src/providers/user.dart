import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserResponse {
  final String token;
  final String userId;
  final String fullName;
  final String email;

  UserResponse({
    required this.token,
    required this.userId,
    required this.fullName,
    required this.email,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      token: json['token'] as String,
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
    );
  }
}

class UserProvider with ChangeNotifier {
  UserResponse? _user;

  UserResponse? get user => _user;

  void setUser(UserResponse user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  bool get isLoggedIn => _user != null;
}
