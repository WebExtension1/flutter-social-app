import 'package:flutter/material.dart';
import 'package:untitled/widgets/commentPreview.dart';
import 'package:untitled/models/post.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/widgets/commentForm.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.post, required this.comment});
  final Post post;
  final bool comment;

  @override
  State<PostPage> createState() => _PostState();
}

class _PostState extends State<PostPage> {
  final List<Post> comments = [
    Post(content: "Comment text", account: Account(username: "Third User", tag: "User3", dateJoined: DateTime.now()), postDate: DateTime.now())
  ];

  int liked = 0;
  int likes = 100;
  int dislikes = 3;

  @override
  void initState() {
    super.initState();
    if (widget.comment) {
      // Delay the display of the new comment sheet until after the widget is initialised. Not doing this caused errors.
      // https://stackoverflow.com/questions/49466556/flutter-run-method-on-widget-build-complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        displayNewComment();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.post.getAccount.getUsername} Post"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
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
                  Text(widget.post.getPostDate.toString()),
                  SizedBox(width: 10)
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
                  GestureDetector(
                    child: Row(
                      children: [
                        Icon(Icons.comment),
                        SizedBox(width: 10),
                        Text("32")
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
                    CircleAvatar(),
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
                  return CommentPreview(comment: comments[index]);
                },
              )
            ],
          )
        )
      )
    );
  }

  void displayNewComment() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => CommentForm()
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
