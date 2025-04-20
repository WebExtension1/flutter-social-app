import 'package:flutter/material.dart';

// Themes
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badbook/themes/light_theme.dart';
import 'package:badbook/themes/dark_theme.dart';
import 'package:badbook/themes/light_red_theme.dart';
import 'package:badbook/themes/dark_red_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;
  String _themeKey = "light";

  ThemeNotifier(this._themeData);

  ThemeData getTheme() {
    return _themeData;
  }

  String getThemeKey() {
    return _themeKey;
  }

  Future<void> setTheme(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (key) {
      case "dark":
        _themeData = darkTheme;
        break;
      case "red - light":
        _themeData = lightRedTheme;
        break;
      case "red - dark":
        _themeData = darkRedTheme;
        break;
      default:
        _themeData = lightTheme;
    }

    _themeKey = key;
    notifyListeners();
    prefs.setString("theme", key);
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("theme") ?? "light";
    await setTheme(key);
  }
}
