import 'package:untitled/models/account.dart';
import 'package:intl/intl.dart';

class Message {
  final String content;
  final DateTime sentDate;
  final Account account;

  Message({
    required this.content,
    required this.sentDate,
    required this.account,
  });

  String get getContent {
    return content;
  }

  Account get getAccount {
    return account;
  }

  String get getSentDate {
    return "${DateFormat('yyyy-MM-dd').format(sentDate)} at ${DateFormat('hh:mm').format(sentDate)}";
  }
}