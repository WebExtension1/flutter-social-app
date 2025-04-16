import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart' as account_model;
import 'package:untitled/services/databases/database_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> loadFriends () async {
    _getAccounts();
    notifyListeners();
  }

  void _getAccounts() async {
    await _loadCachedFriends();
    await _getFriends();
  }

  Future<void> _loadCachedFriends() async {
    final accounts = await FriendsDatabase.getAccounts();
    friends = accounts.toList();
    notifyListeners();
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
            cachedAccounts = List<account_model.Account>.from(
              jsonResponse['friends'].map((a) => account_model.Account.fromJson(a)),
            );
          }

          await FriendsDatabase.insertAccounts(cachedAccounts);
          _updateStateFromJson(jsonResponse);
          notifyListeners();
        }
      }
    }
  }

  void _updateStateFromJson(Map<String, dynamic> jsonResponse) {
    final key = (String label) => label.toLowerCase();
    friends = _parse(jsonResponse[key('Friends')]);
    contacts = _parse(jsonResponse[key('Contacts')]);
    mutual = _parse(jsonResponse[key('Mutual')]);
    incoming = _parse(jsonResponse[key('Incoming')]);
    outgoing = _parse(jsonResponse[key('Outgoing')]);
  }

  List<account_model.Account> _parse(dynamic list) {
    if (list == null) return [];
    return List<account_model.Account>.from(
      list.map((account) => account_model.Account.fromJson(account)),
    );
  }
}