import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/main.dart';
import 'package:untitled/pages/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _errorMessage;
  String? _successMessage;

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
                  onPressed: signup,
                  child: Text('Sign up'),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: login,
                  child: Text('Already a member?'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void signup() async {
    if (_emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
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

  void login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
