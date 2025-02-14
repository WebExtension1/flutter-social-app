import 'package:flutter/material.dart';
import 'package:untitled/widgets/newPostForm.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
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
            Card(
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
                    Text("Message")
                  ],
                )
              )
            )
          ]
        )
      )
    );
  }

  void displayNewPost() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true, // Enables a modal-style transition
        builder: (ctx) => const NewPostForm(),
      ),
    );
  }
}