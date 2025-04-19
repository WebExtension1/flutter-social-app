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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    socketService.socket.on("search", (data) {
      setState(() {
        posts = List<Post>.from(
          data['posts'].map((post) => Post.fromJson(post))
        );
        accounts = List<account_model.Account>.from(
          data['accounts'].map((account) => account_model.Account.fromJson(account))
        );
      });
    });
  }

  void _onSearchChanged() {
    setState(() {
      socketService.search(_searchController.text);
    });
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
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          if (_searchController.text.trim().isEmpty)
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
                    dataService.contacts.isEmpty
                        ? Text("You're friends with all registered contacts!")
                        : SingleChildScrollView(
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
                    ),
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
    super.dispose();
  }
}
