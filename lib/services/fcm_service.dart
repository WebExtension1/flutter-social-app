// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  // Register FCM Token for server related notifications
  static Future<void> registerTokenWithServer() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      String? token = await FirebaseMessaging.instance.getToken();

      if (auth.currentUser != null && token != null) {
        String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

        await http.post(
          Uri.parse('$apiUrl/account/registerFCMToken'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({'email': auth.currentUser!.email, 'token': token}),
        );
      }
    } catch (e) {
      throw Exception('Failed to register notifications. This is likely because you are using an emulated device.');
    }
  }
}
