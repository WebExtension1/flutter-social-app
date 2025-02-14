import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/pages/newPostForm.dart';
import 'package:untitled/widgets/postPreview.dart';
import 'package:untitled/models/post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final List<Post> posts = [
    Post(content: "First post details", account: Account(username: "User 1", tag: "User1", dateJoined: DateTime.now()), postDate: DateTime.now()),
    Post(content: "Other post to display", account: Account(username: "User 2", tag: "User2", dateJoined: DateTime.now()), postDate: DateTime.now())
  ];

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

  void displayNewPost() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewPostForm(),
      ),
    );
  }
}