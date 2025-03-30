import 'package:untitled/models/account.dart';
import 'package:untitled/models/post.dart';
import 'package:intl/intl.dart';

class Comment {
  final int commentID;
  final String content;
  final DateTime sentDate;
  final Account accountID;
  final Post postID;

  Comment({
    required this.commentID,
    required this.content,
    required this.sentDate,
    required this.accountID,
    required this.postID,
  });

  String get getContent {
    return content;
  }

  Account get getAccount {
    return accountID;
  }

  String get getSentDate {
    return "${DateFormat('yyyy-MM-dd').format(sentDate)} at ${DateFormat('hh:mm').format(sentDate)}";
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentID: json['commentID'],
      content: json['commentContent'],
      sentDate: DateTime.parse(json['sentDate']),
      accountID: Account.fromJson(json),
      postID: Post.fromJson(json),
    );
  }
}