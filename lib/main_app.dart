import 'package:flutter/material.dart';

// Pages
import 'package:untitled/pages/friends.dart';
import 'package:untitled/pages/home.dart';
import 'package:untitled/pages/search.dart';
import 'package:untitled/pages/messages.dart';
import 'package:untitled/pages/profile.dart';

// Models
import 'package:untitled/models/account.dart';

class MainAppScaffold extends StatefulWidget {
  final Account? account;
  const MainAppScaffold({super.key, this.account});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  int selectedIndex = 0;

  late final List<BottomNavigationBarItem> items;

  static BottomNavigationBarItem navItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.grey,
      icon: Icon(icon),
      label: label,
    );
  }

  @override
  void initState() {
    super.initState();

    items = [
      navItem(Icons.home, "Home"),
      navItem(Icons.search, "Search"),
      navItem(Icons.message, "Messages"),
      navItem(Icons.people, "Friends"),
      navItem(Icons.person, "Profile"),
    ];
  }

  List<Widget> get pages => [
    Home(),
    Search(account: widget.account),
    Messages(),
    Friends(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: items,
      ),
    );
  }
}