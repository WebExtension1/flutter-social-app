class Account {
  final String username;
  final String tag;
  final DateTime dateJoined;

  Account({
    required this.username,
    required this.tag,
    required this.dateJoined
  });

  String get getUsername {
    return username;
  }
}