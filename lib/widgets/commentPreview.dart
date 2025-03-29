import 'package:flutter/material.dart';
import 'package:untitled/models/comment.dart';

class CommentPreview extends StatefulWidget {
  const CommentPreview({super.key, required this.comment});
  final Comment comment;

  @override
  State<CommentPreview> createState() => _CommentPreviewState();
}

class _CommentPreviewState extends State<CommentPreview> {
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
                CircleAvatar(),
                SizedBox(width: 10),
                Text(widget.comment.getAccount.getUsername),
                Expanded(
                  child: SizedBox()
                ),
                Text(widget.comment.getSentDate),
                SizedBox(width: 10)
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
