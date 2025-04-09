import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/models/comment.dart';
import 'package:untitled/widgets/commentPreview.dart';
import 'package:untitled/widgets/postPreview.dart';
import 'package:untitled/pages/settings.dart';
import 'package:untitled/models/post.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key, this.account});
  final Account? account;

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  List<Post> posts = [];
  List<Comment> comments = [];
  Account? account;
  bool loading = true;
  int displayType = 1;
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    account = widget.account!;
    _fetchPosts();
    loading = false;
  }

  Future<void> _fetchPosts() async {
    final response = await http.post(
      Uri.parse('$apiUrl/post/get'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'account': widget.account?.getEmail}),
    );

    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = json.decode(response.body);
        posts = List<Post>.from(
          jsonResponse['posts'].map((post) => Post.fromJson(post))
        );
        comments = List<Comment>.from(
          jsonResponse['comments'].map((comment) => Comment.fromJson(comment))
        );
      });
    } else {
      setState(() {
        posts = [];
        comments = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          account != null && account!.getEmail == _auth.currentUser?.email
            ? IconButton(onPressed: displaySettings, icon: Icon(Icons.settings))
            : IconButton(onPressed: displayOptions, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
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
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      account!.getName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${account!.getUsername}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Member since ${widget.account!.getJoinDate}"),
            SizedBox(height: 10),
            Text("${posts.length} Post${posts.length != 1 ? 's' : ''}"),
            SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      displayType = 1;
                    });
                  },
                  child: Text("Posts"),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      displayType = 2;
                    });
                  },
                  child: Text("Comments"),
                )
              ],
            ),
            if (displayType == 1)
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
                    );
                    }
                ),
              ),
            if (displayType == 2)
              Expanded(
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentPreview(
                      comment: comments[index],
                      onDelete: () {
                        setState(() {
                          comments.removeAt(index);
                        });
                      },
                    );
                  }
                ),
              )
          ],
        ),
      )
    );
  }

  void displaySettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const Settings(),
      ),
    );
  }

  void displayOptions() {

  }
}