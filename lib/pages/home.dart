import 'package:flutter/material.dart';

// Pages
import 'package:untitled/pages/new_post_form.dart';

// Models
import 'package:untitled/models/account.dart';

// Widgets
import 'package:untitled/widgets/post_preview.dart';

//APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:untitled/providers/shared_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  Account? account;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Feed"),
      ),
      body: dataService.user == null ? Center(child: CircularProgressIndicator()) : Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: dataService.user!.getImageUrl != null
                          ? NetworkImage("$apiUrl${dataService.user!.getImageUrl!}")
                          : null,
                      child: dataService.user!.getImageUrl == null
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
              child: RefreshIndicator(
                onRefresh: dataService.getFeed,
                child: ListView.builder(
                  itemCount: dataService.feed.length,
                  itemBuilder: (context, index) {
                    return PostPreview(
                      post: dataService.feed[index],
                      onDelete: () {
                        setState(() {
                          dataService.feed.removeAt(index);
                        });
                      },
                      account: dataService.user!
                    );
                  }
                )
              ),
            )
          ]
        )
      )
    );
  }

  void displayNewPost() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPostForm()),
    );
  }
}