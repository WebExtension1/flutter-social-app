import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/pages/home.dart';
import 'package:untitled/pages/search.dart';
import 'package:untitled/pages/messages.dart';
import 'package:untitled/pages/profile.dart';
import 'package:untitled/services/notifications_services.dart';
import 'package:untitled/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await NotificationServices.initialiseNotification();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
  runApp(HomeBuild());
}

class HomeBuild extends StatefulWidget {
  const HomeBuild({super.key});

  @override
  State<HomeBuild> createState() => HomeBuildState();
}

class HomeBuildState extends State<HomeBuild> {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Account? account;

  @override
  void initState() {
    super.initState();
    fetchAccountDetails();
  }

  Future<void> fetchAccountDetails() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/account/details'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': _auth.currentUser?.email}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          account = Account(
              accountID: data['accountID'],
              email: data['email'],
              phoneNumber: data['phoneNumber'],
              username: data['username'],
              fname: data['fname'],
              lname: data['lname'],
              dateJoined: DateTime.parse(data['dateJoined']),
              imageUrl: data['imageUrl']
          );
        });
      } else {
        throw Exception('Failed to load account details');
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return MainAppScaffold(account: account);
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class MainAppScaffold extends StatefulWidget {
  final Account? account;
  const MainAppScaffold({super.key, this.account});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  int selectedIndex = 0;

  late final List<Widget> pages;
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
  void initState() {
    super.initState();
    pages = [
      Home(account: widget.account),
      Search(),
      Messages(),
      Profile(account: widget.account),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[selectedIndex],
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