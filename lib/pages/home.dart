import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/new_post_form.dart';

// Widgets
import 'package:badbook/widgets/post_preview.dart';

//APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !_showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = true;
        });
      } else if (_scrollController.offset <= 100 && _showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Feed"),
      ),
      body: dataService.user == null ? const Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
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
                        onTap: _displayNewPost,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Share what's on your mind"),
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
                  controller: _scrollController,
                  itemCount: dataService.feed.length,
                  itemBuilder: (context, index) {
                    return PostPreview(
                      post: dataService.feed[index],
                      account: dataService.user!
                    );
                  }
                )
              ),
            )
          ]
        )
      ),
      floatingActionButton: _showScrollToTopButton == false ? null : FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOut
          );
        },
        child: const Icon(Icons.arrow_upward)
      )
    );
  }

  void _displayNewPost() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPostForm()),
    );
  }
}