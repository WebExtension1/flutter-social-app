import 'package:untitled/models/account.dart';
import 'package:intl/intl.dart';

class Post {
  final int postID;
  final String content;
  final Account account;
  final DateTime postDate;
  final int? likes;
  final int? dislikes;
  final int? commentCount;
  final int? liked;

  Post({
    required this.postID,
    required this.content,
    required this.account,
    required this.postDate,
    this.likes,
    this.dislikes,
    this.commentCount,
    this.liked
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

  int? get getLikes {
    return likes;
  }

  int? get getDislikes {
    return dislikes;
  }

  int? get getCommentCount {
    return commentCount;
  }

  int? get getLiked {
    return liked;
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postID: json['postID'],
      content: json['content'],
      account: Account.fromJson(json),
      postDate: DateTime.parse(json['postDate']),
      likes: json.containsKey('likes') ? json['likes'] as int? : null,
      dislikes: json.containsKey('dislikes') ? json['dislikes'] as int? : null,
      commentCount: json.containsKey('commentCount') ? json['commentCount'] as int? : null,
      liked: json.containsKey('liked') ? json['liked'] as int? : null,
    );
  }
}