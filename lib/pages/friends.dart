import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart' as account_model;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/widgets/friend_preview.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<account_model.Account> friends = [];
  List<account_model.Account> contacts = [];
  List<account_model.Account> mutual = [];
  List<account_model.Account> incoming = [];
  List<account_model.Account> outgoing = [];
  int displayType = 1;
  final List<String> labels = ['Friends', 'Contacts', 'Mutual', 'Incoming', 'Outgoing'];
  List<Contact> _allContacts = [];

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  void getFriends() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
      if (!status.isGranted) return;
    }

    if (await FlutterContacts.requestPermission()) {
      final phoneContacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        _allContacts = phoneContacts;
      });

      List<String> allPhoneNumbers = _allContacts
        .expand((contact) => contact.phones)
        .map((phone) => phone.number.replaceAll(RegExp(r'\s+'), ''))
        .toList();

      final response = await http.post(
        Uri.parse('$apiUrl/account/friendsPage'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': _auth.currentUser?.email, 'phoneNumbers': allPhoneNumbers}),
      );
      if (response.statusCode == 200) {
        setState(() {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['friends'] != null) {
            friends = List<account_model.Account>.from(
                jsonResponse['friends'].map((account) =>
                    account_model.Account.fromJson(account))
            );
          }
          if (jsonResponse['contacts'] != null) {
            contacts = List<account_model.Account>.from(
                jsonResponse['contacts'].map((account) =>
                    account_model.Account.fromJson(account))
            );
          }
          if (jsonResponse['mutual'] != null) {
            mutual = List<account_model.Account>.from(
                jsonResponse['mutual'].map((account) => account_model.Account.fromJson(account))
            );
          }
          if (jsonResponse['incoming'] != null) {
            incoming = List<account_model.Account>.from(
                jsonResponse['incoming'].map((account) => account_model.Account.fromJson(account))
            );
          }
          if (jsonResponse['outgoing'] != null) {
            outgoing = List<account_model.Account>.from(
                jsonResponse['outgoing'].map((account) => account_model.Account.fromJson(account))
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.add)
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(labels.length, (index) {
                  final int type = index + 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          displayType = type;
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            labels[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 250),
                            height: 2,
                            width: displayType == type ? 24 : 0,
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 10),
            ],
          ),
          SizedBox(height: 10),
          if (displayType == 1)
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return FriendPreview(account: friends[index], type: 'Friends');
                },
              ),
            ),
          if (displayType == 2)
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return FriendPreview(account: contacts[index], type: 'Other');
                },
              ),
            ),
          if (displayType == 3)
            Expanded(
              child: ListView.builder(
                itemCount: mutual.length,
                itemBuilder: (context, index) {
                  return FriendPreview(account: mutual[index], type: 'Other');
                },
              ),
            ),
          if (displayType == 4)
            Expanded(
              child: ListView.builder(
                itemCount: incoming.length,
                itemBuilder: (context, index) {
                  return FriendPreview(account: incoming[index], type: 'Incoming');
                },
              ),
            ),
          if (displayType == 5)
            Expanded(
              child: ListView.builder(
                itemCount: outgoing.length,
                itemBuilder: (context, index) {
                  return FriendPreview(account: outgoing[index], type: 'Outgoing');
                },
              ),
            ),
        ],
      )
    );
  }
}