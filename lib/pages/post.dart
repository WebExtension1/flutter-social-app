import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/profile.dart';

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
import 'package:firebase_auth/firebase_auth.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int liked = 0;
  int likes = 0;
  int dislikes = 0;
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    _loadComments();
    if (widget.comment) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _displayNewComment();
      });
    }
    likes = widget.post.getLikes;
    dislikes = widget.post.getDislikes;
    liked = widget.post.getLiked;
    if (liked == 1) {
      likes = likes - 1;
    } else if (liked == 2) {
      dislikes = dislikes - 1;
    }
  }

  Future<void> _loadComments() async {
    final dataService = Provider.of<DataService>(context, listen: false);
    await dataService.getComments(widget.post.getPostID);
    commentCount = dataService.comments[widget.post.getPostID]!.length;
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: Column (
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
                              onPressed: () {
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
                            Text((likes + _isLiked).toString())
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
                            Text((dislikes + _isDisliked).toString())
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: Row(
                          children: [
                            const Icon(Icons.comment),
                            const SizedBox(width: 10),
                            Text(commentCount.toString())
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

  void _openProfile() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: DataService(),
          child: Profile(account: widget.post.getAccount),
        ),
      ),
    );
  }

  int get _isLiked {
    if (liked == 1) {
      return 1;
    }
    return 0;
  }

  int get _isDisliked {
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
