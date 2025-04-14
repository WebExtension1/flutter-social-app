import 'package:flutter/material.dart';
import 'package:untitled/pages/new_post_form.dart';
import 'package:untitled/widgets/post_preview.dart';
import 'package:untitled/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/models/account.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.account});
  final Account? account;

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Post> posts = [];
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Account? account;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    loading = false;
  }

  Future<void> _fetchPosts() async {
    final response = await http.post(
      Uri.parse('$apiUrl/post/feed'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email}),
    );

    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = json.decode(response.body);
        posts = List<Post>.from(
            jsonResponse.map((post) => Post.fromJson(post))
        );
      });
    } else {
      setState(() {
        posts = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Feed"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              color: theme.cardColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: widget.account!.getImageUrl != null
                          ? NetworkImage("$apiUrl${widget.account!.getImageUrl!}")
                          : null,
                      child: widget.account!.getImageUrl == null
                          ? Icon(Icons.person)
                          : null,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: displayNewPost,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Share what's on your mind"
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              )
            ),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return PostPreview(
                    post: posts[index],
                    onDelete: () {
                      setState(() {
                        posts.removeAt(index);
                      });
                    },
                    account: widget.account!
                  );
                }
              ),
            )
          ]
        )
      )
    );
  }

  void displayNewPost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPostForm()),
    );
    if (result == 'popped') {
      _fetchPosts();
    }
  }
}