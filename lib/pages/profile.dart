import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/pages/settings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key, this.account});
  final Account? account;

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  Account? account;
  bool loading = true;
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      account = widget.account!;
      loading = false;
    } else {
      fetchAccountDetails();
    }
  }

  Future<void> fetchAccountDetails() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/account/details'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': _auth.currentUser?.email}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          account = Account(
            accountID: data['accountID'],
            email: data['email'],
            username: data['username'],
            fname: data['fname'],
            lname: data['lname'],
            dateJoined: DateTime.parse(data['dateJoined'])
          );
          loading = false;
        });
      } else {
        throw Exception('Failed to load account details');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          account != null && account!.getEmail == _auth.currentUser?.email
              ? IconButton(onPressed: displaySettings, icon: Icon(Icons.settings))
              : IconButton(onPressed: displayOptions, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      account!.getName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${account!.getUsername}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      )
    );
  }

  void displaySettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const Settings(),
      ),
    );
  }

  void displayOptions() {

  }
}