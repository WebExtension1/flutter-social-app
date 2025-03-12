import 'package:flutter/material.dart';
import 'package:untitled/pages/notifications.dart';
import 'package:untitled/themes/notifications_theme.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: displayNotifications,
              child: Text("Notifications"),
            )
          ],
        )
    );
  }

  void displayNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Theme(
            data: NotificationTheme.myTheme,
            child: const Notifications()
        )
      ),
    );
  }
}