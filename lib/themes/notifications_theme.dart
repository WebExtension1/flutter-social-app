import 'package:flutter/material.dart';

class NotificationTheme {
  static ThemeData myTheme = ThemeData(
    scaffoldBackgroundColor: Colors.teal,
    cardTheme: CardTheme(
      color: Colors.yellowAccent
    ),
    iconTheme: IconThemeData(
      color: Colors.blueAccent
    )
  );
}