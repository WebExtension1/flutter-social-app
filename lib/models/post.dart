import 'package:badbook/models/account.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final int _postID;
  final String _content;
  final Account _account;
  final DateTime _postDate;
  int _likes;
  int _dislikes;
  final int _commentCount;
  int _liked;
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
  set setLiked(int value) {
    _liked = value;
  }
  String? get getImageUrl => _imageUrl;
  String? get getLocation => _location;

  Future<void> likePost() async {
    await http.post(
      Uri.parse('$apiUrl/post/like'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'postID': _postID}),
    );
    _likes++;
    if (_liked == 2) {
      _dislikes--;
    }
  }

  Future<void> dislikePost() async {
    await http.post(
      Uri.parse('$apiUrl/post/dislike'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'postID': _postID}),
    );
    _dislikes++;
    if (_liked == 1) {
      _likes--;
    }
  }

  Future<void> resetInteraction(String origin) async {
    await http.post(
      Uri.parse('$apiUrl/post/resetInteraction'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'postID': _postID}),
    );

    if (origin == 'like') {
      _likes--;
    } else {
      _dislikes--;
    }
  }

  int get isLiked {
    if (_liked == 1) {
      return 1;
    }
    return 0;
  }

  int get isDisliked {
    if (_liked == 2) {
      return 1;
    }
    return 0;
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