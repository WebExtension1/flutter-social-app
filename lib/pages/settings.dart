import 'package:flutter/material.dart';
import 'package:badbook/pages/settings/account_settings.dart';
import 'package:badbook/pages/settings/notification_settings.dart';
import 'package:badbook/pages/settings/profile_settings.dart';
import 'package:badbook/pages/settings/theme_settings.dart';
import 'package:badbook/pages/login.dart';
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
                  "Change your profile.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            onTap: () => displayPage(ProfileSettings()),
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
                  "Update your details.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            onTap: () => displayPage(AccountSettings()),
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
            onTap: () => displayPage(NotificationSettings()),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("App Theme", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "Change your theme.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            onTap: () => displayPage(ThemeSettings()),
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

  void displayPage(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => page
      ),
    );
  }

  void signout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}