import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _newFNameController = TextEditingController();
  final TextEditingController _newLNameController = TextEditingController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

  String? _errorMessageUsername;
  String? _successMessageUsername;
  String? _errorMessageName;
  String? _successMessageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Divider(),
            Text(
              "Update Username",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: _newUsernameController,
              decoration: InputDecoration(labelText: 'New Username'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateUsername,
              child: Text('Update'),
            ),
            if (_errorMessageUsername != null || _successMessageUsername != null ) ...[
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _errorMessageUsername != null  ? _errorMessageUsername! : _successMessageUsername!,
                  style: TextStyle(
                    color: _errorMessageUsername != null ? Colors.red : Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            Divider(),
            Text(
              "Update Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: _newFNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _newLNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateName,
              child: Text('Update'),
            ),
            if (_errorMessageName != null || _successMessageName != null ) ...[
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _errorMessageName != null  ? _errorMessageName! : _successMessageName!,
                  style: TextStyle(
                    color: _errorMessageName != null ? Colors.red : Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        )
      )
    );
  }

  void updateUsername() async {
    String newUsername = _newUsernameController.text.trim();

    if (newUsername.isEmpty) {
      setState(() {
        _errorMessageUsername = "Username field cannot be empty.";
        _successMessageUsername = "";
      });
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/account/updateUsername'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'username': newUsername}),
    );
    if (response.statusCode == 200) {
      setState(() {
        _successMessageUsername = "Username updated!";
        _errorMessageUsername = "";
      });
    } else {
      setState(() {
        _errorMessageUsername = "Unable to update account details.";
        _successMessageUsername = "";
      });
    }
  }

  void updateName() async {
    String newFName = _newFNameController.text.trim();
    String newLName = _newLNameController.text.trim();

    if (newFName.isEmpty  || newLName.isEmpty) {
      setState(() {
        _errorMessageName = "Name fields cannot be empty.";
        _successMessageName = "";
      });
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/account/updateName'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'fname': newFName, 'lname': newLName}),
    );
    if (response.statusCode == 200) {
      setState(() {
        _successMessageName = "Name updated!";
        _errorMessageName = "";
      });
    } else {
      setState(() {
        _errorMessageName = "Unable to update account details.";
        _successMessageName = "";
      });
    }
  }
}
