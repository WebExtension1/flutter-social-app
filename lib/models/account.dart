import 'package:intl/intl.dart';

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
  })  : _accountID = accountID,
        _email = email,
        _username = username,
        _fname = fname,
        _lname = lname,
        _dateJoined = dateJoined,
        _phoneNumber = phoneNumber,
        _relationship = relationship,
        _imageUrl = imageUrl;

  int get getAccountID {
    return _accountID;
  }

  String get getEmail {
    return _email;
  }

  String get getUsername {
    return "@$_username";
  }

  String get getName {
    return "$_fname $_lname";
  }

  int get getPhoneNumber {
    return _phoneNumber;
  }

  String get getJoinDate {
    return "${DateFormat('yyyy-MM-dd').format(_dateJoined)} at ${DateFormat('hh:mm').format(_dateJoined)}";
  }

  String? get getImageUrl {
    return _imageUrl;
  }

  String get getRelationship {
    return _relationship;
  }

  factory Account.fromJson(Map<String, dynamic> json) {
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
    );
  }
}