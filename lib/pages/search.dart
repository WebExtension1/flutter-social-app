import 'package:flutter/material.dart';

// Models
import 'package:badbook/models/post.dart';
import 'package:badbook/models/account.dart' as account_model;

// Widgets
import 'package:badbook/widgets/account_preview.dart';
import 'package:badbook/widgets/post_preview.dart';

// Services
import 'package:badbook/services/socket_service.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

// Speech
import 'package:speech_to_text/speech_to_text.dart' as speech_to_text;
import 'package:permission_handler/permission_handler.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  final SocketService socketService = SocketService();
  List<Post> posts = [];
  List<account_model.Account> accounts = [];
  late speech_to_text.SpeechToText speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    speech = speech_to_text.SpeechToText();
    Permission.microphone.request();
    _searchController.addListener(_onSearchChanged);
    socketService.socket.on("search", (data) {
      setState(() {
        accounts = List<account_model.Account>.from(
          data['accounts'].map((account) => account_model.Account.fromJson(account))
        );
        posts = List<Post>.from(
          data['posts'].map((post) => Post.fromJson(post))
        );
      });
    });
  }

  void _onSearchChanged() {
    setState(() {
      socketService.search(_searchController.text);
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await speech.initialize();

      if (available) {
        setState(() => _isListening = true);
        speech.listen(
          onResult: (query) {
            setState(() {
              _searchController.text = query.recognizedWords;
              _isListening = false;
            });
            _onSearchChanged();
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _listen,
                ),
              ),
            )
          ),
          if (_searchController.text.trim().isEmpty && dataService.contacts.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Contacts",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: dataService.contacts.map((account) {
                          return Row(
                            children: [
                              AccountPreview(account: account),
                              Padding(padding: EdgeInsets.all(8))
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_searchController.text.trim().isEmpty && dataService.contacts.isEmpty)
            const Center(child: Text("Enter something to begin searching!"))
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Accounts",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ),
                            ),
                            accounts.isEmpty
                              ? const Text("No accounts found.")
                              : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: accounts.map((account) {
                                  return Row(
                                    children: [
                                      AccountPreview(account: account),
                                      Padding(padding: EdgeInsets.all(8))
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Posts'),
                    ),
                    posts.isNotEmpty ?
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return PostPreview(
                            post: posts[index],
                            account: dataService.user!
                          );
                        },
                      ) : const Center(child: Text("No posts found."))
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    socketService.socket.off("search");
    speech.stop();
    super.dispose();
  }
}
