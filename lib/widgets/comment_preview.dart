import 'package:flutter/material.dart';
import 'package:badbook/models/account.dart';
import 'package:badbook/models/comment.dart';
import 'package:badbook/pages/post.dart';
import 'package:badbook/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommentPreview extends StatefulWidget {
  final VoidCallback onDelete;
  const CommentPreview({super.key, required this.onDelete, required this.comment, this.displayTop, required this.account});
  final Comment comment;
  final bool? displayTop;
  final Account account;

  @override
  State<CommentPreview> createState() => _CommentPreviewState();
}

class _CommentPreviewState extends State<CommentPreview> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

  int? liked = 0;
  int? likes = 0;
  int? dislikes = 0;

  @override
  void initState() {
    super.initState();
    likes = widget.comment.getLikes;
    dislikes = widget.comment.getDislikes;
    liked = widget.comment.getLiked;
    if (liked == 1) {
      likes = likes! - 1;
    } else if (liked == 2) {
      dislikes = dislikes! - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            if (widget.displayTop == true) ...[
              if (widget.comment.getPost!.getPostID == 1)
                Text("Post has been deleted")
              else
                GestureDetector(
                  onTap: displayPost,
                  child: Text("Go to Post"),
                ),
              Divider(),
            ],
            Row(
              children: [
                GestureDetector(
                  onTap: openProfile,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: widget.comment.getAccount.getImageUrl != null
                            ? NetworkImage("$apiUrl${widget.comment.getAccount.getImageUrl!}")
                            : null,
                        child: widget.comment.getAccount.getImageUrl == null
                            ? Icon(Icons.person)
                            : null,
                      ),
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
                            widget.comment.getAccount.getUsername,
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
                Text(widget.comment.getTimeSinceSent),
                SizedBox(width: 10),
                if (_auth.currentUser?.email == widget.comment.getAccount.getEmail)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      deleteComment();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Comment'),
                      )
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
                            resetInteraction();
                            setState(() {
                              liked = 0;
                            });
                          } else {
                            likeComment();
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
                            dislikeComment();
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

  void likeComment() async {
    await http.post(
      Uri.parse('$apiUrl/comment/like'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'commentID': widget.comment.getCommentID}),
    );
  }

  void dislikeComment() async {
    await http.post(
      Uri.parse('$apiUrl/comment/dislike'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'commentID': widget.comment.getCommentID}),
    );
  }

  void resetInteraction() async {
    await http.post(
      Uri.parse('$apiUrl/comment/resetInteraction'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'commentID': widget.comment.getCommentID}),
    );
  }

  void displayPost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => PostPage(post: widget.comment.getPost!, comment: false)),
    );
    if (result == 'popped') {
      widget.onDelete();
    }
  }
}
