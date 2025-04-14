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

  int get getPostID {
    return _postID;
  }

  String get getContent {
    return _content;
  }

  Account get getAccount {
    return _account;
  }

  String get getPostDate {
    return "${DateFormat('yyyy-MM-dd').format(_postDate)} at ${DateFormat('hh:mm').format(_postDate)}";
  }

  int get getLikes {
    return _likes;
  }

  int get getDislikes {
    return _dislikes;
  }

  int get getCommentCount {
    return _commentCount;
  }

  int get getLiked {
    return _liked;
  }

  String? get getImageUrl {
    return _imageUrl;
  }

  String? get getLocation {
    return _location;
  }

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