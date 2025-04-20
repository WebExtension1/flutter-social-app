import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/login.dart';
import 'package:badbook/home_build.dart';

// Models
import 'package:badbook/models/feedback_message.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Services
import 'package:badbook/services/fcm_service.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FeedbackMessage? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        automaticallyImplyLeading: false
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordConfirmController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fnameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lnameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            if (message != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  message!.message,
                  style: TextStyle(color: message!.getColour),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _signup,
                  child: const Text('Sign up'),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: _login,
                  child: const Text('Already a member?'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signup() async {
    if (_emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty && _passwordController.text.trim() == _passwordConfirmController.text.trim()) {
      try {
        final exists = await http.post(
          Uri.parse('$apiUrl/account/exists'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({'email': _emailController.text.trim(), 'username': _usernameController.text.trim()}),
        );
        if (exists.statusCode != 200) {
          setState(() {
            message = FeedbackMessage(message: 'Account already exists.', type: MessageType.error);
          });
        } else {
          await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          final response = await http.post(
            Uri.parse('$apiUrl/account/create'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({'email': _emailController.text.trim(), 'phoneNumber': _phoneNumberController.text, 'username': _usernameController.text.trim(), 'fname': _fnameController.text.trim(), 'lname': _lnameController.text.trim()}),
          );
          if (response.statusCode == 200) {
            await FCMService.registerTokenWithServer();
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeBuild()),
            );
          } else {
            setState(() {
              message = FeedbackMessage(message: 'Invalid credentials.', type: MessageType.error);
            });
          }
        }
      } catch (e) {
        setState(() {
          message = FeedbackMessage(message: 'Invalid credentials.', type: MessageType.error);
        });
      }
    } else {
      setState(() {
        message = FeedbackMessage(message: 'Invalid credentials.', type: MessageType.error);
      });
    }
  }

  void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
