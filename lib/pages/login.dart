import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/signup.dart';
import 'package:badbook/home_build.dart';

// Models
import 'package:badbook/models/feedback_message.dart';

// Services
import 'package:badbook/services/fcm_service.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FeedbackMessage? message;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (message != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  message!.getMessage,
                  style: TextStyle(color: message!.getColour),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _forgotPassword,
                  child: const Text('Forgot Password'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: _signup,
                  child: const Text('Not a member?'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    if (_emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FCMService.registerTokenWithServer();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeBuild()),
        );
      } catch (e) {
        setState(() {
          message = FeedbackMessage(message: 'Invalid credentials.', type: MessageType.error);
        });
      }
    } else {
      setState(() {
        message = FeedbackMessage(message: 'All fields are required.', type: MessageType.error);
      });
    }
  }

  void _forgotPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      setState(() {
        message = FeedbackMessage(message: 'Password reset email sent. Please check your inbox.', type: MessageType.success);
      });
    } catch (e) {
      setState(() {
        message = FeedbackMessage(message: 'Please enter a valid email.', type: MessageType.error);
      });
    }
  }

  void _signup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }
}
