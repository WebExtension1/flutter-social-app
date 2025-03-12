import 'package:flutter/material.dart';
import 'package:untitled/pages/settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(onPressed: displaySettings, icon: Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
        ],
      )
    );
  }

  void displaySettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const Settings(),
      ),
    );
  }
}