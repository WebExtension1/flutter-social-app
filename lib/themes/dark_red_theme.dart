import 'package:flutter/material.dart';

final ThemeData darkRedTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.red[900],
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.red[900],
  dividerColor: Colors.red[800],
  hintColor: Colors.red[700],
  iconTheme: const IconThemeData(color: Colors.red),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.grey),
    bodyMedium: TextStyle(color: Colors.grey),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  ),
);
