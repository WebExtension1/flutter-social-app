import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/profile.dart';

// Models
import 'package:badbook/models/account.dart';

// Widgets
import 'package:badbook/widgets/account_bar.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class FriendPreview extends StatefulWidget {
  const FriendPreview({super.key, required this.account, required this.type});
  final Account account;
  final String type;

  @override
  State<FriendPreview> createState() => _FriendPreviewState();
}

class _FriendPreviewState extends State<FriendPreview> {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openProfile,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              AccountBar(account: widget.account, clickable: false),
              Expanded(
                child: SizedBox()
              ),
              if (widget.type == 'Friends')
                ElevatedButton(
                  onPressed: removeFriend,
                  child: const Text("Remove"),
                ),
              if (widget.type == 'Incoming')
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: acceptFriendRequest,
                      child: const Text("Accept"),
                    ),
                    ElevatedButton(
                      onPressed: rejectFriendRequest,
                      child: const Text("Reject"),
                    ),
                  ]
                ),
              if (widget.type == 'Outgoing')
                ElevatedButton(
                  onPressed: cancelFriendRequest,
                  child: const Text("Cancel"),
                ),
              if (widget.type == 'Other')
                ElevatedButton(
                  onPressed: sendFriendRequest,
                  child: const Text("Send Request"),
                )
            ],
          ),
        )
      )
    );
  }

  void removeFriend() async {
    await http.post(
      Uri.parse('$apiUrl/account/removeFriend'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': widget.account.getEmail}),
    );
  }

  void acceptFriendRequest() async {
    await http.post(
      Uri.parse('$apiUrl/account/acceptFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': widget.account.getEmail}),
    );
  }

  void rejectFriendRequest() async {
    await http.post(
      Uri.parse('$apiUrl/account/rejectFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': widget.account.getEmail}),
    );
  }

  void cancelFriendRequest() async {
     await http.post(
      Uri.parse('$apiUrl/account/cancelFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': widget.account.getEmail}),
    );
  }

  void sendFriendRequest() async {
    await http.post(
      Uri.parse('$apiUrl/account/sendFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': widget.account.getEmail}),
    );
  }

  void openProfile() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(account: widget.account)),
    );
  }
}
