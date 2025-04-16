import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/home_build.dart';
import 'package:untitled/pages/signup.dart';
import 'package:untitled/services/fcm_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _errorMessage;
  String? _successMessage;

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
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_successMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _successMessage!,
                  style: TextStyle(color: Colors.green),
                ),
              ),
            if (_errorMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: login,
                  child: Text('Login'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: forgotPassword,
                  child: Text('Forgot Password'),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: signup,
                  child: Text('Not a member?'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void login() async {
    if (_emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FCMService.registerTokenWithServer();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeBuild()),
        );
      } catch (e) {
        setState(() {
          _errorMessage = 'Invalid credentials';
          _successMessage = null;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'All fields are required';
        _successMessage = null;
      });
    }
  }

  void forgotPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      setState(() {
        _successMessage = 'Password reset email sent. Please check your inbox.';
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Please enter a valid email.';
        _successMessage = null;
      });
    }
  }

  void signup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }
}
