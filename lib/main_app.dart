import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/friends.dart';
import 'package:badbook/pages/home.dart';
import 'package:badbook/pages/search.dart';
import 'package:badbook/pages/messages.dart';
import 'package:badbook/pages/profile.dart';
import 'package:badbook/pages/message.dart';

// Models
import 'package:badbook/models/account.dart';

// Notifications
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

class MainAppScaffold extends StatefulWidget {
  final Account? account;
  const MainAppScaffold({super.key, this.account});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  int selectedIndex = 0;
  bool notificationOpened = false;
  late String messageSender = '';

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
    _handleNotificationTaps();

    items = [
      navItem(Icons.home, "Home"),
      navItem(Icons.search, "Search"),
      navItem(Icons.message, "Messages"),
      navItem(Icons.people, "Friends"),
      navItem(Icons.person, "Profile"),
    ];
  }

  void _handleNotificationTaps() async {
    final initialFCM = await FirebaseMessaging.instance.getInitialMessage();

    // Messages from terminated app
    if (initialFCM != null) {
      _handleFCMData(initialFCM.data);
      _openProfile();
    }

    // Messages from background app
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleFCMData(message.data);
      _openProfile();
    });

    // Memories from terminated app
    final initialLocal = await AwesomeNotifications().getInitialNotificationAction(removeFromActionEvents: false);
    if (initialLocal != null) {
      _handleLocalData(initialLocal.payload ?? {});
    }

    // Memories from background app
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction action) async {
        _handleLocalData(action.payload ?? {});
      },
    );
  }

  void _openProfile() async {
    final dataService = Provider.of<DataService>(context, listen: false);

    final matchingFriend = dataService.friends.firstWhere(
            (friend) => friend.getEmail == messageSender
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MessagePage(account: matchingFriend)
        )
    );
  }

  void _handleFCMData(Map<String, dynamic> data) {
    if (data['type'] == 'chat') {
      setState(() {
        selectedIndex = 2;
        messageSender = data['sender'];
      });
    } else {
      setState(() {
        selectedIndex = 4;
        notificationOpened = true;
      });
    }
  }

  void _handleLocalData(Map<String, String?> data) {
    if (data['type'] == 'chat') {
      setState(() {
        selectedIndex = 2;
        messageSender = data['sender']!;
      });
    } else {
      setState(() {
        selectedIndex = 4;
        notificationOpened = true;
      });
    }
  }

  List<Widget> get pages => [
    Home(),
    Search(),
    Messages(),
    Friends(),
    Profile(memories: notificationOpened),
  ];

  @override
  Widget build(BuildContext context) {
    if (notificationOpened && selectedIndex != 4) {
      notificationOpened = false;
    }

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