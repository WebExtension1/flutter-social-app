import 'package:flutter/material.dart';

class CommentPreview extends StatefulWidget {
  const CommentPreview({super.key});

  @override
  State<CommentPreview> createState() => _CommentPreviewState();
}

class _CommentPreviewState extends State<CommentPreview> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(),
                SizedBox(width: 10),
                Text("Username"),
                Expanded(
                  child: SizedBox()
                ),
                Text("Date"),
                SizedBox(width: 10)
              ],
            ),
            Text("Message"),
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
                          print("Like Comment");
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
                          print("Dislike Comment");
                        },
                        icon: Icon(Icons.thumb_down_outlined)
                      ),
                      Text("3")
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
}
