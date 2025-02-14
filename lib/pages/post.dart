import 'package:flutter/material.dart';
import 'package:untitled/widgets/commentPreview.dart';
import 'package:untitled/models/post.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.post});
  final Post post;

  @override
  State<PostPage> createState() => _PostState();
}

class _PostState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.post.getAccount.getUsername} Post"),
      ),
      body: Padding(
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
                Text(widget.post.getPostDate.toString()),
                SizedBox(width: 10)
              ],
            ),
            Text(widget.post.getContent),
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
                          print("Like Post");
                        },
                        icon: Icon(Icons.thumb_up_outlined)
                      ),
                      Text("100")
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
                          print("Dislike Post");
                        },
                        icon: Icon(Icons.thumb_down_outlined)
                      ),
                      Text("3")
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
            Text("Comments"),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CommentPreview();
                },
              ),
            ),
          ],
        )
      )
    );
  }
}
