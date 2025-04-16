import 'package:untitled/models/account.dart';
import 'package:intl/intl.dart';

class Post {
  final int _postID;
  final String _content;
  final Account _account;
  final DateTime _postDate;
  final int _likes;
  final int _dislikes;
  final int _commentCount;
  final int _liked;
  final String? _imageUrl;
  final String? _location;

  Post({
    required int postID,
    required String content,
    required Account account,
    required DateTime postDate,
    required int likes,
    required int dislikes,
    required int commentCount,
    required int liked,
    String? imageUrl,
    String? location,
  })  : _postID = postID,
        _content = content,
        _account = account,
        _postDate = postDate,
        _likes = likes,
        _dislikes = dislikes,
        _commentCount = commentCount,
        _liked = liked,
        _imageUrl = imageUrl,
        _location = location;

  int get getPostID => _postID;
  String get getContent => _content;
  Account get getAccount => _account;

  String get getTimeSinceSent {
    final now = DateTime.now();
    final difference = now.difference(_postDate);

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

  int get getLikes => _likes;
  int get getDislikes => _dislikes;
  int get getCommentCount => _commentCount;
  int get getLiked => _liked;
  String? get getImageUrl => _imageUrl;
  String? get getLocation => _location;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postID: json['postID'],
      content: json.containsKey('postContent') ? json['postContent'] : json['content'],
      account: Account.fromJson(json),
      postDate: DateTime.parse(json['postDate']),
      likes: json['likes'],
      dislikes: json['dislikes'],
      commentCount: json['commentCount'],
      liked: json['liked'],
      imageUrl: json.containsKey('imageUrl') ? json['imageUrl'] as String? : null,
      location: json.containsKey('location') ? json['location'] as String? : null,
    );
  }
}