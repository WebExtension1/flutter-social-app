import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:untitled/models/post.dart';
import 'package:untitled/widgets/accountPreview.dart';
import 'package:untitled/models/account.dart' as AccountModel; // It wasn't letting me use Account for formattedContacts so I needed to do this :(
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/services/socket_service.dart';
import 'package:untitled/widgets/postPreview.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _allContacts = [];
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  late List<AccountModel.Account> formattedContacts = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SocketService socketService = SocketService();
  List<Post> posts = [];
  List<AccountModel.Account> accounts = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(_onSearchChanged);
    socketService.socket.on("search", (data) {
      setState(() {
        posts = List<Post>.from(
          data['posts'].map((post) => Post.fromJson(post))
        );
        accounts = List<AccountModel.Account>.from(
          data['accounts'].map((account) => AccountModel.Account.fromJson(account))
        );
      });
    });
  }

  Future<void> _fetchContacts() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
      if (!status.isGranted) return;
    }

    if (await FlutterContacts.requestPermission()) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        _allContacts = contacts;
      });

      List<String> allPhoneNumbers = _allContacts
        .expand((contact) => contact.phones)
        .map((phone) => phone.number.replaceAll(RegExp(r'\s+'), ''))
        .toList();

      final response = await http.post(
        Uri.parse('$apiUrl/account/fromNumbers'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'phoneNumbers': allPhoneNumbers, 'email': _auth.currentUser?.email}),
      );
      if (response.statusCode == 200) {
        setState(() {
          var jsonResponse = jsonDecode(response.body);
          formattedContacts = List<AccountModel.Account>.from(
            jsonResponse.map((account) => AccountModel.Account.fromJson(account))
          );
        });
      }
    }
  }

  void _onSearchChanged() {
    setState(() {
      socketService.search(_auth.currentUser!.email!, _searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          if (_searchController.text.trim().isEmpty)
            Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Contacts",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                    ),
                    formattedContacts.isEmpty
                        ? Text("You're friends with all registered contacts!")
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: formattedContacts.map((account) {
                          return Row(
                            children: [
                              AccountPreview(account: account),
                              Padding(padding: EdgeInsets.all(8))
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Accounts",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  )
                                ),
                              ),
                            ),
                            accounts.isEmpty
                                ? Text("No accounts found.")
                                : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: accounts.map((account) {
                                  return Row(
                                    children: [
                                      AccountPreview(account: account),
                                      Padding(padding: EdgeInsets.all(8))
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Posts'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostPreview(
                          post: posts[index],
                          onDelete: () {
                            setState(() {
                              posts.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    socketService.socket.off("search");
    super.dispose();
  }
}
