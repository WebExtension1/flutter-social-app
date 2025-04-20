import 'package:flutter/material.dart';

// Models
import 'package:badbook/models/post.dart';

// Widgets
import 'package:badbook/widgets/comment_preview.dart';
import 'package:badbook/widgets/comment_form.dart';
import 'package:badbook/widgets/account_bar.dart';

// APIs
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.post, required this.comment});
  final Post post;
  final bool comment;

  @override
  State<PostPage> createState() => _PostState();
}

class _PostState extends State<PostPage> {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

  @override
  void initState() {
    super.initState();
    _loadComments();
    if (widget.comment) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _displayNewComment();
      });
    }
  }

  Future<void> _loadComments() async {
    final dataService = Provider.of<DataService>(context, listen: false);
    await dataService.getComments(widget.post.getPostID);
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        AccountBar(account: widget.post.getAccount, clickable: true),
                        Expanded(
                            child: SizedBox()
                        ),
                        Text(widget.post.getTimeSinceSent),
                        SizedBox(width: 10),
                        if (dataService.user!.getEmail == widget.post.getAccount.getEmail)
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              _deletePost();
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete Post'),
                              )
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (widget.post.getLocation != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(51, 5, 5, 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "📍 ${widget.post.getLocation!}",
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(51, 5, 5, 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.post.getContent
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: Row(
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
                              Text((widget.post.getLikes).toString())
                            ],
                          ),
                        ),
                        Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: Row(
                            children: [
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
                              Text((widget.post.getDislikes).toString())
                            ],
                          ),
                        ),
                        GestureDetector(
                          child: Row(
                            children: [
                              const Icon(Icons.comment),
                              const SizedBox(width: 10),
                              Text(widget.post.getCommentCount.toString())
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Comments",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                )
              )
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(19, 0, 19, 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: dataService.user!.getImageUrl != null
                      ? NetworkImage("$apiUrl${dataService.user!.getImageUrl!}")
                      : null,
                    child: dataService.user!.getImageUrl == null
                      ? const Icon(Icons.person)
                      : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: _displayNewComment,
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
                  ),
                ],
              )
            ),
            dataService.comments[widget.post.getPostID] != null
              ? (dataService.comments[widget.post.getPostID]!.isNotEmpty
                ? Expanded (
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataService.comments[widget.post.getPostID]!.length,
                    itemBuilder: (context, index) {
                      return CommentPreview(
                        comment: dataService.comments[widget.post.getPostID]![index],
                        onDelete: () {
                          setState(() {
                            dataService.comments[widget.post.getPostID]!.removeAt(index);
                          });
                        },
                        account: dataService.user!,
                      );
                    },
                  )
                ) : const Center(child: Text("Be the first to comment!")))
              : const Center(child: CircularProgressIndicator())
          ]
        )
      )
    );
  }

  void _deletePost() async {
    final response = await http.post(
      Uri.parse('$apiUrl/post/delete'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'postID': widget.post.getPostID}),
    );

    if (response.statusCode == 200) {
      if (!mounted) return;
      final dataService = Provider.of<DataService>(context, listen: false);
      await dataService.getFeed();

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _displayNewComment() async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => CommentForm(postID: widget.post.getPostID)
    );
  }
}
