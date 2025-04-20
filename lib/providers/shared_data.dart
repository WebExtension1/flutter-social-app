import 'package:flutter/material.dart';

// Models
import 'package:badbook/models/comment.dart';
import 'package:badbook/models/account.dart' as account_model;
import 'package:badbook/models/message.dart';
import 'package:badbook/models/post.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Services
import 'package:badbook/services/databases/friend_database.dart';
import 'package:badbook/services/databases/post_database.dart';
import 'package:badbook/services/databases/user_database.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

// Contacts
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

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
  Map<int, List<Comment>> comments = <int, List<Comment>>{};
  Map<String, Map<String, List<Object>>> profiles = <String, Map<String, List<Object>>>{};

  // Profiles
  // Comments
  // Messages
  // User
  // Feed
  // Friends

  // Load

  Future<void> loadFromLocalDB() async {
    _loadUser();
    _loadFeed();
    _loadFriends();
  }

  // Profiles

  Future<void> getProfile(String email) async {
    final response = await http.post(
      Uri.parse('$apiUrl/post/get'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'account': email}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      _updateProfileFromJson(email, jsonResponse);
      notifyListeners();
    }
  }

  void _updateProfileFromJson(String email, Map<String, dynamic> jsonResponse) {
    profiles[email] = <String, List<Object>>{};
    profiles[email]!['posts'] = _parsePosts(jsonResponse['posts']);
    profiles[email]!['comments'] = _parseComments(jsonResponse['comments']);
    profiles[email]!['liked'] = _parsePosts(jsonResponse['liked']);
    profiles[email]!['friends'] = _parseAccounts(jsonResponse['friends']);
  }

  // Comments

  Future<void> getComments(int postID) async {
    final response = await http.post(
      Uri.parse('$apiUrl/comment/get'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'postID': postID,
        'email': _auth.currentUser?.email
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      _updateCommentsFromJson(postID, jsonResponse);
      notifyListeners();
    }
  }

  void _updateCommentsFromJson(int postID, List<dynamic> jsonResponse) {
    comments[postID] = _parseComments(jsonResponse);
  }

  List<Comment> _parseComments(dynamic list) {
    if (list == null) return [];
    return List<Comment>.from(
      list.map((comment) => Comment.fromJson(comment)),
    );
  }

  // Messages

  Future<void> getMessageHistory(String email) async {
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

  // User

  Future<void> _loadUser() async {
    _getUser();
    notifyListeners;
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

  // Feed

  Future<void> _loadFeed() async {
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

  // Friends

  Future<void> _loadFriends() async {
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