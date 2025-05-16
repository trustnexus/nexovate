import 'package:flutter/material.dart';

class ThemeModeProvider extends ChangeNotifier {


  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
