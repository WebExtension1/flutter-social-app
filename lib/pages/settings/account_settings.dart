import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/login.dart';

// Models
import 'package:badbook/models/feedback_message.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _newPhoneNumberController = TextEditingController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

  FeedbackMessage? passwordMessage;
  FeedbackMessage? emailMessage;
  FeedbackMessage? phoneNumberMessage;
  FeedbackMessage? accountMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Divider(),
            GestureDetector(
              onTap: _resetPassword,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 15),
                  const Column(
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
            if (passwordMessage != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  passwordMessage!.message,
                  style: TextStyle(color: passwordMessage!.getColour),
                ),
              ),
            ],
            const Divider(),
            const Text(
              "Update Email",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: _newEmailController,
              decoration: const InputDecoration(labelText: 'New Email'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateEmail,
              child: const Text('Update'),
            ),
            if (emailMessage != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  emailMessage!.message,
                  style: TextStyle(color: emailMessage!.getColour),
                ),
              ),
            ],
            const Divider(),
            const Text(
              "Update Phone Number",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: _newPhoneNumberController,
              decoration: const InputDecoration(labelText: 'New Phone Number'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updatePhoneNumber,
              child: const Text('Update'),
            ),
            if (phoneNumberMessage != null) ...[
              const  SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  phoneNumberMessage!.message,
                  style: TextStyle(color: phoneNumberMessage!.getColour),
                ),
              ),
            ],
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.red),
              ),
              onTap: _deleteAccount,
            ),
            if (accountMessage != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  accountMessage!.message,
                  style: TextStyle(color: accountMessage!.getColour),
                ),
              ),
            ],
          ],
        )
      )
    );
  }

  void _deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (user == null) {
      return;
    }

    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete your account? This action can't be undone."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Delete"),
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
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        setState(() {
          accountMessage = FeedbackMessage(message: 'Please re-authenticate before deleting your account.', type: MessageType.error);
        });
      } else {
        setState(() {
          accountMessage = FeedbackMessage(message: 'An error occurred.', type: MessageType.error);
        });
      }
    }
  }

  void _updateEmail() async {
    String newEmail = _newEmailController.text.trim();
    User? user = FirebaseAuth.instance.currentUser;

    if (newEmail.isEmpty) {
      setState(() {
        emailMessage = FeedbackMessage(message: 'Email field cannot be empty.', type: MessageType.error);
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
            emailMessage = FeedbackMessage(message: 'A confirmation email has been sent to $newEmail. Your app may not work as intended until you confirm this action!', type: MessageType.success);
          });
        } else {
          setState(() {
            emailMessage = FeedbackMessage(message: 'Unable to update account details, likely due to this email already being in use.', type: MessageType.error);
          });
        }
      }
    } on FirebaseAuthException catch (_) {
      setState(() {
        emailMessage = FeedbackMessage(message: 'An error occurred.', type: MessageType.error);
      });
    }
  }

  void _updatePhoneNumber() async {
    String newPhoneNumber = _newPhoneNumberController.text.trim();

    if (newPhoneNumber.isEmpty) {
      setState(() {
        phoneNumberMessage = FeedbackMessage(message: 'Phone Number field cannot be empty.', type: MessageType.error);
      });
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/account/updatePhoneNumber'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'phoneNumber': newPhoneNumber}),
    );
    if (response.statusCode == 200) {
      setState(() {
        phoneNumberMessage = FeedbackMessage(message: 'Phone number updated!', type: MessageType.success);
      });
    } else {
      setState(() {
        phoneNumberMessage = FeedbackMessage(message: 'Unable to update account details.', type: MessageType.error);
      });
    }
  }

  void _resetPassword() async {
    try {
      if (_auth.currentUser?.email != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _auth.currentUser!.email!,
        );
      }
      setState(() {
        passwordMessage = FeedbackMessage(message: 'Password reset email sent. Please check your inbox.', type: MessageType.success);
      });
    } catch (e) {
      setState(() {
        passwordMessage = FeedbackMessage(message: 'Account not found.', type: MessageType.error);
      });
    }
  }
}
