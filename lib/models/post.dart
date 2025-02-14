import 'package:untitled/models/account.dart';
import 'package:intl/intl.dart';

class Post {
  final String content;
  final Account account;
  final DateTime postDate;

  Post({
    required this.content,
    required this.account,
    required this.postDate,
  });

  String get getContent {
    return content;
  }

  Account get getAccount {
    return account;
  }

  String get getPostDate {
    return "${DateFormat('yyyy-MM-dd').format(postDate)} at ${DateFormat('hh-mm').format(postDate)}";
  }
}