import 'package:untitled/models/account.dart';
import 'package:untitled/models/post.dart';
import 'package:intl/intl.dart';

class Comment {
  final int commentID;
  final String content;
  final DateTime sentDate;
  final Account accountID;
  final Post? postID;
  final int? likes;
  final int? dislikes;
  final int? liked;

  Comment({
    required this.commentID,
    required this.content,
    required this.sentDate,
    required this.accountID,
    this.postID,
    this.likes,
    this.dislikes,
    this.liked
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

  int get getCommentID {
    return commentID;
  }

  int? get getLikes {
    return likes;
  }

  int? get getDislikes {
    return dislikes;
  }

  int? get getLiked {
    return liked;
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentID: json['commentID'],
      content: json['commentContent'],
      sentDate: DateTime.parse(json['sentDate']),
      accountID: Account.fromJson(json),
      postID: json.containsKey('postID') ? Post.fromJson(json) : null,
      likes: json.containsKey('likes') ? json['likes'] as int? : null,
      dislikes: json.containsKey('dislikes') ? json['dislikes'] as int? : null,
      liked: json.containsKey('liked') ? json['liked'] as int? : null,
    );
  }
}