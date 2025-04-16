import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart' as account_model;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/widgets/friend_preview.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/widgets/tab_bar.dart';
import 'package:untitled/services/database_service.dart';

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
    _getAccounts();
  }

  void _getAccounts() async {
    await _loadCachedFriends();
    await _getFriends();
  }

  void _updateStateFromJson(Map<String, dynamic> jsonResponse) {
    final groupsMap = <String, List<account_model.Account>>{};

    for (var label in labels) {
      final key = label.toLowerCase();
      if (jsonResponse[key] != null) {
        groupsMap[key] = List<account_model.Account>.from(
          jsonResponse[key].map((account) => account_model.Account.fromJson(account)),
        );
      }
    }

    setState(() {
      friends = groupsMap['friends'] ?? [];
      contacts = groupsMap['contacts'] ?? [];
      mutual = groupsMap['mutual'] ?? [];
      incoming = groupsMap['incoming'] ?? [];
      outgoing = groupsMap['outgoing'] ?? [];
    });
  }

  Future<void> _loadCachedFriends() async {
    final accounts = await FriendsDatabase.getAccounts();
    setState(() {
      friends = accounts.toList();
    });
  }

  Future<void> _getFriends() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
      if (!status.isGranted) return;
    }

    if (await FlutterContacts.requestPermission()) {
      var status = await Permission.contacts.status;
      if (!status.isGranted) {
        status = await Permission.contacts.request();
        if (!status.isGranted) return;
      }

      if (await FlutterContacts.requestPermission()) {
        final phoneContacts = await FlutterContacts.getContacts(withProperties: true);

        List<String> allPhoneNumbers = phoneContacts
          .expand((contact) => contact.phones)
          .map((phone) => phone.number.replaceAll(RegExp(r'\s+'), ''))
          .toList();

        final response = await http.post(
          Uri.parse('$apiUrl/account/friendsPage'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': _auth.currentUser?.email,
            'phoneNumbers': allPhoneNumbers
          }),
        );
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);

          List<account_model.Account> cachedAccounts = [];

          // Cache up to 15 friends
          if (jsonResponse['friends'] != null) {
            List<account_model.Account> allFriends = List<account_model.Account>.from(
              jsonResponse['friends'].map((a) => account_model.Account.fromJson(a)),
            );
            cachedAccounts.addAll(allFriends.take(15));
          }

          await FriendsDatabase.insertAccounts(cachedAccounts);
          _updateStateFromJson(jsonResponse);

          setState(() {
            _allContacts = phoneContacts;
          });
        }
      }
    }
  }

  static Expanded ListViewGroup(List<account_model.Account> group, String type) {
    return Expanded(
      child: ListView.builder(
        itemCount: group.length,
        itemBuilder: (context, index) {
          return FriendPreview(account: group[index], type: type);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends")
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          TabBarWidget(
            labels: labels,
            displayType: displayType,
            onTabSelected: (int type) {
              setState(() {
                displayType = type;
              });
            },
          ),
          SizedBox(height: 10),
          if (displayType == 1)
            ListViewGroup(friends, 'Friends'),
          if (displayType == 2)
            ListViewGroup(contacts, 'Other'),
          if (displayType == 3)
            ListViewGroup(mutual, 'Other'),
          if (displayType == 4)
            ListViewGroup(incoming, 'Incoming'),
          if (displayType == 5)
            ListViewGroup(outgoing, 'Outgoing')
        ],
      )
    );
  }
}