import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/post.dart';

// Models
import 'package:badbook/models/account.dart';
import 'package:badbook/models/post.dart';

// Widgets
import 'package:badbook/widgets/account_bar.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class PostPreview extends StatefulWidget {
  const PostPreview({required this.post, required this.account, super.key});
  final Post post;
  final Account account;

  @override
  State<PostPreview> createState() => _PostState();
}

class _PostState extends State<PostPreview> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

  int? liked = 0;
  int? likes = 0;
  int? dislikes = 0;
  int? comments = 0;

  @override
  void initState() {
    super.initState();
    likes = widget.post.getLikes;
    dislikes = widget.post.getDislikes;
    comments = widget.post.getCommentCount;
    liked = widget.post.getLiked;
    if (liked == 1) {
      likes = likes! - 1;
    } else if (liked == 2) {
      dislikes = dislikes! - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        displayPost(false);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  AccountBar(account: widget.post.getAccount, clickable: true),
                  const Expanded(
                    child: SizedBox()
                  ),
                  Text(widget.post.getTimeSinceSent),
                  const SizedBox(width: 10),
                  if (_auth.currentUser?.email == widget.post.getAccount.getEmail)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        deletePost();
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: const Text('Delete Post'),
                        )
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  const SizedBox(width: 10),
                ],
              ),
              if (widget.post.getLocation != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(51, 5, 5, 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "📍 ${widget.post.getLocation!}",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(51, 5, 5, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.post.getContent
                  ),
                ),
              ),
              if (widget.post.getImageUrl != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "$apiUrl${widget.post.getImageUrl!}",
                    fit: BoxFit.cover
                  ),
                ),
              ],
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (liked == 1) {
                        resetInteraction();
                        setState(() {
                          liked = 0;
                        });
                      } else {
                        likePost();
                        setState(() {
                          liked = 1;
                        });
                      }
                    },
                    icon: Icon(
                      liked == 1 ? Icons.thumb_up : Icons.thumb_up_outlined,
                    ),
                  ),
                  Text((likes! + isLiked).toString()),
                  IconButton(
                    onPressed: () {
                      if (liked == 2) {
                        resetInteraction();
                        setState(() {
                          liked = 0;
                        });
                      } else {
                        dislikePost();
                        setState(() {
                          liked = 2;
                        });
                      }
                    },
                    icon: Icon(
                      liked == 2 ? Icons.thumb_down : Icons.thumb_down_outlined,
                    ),
                  ),
                  Text((dislikes! + isDisliked).toString()),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: Row(
                        children: [
                          const Icon(Icons.comment),
                          const SizedBox(width: 8),
                          Text(comments.toString()),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                displayPost(true);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 10
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: const Text(
                                  "Reply",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        )
      )
    );
  }

  void deletePost() async {
    final response = await http.post(
      Uri.parse('$apiUrl/post/delete'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'postID': widget.post.getPostID}),
    );

    if (response.statusCode == 200) {
      if (!mounted) return;
      final dataService = Provider.of<DataService>(context, listen: false);
      await dataService.getFeed();
    }
  }

  void displayPost(bool commentToSend) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => PostPage(post: widget.post, comment: commentToSend))
    );
  }

  int get isLiked {
    if (liked == 1) {
      return 1;
    }
    return 0;
  }

  int get isDisliked {
    if (liked == 2) {
      return 1;
    }
    return 0;
  }

  void likePost() async {
    await http.post(
      Uri.parse('$apiUrl/post/like'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'postID': widget.post.getPostID}),
    );
  }

  void dislikePost() async {
    await http.post(
      Uri.parse('$apiUrl/post/dislike'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'postID': widget.post.getPostID}),
    );
  }

  void resetInteraction() async {
    await http.post(
      Uri.parse('$apiUrl/post/resetInteraction'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'postID': widget.post.getPostID}),
    );
  }
}
