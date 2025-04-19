import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/settings/account_settings.dart';
import 'package:badbook/pages/settings/notification_settings.dart';
import 'package:badbook/pages/settings/profile_settings.dart';
import 'package:badbook/pages/settings/theme_settings.dart';
import 'package:badbook/pages/login.dart';

// Models
import 'package:badbook/models/settings_page.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late List<SettingsPage> pages;
  
  @override
  void initState() {
    super.initState();
    pages = [
      SettingsPage(
        icon: Icon(Icons.person),
        title: 'Profile',
        description: 'Customise your profile.',
        page: ProfileSettings(),
      ),
      SettingsPage(
        icon: Icon(Icons.lock),
        title: 'Account',
        description: 'Update your account details.',
        page: AccountSettings(),
      ),
      SettingsPage(
        icon: Icon(Icons.notifications),
        title: 'Notifications',
        description: 'Get live updates.',
        page: NotificationSettings(),
      ),
      SettingsPage(
        icon: Icon(Icons.palette),
        title: 'App Theme',
        description: 'Personalise your experience.',
        page: ThemeSettings(),
      )
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListView.builder(
            itemCount: pages.length,
            itemBuilder: (context, index) {
              SettingsPage page = pages[index];
              return Column(
                children: [
                  ListTile(
                    leading: page.icon,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          page.title,
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        Text(
                          page.description,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                    onTap: () => _displayPage(page.page),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  Divider()
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text(
              "Log out",
              style: TextStyle(color: Colors.red),
            ),
            onTap: _signout,
          ),
        ],
      ),
    );
  }

  void _displayPage(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => page
      ),
    );
  }

  void _signout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}