class Account {
  final int accountID;
  final String email;
  final String username;
  final String fname;
  final String lname;
  final DateTime dateJoined;

  Account({
    required this.accountID,
    required this.email,
    required this.username,
    required this.fname,
    required this.lname,
    required this.dateJoined
  });

  String get getUsername {
    return username;
  }

  String get getName {
    return fname + ' ' + lname;
  }

  String get getEmail {
    return email;
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountID: json['accountID'],
      email: json['email'],
      username: json['username'],
      fname: json['fname'],
      lname: json['lname'],
      dateJoined: DateTime.parse(json['dateJoined']),
    );
  }
}