import 'package:flutter/material.dart';
import 'package:untitled/pages/home.dart';
import 'package:untitled/pages/search.dart';
import 'package:untitled/pages/messages.dart';
import 'package:untitled/pages/profile.dart';
import 'package:untitled/services/notifications_services.dart';

void main() async {
  await NotificationServices.initialiseNotification();
  runApp(const HomeBuild());
}

class HomeBuild extends StatefulWidget {
  const HomeBuild({super.key});

  @override
  State<HomeBuild> createState() => HomeBuildState();
}

class HomeBuildState extends State<HomeBuild> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const Home(),
    const Search(),
    const Messages(),
    const Profile(),
  ];

  final items = [
    BottomNavigationBarItem(
      backgroundColor: Colors.grey,
      icon: Icon(Icons.home),
      label: "Home"
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.grey,
      icon: Icon(Icons.search),
      label: "Search"
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.grey,
      icon: Icon(Icons.message),
      label: "Messages"
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.grey,
      icon: Icon(Icons.person),
      label: "Profile"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: items
        ),
      )
    );
  }
}