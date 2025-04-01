import 'package:flutter/material.dart';
import 'package:untitled/models/comment.dart';
import 'package:untitled/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommentPreview extends StatefulWidget {
  final VoidCallback onDelete;
  const CommentPreview({super.key, required this.onDelete, required this.comment});
  final Comment comment;

  @override
  State<CommentPreview> createState() => _CommentPreviewState();
}

class _CommentPreviewState extends State<CommentPreview> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  int liked = 0;
  int likes = 100;
  int dislikes = 3;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: openProfile,
                  child: Row(
                    children: [
                      CircleAvatar(),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          Text(
                            widget.comment.getAccount.getName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${widget.comment.getAccount.getUsername}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: SizedBox()
                ),
                Text(widget.comment.getSentDate),
                SizedBox(width: 10),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      deleteComment();
                    } else if (value == 'follow') {
                      followUser();
                    }
                  },
                  itemBuilder: (context) => [
                    if (widget.comment.getAccount.getEmail == _auth.currentUser?.email)
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Comment'),
                      )
                    else
                      PopupMenuItem(
                        value: 'follow',
                        child: Text('Follow User'),
                      ),
                  ],
                  icon: Icon(Icons.more_vert),
                ),
                SizedBox(width: 10),
              ],
            ),
            Text(widget.comment.getContent),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (liked == 1) {
                            setState(() {
                              liked = 0;
                            });
                          } else {
                            setState(() {
                              liked = 1;
                            });
                          }
                        },
                        icon: Icon(
                          liked == 1 ? Icons.thumb_up : Icons.thumb_up_outlined,
                        ),
                      ),
                      Text((likes + isLiked).toString())
                    ],
                  ),
                ),
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (liked == 2) {
                            setState(() {
                              liked = 0;
                            });
                          } else {
                            setState(() {
                              liked = 2;
                            });
                          }
                        },
                        icon: Icon(
                          liked == 2 ? Icons.thumb_down : Icons.thumb_down_outlined,
                        ),
                      ),
                      Text((dislikes + isDisliked).toString())
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void deleteComment() async {
    final response = await http.post(
      Uri.parse('$apiUrl/post/delete'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'postID': widget.comment.getCommentID}),
    );

    if (response.statusCode == 200) {
      widget.onDelete();
    }
  }

  void followUser() {

  }

  void openProfile() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(account: widget.comment.getAccount)),
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
}
