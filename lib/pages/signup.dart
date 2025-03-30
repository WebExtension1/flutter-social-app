import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/main.dart';
import 'package:untitled/pages/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
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
            SizedBox(height: 10),
            TextField(
              controller: _passwordConfirmController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _fnameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _lnameController,
              decoration: InputDecoration(labelText: 'Last Name'),
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
    if (_emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty && _passwordController.text.trim() == _passwordConfirmController.text.trim()) {
      try {
        final exists = await http.post(
          Uri.parse('$apiUrl/account/exists'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({'email': _emailController.text.trim(), 'username': _usernameController.text.trim(), 'fname': _fnameController.text.trim(), 'lname': _lnameController.text.trim()}),
        );
        if (exists.statusCode != 200) {
          setState(() {
            _errorMessage = 'Account already exists';
            _successMessage = null;
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
            body: json.encode({'email': _emailController.text.trim(), 'username': _usernameController.text.trim(), 'fname': _fnameController.text.trim(), 'lname': _lnameController.text.trim()}),
          );
          if (response.statusCode == 200) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeBuild()),
            );
          } else {
            setState(() {
              _errorMessage = 'Invalid credentials';
              _successMessage = null;
            });
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Invalid credentials';
          _successMessage = null;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid credentials';
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
