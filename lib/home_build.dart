import 'package:flutter/material.dart';

// Pages
import 'package:untitled/pages/login.dart';
import 'package:untitled/main_app.dart';

// Models
import 'package:untitled/models/account.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Themes
import 'package:untitled/providers/theme_notifier.dart';
import 'package:provider/provider.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

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
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && account == null) {
        fetchAccountDetails();
      }
    });
  }

  Future<void> fetchAccountDetails() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/account/details'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': _auth.currentUser?.email
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          account = Account.fromJson(data);
        });
      } else {
        throw Exception('Failed to load account details');
      }
    } catch (e) {
      throw Exception('Failed to load account details');
    }
  }

  // Ensures the user is logged in when using the app, displays the login page if they aren't
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.getTheme(),
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
    );
  }
}