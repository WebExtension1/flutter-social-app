import 'package:flutter/material.dart';
import 'package:untitled/pages/newPostForm.dart';
import 'package:untitled/widgets/postPreview.dart';
import 'package:untitled/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Post> posts = [];
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final response = await http.post(
      Uri.parse('$apiUrl/post/get'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Feed"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                child: Row(
                  children: [
                    CircleAvatar(),
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
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text(
                            "Share what's on your mind",
                            style: TextStyle(color: Colors.grey),
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
                  return PostPreview(post: posts[index]);
                },
              ),
            ),
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