import 'package:untitled/models/account.dart';
import 'package:untitled/models/post.dart';
import 'package:intl/intl.dart';

class Comment {
  final int _commentID;
  final String _content;
  final DateTime _sentDate;
  final Account _account;
  final Post? _post;
  final int _likes;
  final int _dislikes;
  final int _liked;

  Comment({
    required int commentID,
    required String content,
    required DateTime sentDate,
    required Account account,
    Post? post,
    required int likes,
    required int dislikes,
    required int liked,
  })  : _commentID = commentID,
        _content = content,
        _sentDate = sentDate,
        _account = account,
        _post = post,
        _likes = likes,
        _dislikes = dislikes,
        _liked = liked;

  int get getCommentID {
    return _commentID;
  }

  String get getContent {
    return _content;
  }

  String get getSentDate {
    return "${DateFormat('yyyy-MM-dd').format(_sentDate)} at ${DateFormat('hh:mm').format(_sentDate)}";
  }

  Account get getAccount {
    return _account;
  }

  Post? get getPost {
    return _post;
  }

  int get getLikes {
    return _likes;
  }

  int get getDislikes {
    return _dislikes;
  }

  int get getLiked {
    return _liked;
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentID: json['commentID'],
      content: json['commentContent'],
      sentDate: DateTime.parse(json['sentDate']),
      account: Account.fromJson(json),
      post: json['postID'] != null ? Post.fromJson(json) : null,
      likes: json['likes'],
      dislikes: json['dislikes'],
      liked: json['liked'],
    );
  }
}