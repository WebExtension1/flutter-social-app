import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/widgets/comment_preview.dart';
import 'package:untitled/pages/profile.dart';
import 'package:untitled/models/post.dart';
import 'package:untitled/models/comment.dart';
import 'package:untitled/widgets/comment_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.post, required this.comment, required this.account});
  final Post post;
  final bool comment;
  final Account account;

  @override
  State<PostPage> createState() => _PostState();
}

class _PostState extends State<PostPage> {
  List<Comment> comments = [];
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int? liked = 0;
  int? likes = 0;
  int? dislikes = 0;
  int? commentCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    if (widget.comment) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        displayNewComment();
      });
    }
    likes = widget.post.getLikes;
    dislikes = widget.post.getDislikes;
    liked = widget.post.getLiked;
    if (liked == 1) {
      likes = likes! - 1;
    } else if (liked == 2) {
      dislikes = dislikes! - 1;
    }
  }

  Future<void> _fetchComments() async {
    final response = await http.post(
      Uri.parse('$apiUrl/comment/get'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'postID': widget.post.getPostID , 'email': _auth.currentUser?.email}),
    );

    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = json.decode(response.body);
        comments = List<Comment>.from(
            jsonResponse.map((comment) => Comment.fromJson(comment))
        );
        commentCount = comments.length;
      });
    } else {
      setState(() {
        comments = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: openProfile,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: widget.post.getAccount.getImageUrl != null
                              ? NetworkImage("$apiUrl${widget.post.getAccount.getImageUrl!}")
                              : null,
                          child: widget.post.getAccount.getImageUrl == null
                              ? Icon(Icons.person)
                              : null,
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              widget.post.getAccount.getName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.post.getAccount.getUsername,
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
                  Text(widget.post.getPostDate),
                  SizedBox(width: 10),
                  if (_auth.currentUser?.email == widget.post.getAccount.getEmail)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        deletePost();
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Post'),
                        )
                      ],
                      icon: Icon(Icons.more_vert),
                    ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 10),
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
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                      "$apiUrl${widget.post.getImageUrl!}",
                      fit: BoxFit.cover
                  ),
                ),
              ],
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
                            resetInteraction();
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
                        Text((likes! + isLiked).toString())
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
                        Text((dislikes! + isDisliked).toString())
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Row(
                      children: [
                        Icon(Icons.comment),
                        SizedBox(width: 10),
                        Text(commentCount.toString())
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(19, 5, 19, 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: widget.account.getImageUrl != null
                          ? NetworkImage("$apiUrl${widget.account.getImageUrl!}")
                          : null,
                      child: widget.account.getImageUrl == null
                          ? Icon(Icons.person)
                          : null,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: displayNewComment,
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
                    ),
                  ],
                )
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return CommentPreview(
                    comment: comments[index],
                    onDelete: () {
                      setState(() {
                        comments.removeAt(index);
                      });
                    },
                    account: widget.account
                  );
                },
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
      Navigator.pop(context, 'popped');
    }
  }

  void displayNewComment() async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (ctx) => CommentForm(postID: widget.post.getPostID)
    );
    if (result == 'popped') {
      _fetchComments();
    }
  }

  void openProfile() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(account: widget.post.getAccount)),
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
