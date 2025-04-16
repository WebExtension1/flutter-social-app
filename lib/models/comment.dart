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

  int get getCommentID => _commentID;
  String get getContent => _content;

  String get getTimeSinceSent {
    final now = DateTime.now();
    final difference = now.difference(_sentDate);

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

  Account get getAccount => _account;
  Post? get getPost => _post;
  int get getLikes => _likes;
  int get getDislikes => _dislikes;
  int get getLiked => _liked;

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