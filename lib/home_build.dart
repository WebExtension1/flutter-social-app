import 'package:flutter/material.dart';

// Pages
import 'package:untitled/pages/login.dart';
import 'package:untitled/main_app.dart';

// Models
import 'package:untitled/models/account.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:untitled/providers/shared_data.dart';
import 'package:untitled/providers/theme_notifier.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class HomeBuild extends StatefulWidget {
  const HomeBuild({super.key});

  @override
  State<HomeBuild> createState() => HomeBuildState();
}

class HomeBuildState extends State<HomeBuild> {
  Account? account = DataService().user;

  @override
  void initState() {
    super.initState();
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