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