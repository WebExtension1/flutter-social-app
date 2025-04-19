import 'package:flutter/material.dart';

// Pages
import 'package:badbook/home_build.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Services
import 'package:badbook/services/notifications_services.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/theme_notifier.dart';
import 'package:badbook/providers/shared_data.dart';

// Themes
import 'package:badbook/themes/light_theme.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Themes
  final themeNotifier = ThemeNotifier(lightTheme);
  await themeNotifier.loadTheme();

  // Initialise Notifications
  await NotificationServices.initialiseNotification();

  // Initialise Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Get env variables
  await dotenv.load();

  // Load data from local store and update it from network while the rest of the app loads
  DataService().loadFriends();
  DataService().loadFeed();
  DataService().loadUser();

  // Start app wrapped in a provider to dynamically update the theme
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeNotifier),
        ChangeNotifierProvider(create: (_) => DataService()),
      ],
      child: const HomeBuild(),
    ),
  );
}