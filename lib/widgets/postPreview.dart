import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/models/post.dart';
import 'package:untitled/pages/post.dart';

class PostPreview extends StatefulWidget {
  const PostPreview({super.key, required this.post});
  final Post post;

  @override
  State<PostPreview> createState() => _PostState();
}

class _PostState extends State<PostPreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        displayPost();
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
                  SizedBox(width: 10)
                ],
              ),
              Text(widget.post.getContent),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      print("Like Post");
                    },
                    icon: Icon(Icons.thumb_up_outlined)
                  ),
                  Text("100"),
                  IconButton(
                    onPressed: () {
                      print("Dislike Post");
                    },
                    icon: Icon(Icons.thumb_down_outlined)
                  ),
                  Text("3"),
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
                                  print("Comment");
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

  void displayPost() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => PostPage(post: widget.post)
        )
    );
  }
}
