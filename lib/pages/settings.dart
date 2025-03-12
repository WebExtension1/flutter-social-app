import 'package:flutter/material.dart';
import 'package:untitled/pages/settings/account-settings.dart';
import 'package:untitled/pages/settings/notification-settings.dart';
import 'package:untitled/pages/settings/profile-settings.dart';
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
      body: ListView(
        children: [
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: displayProfileSettings,
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Account"),
            onTap: displayAccountSettings,
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            onTap: displayNotificationSettings,
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(
              "Log out",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {},
          ),
        ],
      ),
    );

  }

  void displayProfileSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Theme(
            data: NotificationTheme.myTheme,
            child: const ProfileSettings()
        )
      ),
    );
  }

  void displayAccountSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) => Theme(
              data: NotificationTheme.myTheme,
              child: const AccountSettings()
          )
      ),
    );
  }

  void displayNotificationSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) => Theme(
              data: NotificationTheme.myTheme,
              child: const NotificationSettings()
          )
      ),
    );
  }
}