import 'package:flutter/material.dart';
import 'package:untitled/models/post.dart';
import 'package:untitled/pages/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostPreview extends StatefulWidget {
  final VoidCallback onDelete;
  const PostPreview({required this.post, required this.onDelete, Key? key}) : super(key: key);
  final Post post;

  @override
  State<PostPreview> createState() => _PostState();
}

class _PostState extends State<PostPreview> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  int liked = 0;
  int likes = 100;
  int dislikes = 3;

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
                  CircleAvatar(),
                  SizedBox(width: 10),
                  Text(widget.post.getAccount.getUsername),
                  Expanded(
                    child: SizedBox()
                  ),
                  Text(widget.post.getPostDate),
                  SizedBox(width: 10),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        deletePost();
                      } else if (value == 'follow') {
                        followUser();
                      }
                    },
                    itemBuilder: (context) => [
                      if (widget.post.getAccount.getEmail == _auth.currentUser?.email)
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Post'),
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
              Padding(
                padding: EdgeInsets.fromLTRB(51, 5, 5, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      widget.post.getContent
                  ),
                ),
              ),
              Row(
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
                  Text((likes + isLiked).toString()),
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
                  Text((dislikes + isDisliked).toString()),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: GestureDetector(
                        onTap: () {
                          print("Comment");
                        },
                        child: Row(
                          children: [
                            Icon(Icons.comment),
                            SizedBox(width: 8),
                            Text("32"),
                            SizedBox(width: 8),
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
                                  child: Text(
                                    "Reply",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
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
      widget.onDelete();
    }
  }

  void followUser() {

  }

  void displayPost(bool commentToSend) async {
    final result = await Navigator.push(
      context,
        MaterialPageRoute(builder: (ctx) => PostPage(post: widget.post, comment: commentToSend)),
    );
    if (result == 'popped') {
      widget.onDelete();
    }
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
