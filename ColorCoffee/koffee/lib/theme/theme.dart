import 'package:flutter/material.dart';

var koffeTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.brown[300],
  textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white)),
  primarySwatch: Colors.brown,
);

class ThemeChanger extends ChangeNotifier {
  ThemeData _themeData;
  ThemeChanger(this._themeData);

  ThemeData get getTheme => _themeData;
  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
