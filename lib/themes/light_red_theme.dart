import 'package:flutter/material.dart';

final ThemeData lightRedTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.red,
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.red[50],
  dividerColor: Colors.red[200],
  hintColor: Colors.red[300],
  iconTheme: const IconThemeData(color: Colors.red),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.red),
    bodyMedium: TextStyle(color: Colors.redAccent),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  ),
);