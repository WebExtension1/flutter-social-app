import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          title: Text("My profile page"),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("images/myProfilePic.jpg"),
              ),
              Text(
                "Super Cool Software Dev Man",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Times New Roman",
                  fontWeight: FontWeight.bold,
                )
              ),
              Text(
                "Software Developer",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Times New Roman",
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(
                height: 10,
                width: 400,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Card(
                margin: EdgeInsets.only(right:50, left:50),
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("01234 567 890"),
                ),
              )
            ],
          )
        )
      ),
    );
  }
}

