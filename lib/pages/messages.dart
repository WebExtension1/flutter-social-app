import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/widgets/messagePreview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => MessagesState();
}

class MessagesState extends State<Messages> {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Account> friends = [];

  void getFriends () async {
    final response = await http.post(
      Uri.parse('$apiUrl/account/friends'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email}),
    );
    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = jsonDecode(response.body);
        friends = List<Account>.from(
            jsonResponse.map((account) => Account.fromJson(account))
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: Expanded(
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return MessagePreview(account: friends[index]);
          },
        ),
      ),
    );
  }
}