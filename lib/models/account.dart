// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Providers
import 'package:badbook/providers/shared_data.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class Account {
  final int _accountID;
  final String _email;
  final String _username;
  final String _fname;
  final String _lname;
  final DateTime _dateJoined;
  final int _phoneNumber;
  final String _relationship;
  final String? _imageUrl;
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth;

  Account({
    required int accountID,
    required String email,
    required String username,
    required String fname,
    required String lname,
    required DateTime dateJoined,
    required int phoneNumber,
    required String relationship,
    String? imageUrl,
    FirebaseAuth? auth,
  })  : _accountID = accountID,
        _email = email,
        _username = username,
        _fname = fname,
        _lname = lname,
        _dateJoined = dateJoined,
        _phoneNumber = phoneNumber,
        _relationship = relationship,
        _imageUrl = imageUrl,
        _auth = auth ?? FirebaseAuth.instance;

  int get getAccountID => _accountID;
  String get getEmail => _email;
  String get getUsername => "@$_username";
  String get getName => "$_fname $_lname";
  List<String> get getRawName => [_fname, _lname];
  int get getPhoneNumber => _phoneNumber;

  String get getTimeSinceJoined {
    final now = DateTime.now();
    final difference = now.difference(_dateJoined);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }
  DateTime get getRawDateJoined => _dateJoined;

  String? get getImageUrl => _imageUrl;
  String get getRelationship => _relationship;

  void removeFriend(DataService dataService) async {
    await http.post(
      Uri.parse('$apiUrl/account/removeFriend'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': _email}),
    );
    refreshStatus(dataService);
  }

  void acceptFriendRequest(DataService dataService) async {
    await http.post(
      Uri.parse('$apiUrl/account/acceptFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': _email}),
    );
    refreshStatus(dataService);
  }

  void rejectFriendRequest(DataService dataService) async {
    await http.post(
      Uri.parse('$apiUrl/account/rejectFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': _email}),
    );
    refreshStatus(dataService);
  }

  void cancelFriendRequest(DataService dataService) async {
    await http.post(
      Uri.parse('$apiUrl/account/cancelFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': _email}),
    );
    refreshStatus(dataService);
  }

  void sendFriendRequest(DataService dataService) async {
    await http.post(
      Uri.parse('$apiUrl/account/sendFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': _email}),
    );
    refreshStatus(dataService);
  }

  void refreshStatus(DataService dataService) async {
    await dataService.getFeed();
    await dataService.getFriends();
  }

  factory Account.fromJson(Map<String, dynamic> json, {FirebaseAuth? auth}) {
    return Account(
      accountID: json['accountID'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      username: json['username'],
      fname: json['fname'],
      lname: json['lname'],
      dateJoined: DateTime.parse(json['dateJoined']),
      relationship: json['relationship'],
      imageUrl: json.containsKey('accountImageUrl') ? json['accountImageUrl'] as String? : json.containsKey('imageUrl') ? json['imageUrl'] as String? : null,
      auth: auth,
    );
  }
}