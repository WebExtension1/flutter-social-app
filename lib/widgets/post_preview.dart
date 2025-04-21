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

  @override
  void initState() {
    super.initState();
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
                    widget.post.getContent,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
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
                    onPressed: () async {
                      if (widget.post.getLiked == 1) {
                        await widget.post.resetInteraction('like');
                        setState(() {
                          widget.post.setLiked = 0;
                        });
                      } else {
                        await widget.post.likePost();
                        setState(() {
                          widget.post.setLiked = 1;
                        });
                      }
                    },
                    icon: Icon(
                      widget.post.getLiked == 1 ? Icons.thumb_up : Icons.thumb_up_outlined,
                    ),
                  ),
                  Text((widget.post.getLikes).toString()),
                  IconButton(
                    onPressed: () async {
                      if (widget.post.getLiked == 2) {
                        await widget.post.resetInteraction('dislike');
                        setState(() {
                          widget.post.setLiked = 0;
                        });
                      } else {
                        await widget.post.dislikePost();
                        setState(() {
                          widget.post.setLiked = 2;
                        });
                      }
                    },
                    icon: Icon(
                      widget.post.getLiked == 2 ? Icons.thumb_down : Icons.thumb_down_outlined,
                    ),
                  ),
                  Text((widget.post.getDislikes).toString()),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: Row(
                        children: [
                          const Icon(Icons.comment),
                          const SizedBox(width: 8),
                          Text(widget.post.getCommentCount.toString()),
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
    bool success = await widget.post.deletePost();

    if (success) {
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

    if (!mounted) return;
    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.getFeed();
  }
}
