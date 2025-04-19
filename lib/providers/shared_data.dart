import 'package:flutter/material.dart';
import 'package:badbook/models/account.dart' as account_model;
import 'package:badbook/models/message.dart';
import 'package:badbook/models/post.dart';
import 'package:badbook/services/databases/friend_database.dart';
import 'package:badbook/services/databases/post_database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badbook/services/databases/user_database.dart';

class DataService extends ChangeNotifier {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<String> labels = ['Friends', 'Contacts', 'Mutual', 'Incoming', 'Outgoing'];

  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;

  DataService._internal();

  List<account_model.Account> friends = [];
  List<account_model.Account> contacts = [];
  List<account_model.Account> mutual = [];
  List<account_model.Account> incoming = [];
  List<account_model.Account> outgoing = [];
  List<Post> feed = [];
  account_model.Account? user;
  Map<String, List<Message>> messages = <String, List<Message>>{};

  Future<void> loadUser() async {
    _getUser();
    notifyListeners;
  }

  Future<List<Message>> getMessageHistory(String email) async {
    if (messages[email] == null) {
      final response = await http.post(
        Uri.parse('$apiUrl/account/getMessageHistory'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'sender': _auth.currentUser?.email,
          'recipient': email
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        _updateMessagesFromJson(email, jsonResponse);
        notifyListeners();
      }
      return messages[email]!;
    } else {
      return messages[email]!;
    }
  }

  void _updateMessagesFromJson(String email, List<dynamic> jsonResponse) {
    messages[email] = _parseMessages(jsonResponse);
  }

  List<Message> _parseMessages(dynamic list) {
    if (list == null) return [];
    return List<Message>.from(
      list.map((message) => Message.fromJson(message)),
    );
  }

  void _getUser() async {
    await _loadCachedUser();
    await getUser();
  }

  Future<void> _loadCachedUser() async {
    final account = await UserDatabase.getAccount();
    if (account != null) {
      user = account;
      notifyListeners();
    }
  }

  Future<void> getUser() async {
    final response = await http.post(
      Uri.parse('$apiUrl/account/details'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': _auth.currentUser?.email
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      await UserDatabase.insertAccount(account_model.Account.fromJson(jsonResponse));
      _updateUserFromJson(jsonResponse);
      notifyListeners();
    }
  }

  void _updateUserFromJson(Map<String, dynamic> jsonResponse) {
    user = account_model.Account.fromJson(jsonResponse);
  }

  Future<void> loadFeed() async {
    _getFeed();
    notifyListeners();
  }

  void _getFeed() async {
    await _loadCachedFeed();
    await getFeed();
  }

  Future<void> _loadCachedFeed() async {
    final posts = await PostDatabase.getFeed();
    feed = posts.toList();
    notifyListeners();
  }

  Future<void> getFeed() async {
    final response = await http.post(
      Uri.parse('$apiUrl/post/feed'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': _auth.currentUser?.email
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      List<Post> cachedPosts = [];

      // Cache up to 15 posts
      if (jsonResponse != null) {
        cachedPosts = List<Post>.from(
          jsonResponse.map((post) => Post.fromJson(post)),
        );
      }

      await PostDatabase.insertPosts(cachedPosts);
      _updatePostsFromJson(jsonResponse);
      notifyListeners();
    }
  }

  void _updatePostsFromJson(List<dynamic> jsonResponse) {
    feed = _parsePosts(jsonResponse);
  }

  List<Post> _parsePosts(dynamic list) {
    if (list == null) return [];
    return List<Post>.from(
      list.map((post) => Post.fromJson(post)),
    );
  }

  Future<void> loadFriends() async {
    _getAccounts();
    notifyListeners();
  }

  void _getAccounts() async {
    await _loadCachedFriends();
    await getFriends();
  }

  Future<void> _loadCachedFriends() async {
    final accounts = await FriendsDatabase.getAccounts();
    friends = accounts.toList();
    notifyListeners();
  }

  Future<void> getFriends() async {
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
            cachedAccounts = List<account_model.Account>.from(
              jsonResponse['friends'].map((a) => account_model.Account.fromJson(a)),
            );
          }

          await FriendsDatabase.insertAccounts(cachedAccounts);
          _updateFriendsFromJson(jsonResponse);
          notifyListeners();
        }
      }
    }
  }

  void _updateFriendsFromJson(Map<String, dynamic> jsonResponse) {
    key(String label) => label.toLowerCase();
    friends = _parseAccounts(jsonResponse[key('Friends')]);
    contacts = _parseAccounts(jsonResponse[key('Contacts')]);
    mutual = _parseAccounts(jsonResponse[key('Mutual')]);
    incoming = _parseAccounts(jsonResponse[key('Incoming')]);
    outgoing = _parseAccounts(jsonResponse[key('Outgoing')]);
  }

  List<account_model.Account> _parseAccounts(dynamic list) {
    if (list == null) return [];
    return List<account_model.Account>.from(
      list.map((account) => account_model.Account.fromJson(account)),
    );
  }
}