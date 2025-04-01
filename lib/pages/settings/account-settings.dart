import 'package:flutter/material.dart';
import 'package:untitled/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _newEmailController = TextEditingController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

  String? _errorMessagePassword;
  String? _successMessagePassword;
  String? _errorMessageEmail;
  String? _successMessageEmail;
  String? _errorMessageAccount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Divider(),
            GestureDetector(
              onTap: resetPassword,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reset Password",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Click to send a password reset link to your email.",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_errorMessagePassword != null || _successMessagePassword != null ) ...[
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _errorMessagePassword != null  ? _errorMessagePassword! : _successMessagePassword!,
                  style: TextStyle(
                    color: _errorMessagePassword != null ? Colors.red : Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            Divider(),
            Text(
              "Update Email",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: _newEmailController,
              decoration: InputDecoration(labelText: 'New Email'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateEmail,
              child: Text('Update'),
            ),
            if (_errorMessageEmail != null || _successMessageEmail != null ) ...[
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _errorMessageEmail != null  ? _errorMessageEmail! : _successMessageEmail!,
                  style: TextStyle(
                    color: _errorMessageEmail != null ? Colors.red : Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            Divider(),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text(
                "Delete Account",
                style: TextStyle(color: Colors.red),
              ),
              onTap: deleteAccount,
            ),
          ],
        )
      )
    );
  }

  void deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (user == null) {
      return;
    }

    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete your account? This action can't be undone."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;

    if (!confirmed) {
      return;
    }

    try {
      await user.delete();
      await FirebaseAuth.instance.signOut();
      await http.post(
        Uri.parse('$apiUrl/account/delete'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email}),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        setState(() {
          _errorMessageAccount = "Please reauthenticate before deleting your account.";
        });
      } else {
        setState(() {
          _errorMessageAccount = e.message ?? "An error occurred.";
        });
      }
    }
  }


  void updateEmail() async {
    String newEmail = _newEmailController.text.trim();
    User? user = FirebaseAuth.instance.currentUser;

    if (newEmail.isEmpty) {
      setState(() {
        _errorMessageEmail = "Email field cannot be empty.";
        _successMessageEmail = "";
      });
      return;
    }

    try {
      if (user != null) {
        final response = await http.post(
          Uri.parse('$apiUrl/account/updateEmail'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({'oldEmail': _auth.currentUser?.email, 'newEmail': newEmail}),
        );
        if (response.statusCode == 200) {
          await user.verifyBeforeUpdateEmail(newEmail);
          setState(() {
            _successMessageEmail = "A confirmation email has been sent to $newEmail. Your app may not work as intended until you confirm this action!";
            _errorMessageEmail = "";
          });
        } else {
          setState(() {
            _successMessageEmail = "Unable to update account details, likely due to this email already being in use.";
            _errorMessageEmail = "";
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessageEmail = e.message ?? "An error occurred.";
        _successMessageEmail = "";
      });
    }
  }


  void resetPassword() async {
    try {
      if (_auth.currentUser?.email != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _auth.currentUser!.email!,
        );
      }
      setState(() {
        _successMessagePassword = 'Password reset email sent. Please check your inbox.';
        _errorMessagePassword = null;
      });
    } catch (e) {
      setState(() {
        _errorMessagePassword = 'Account not found.';
        _successMessagePassword = null;
      });
    }
  }
}
