import 'package:untitled/models/account.dart';
import 'package:intl/intl.dart';

class Post {
  final int postID;
  final String content;
  final Account account;
  final DateTime postDate;

  Post({
    required this.postID,
    required this.content,
    required this.account,
    required this.postDate,
  });

  int get getPostID {
    return postID;
  }

  String get getContent {
    return content;
  }

  Account get getAccount {
    return account;
  }

  String get getPostDate {
    return "${DateFormat('yyyy-MM-dd').format(postDate)} at ${DateFormat('hh:mm').format(postDate)}";
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postID: json['postID'],
      content: json['content'],
      account: Account.fromJson(json),
      postDate: DateTime.parse(json['postDate']),
    );
  }
}