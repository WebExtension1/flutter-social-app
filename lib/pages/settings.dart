import 'package:flutter/material.dart';
import 'package:untitled/pages/settings/account-settings.dart';
import 'package:untitled/pages/settings/notification-settings.dart';
import 'package:untitled/pages/settings/profile-settings.dart';
import 'package:untitled/themes/notifications_theme.dart';
import 'package:untitled/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "Change Username & Name.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            onTap: displayProfileSettings,
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Account", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "Change Email. Reset Password. Delete Account.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            onTap: displayAccountSettings,
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "Configure Notifications.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
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
            onTap: signout,
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

  void signout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}