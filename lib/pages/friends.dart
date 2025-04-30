import 'package:flutter/material.dart';

// Models
import 'package:badbook/models/account.dart' as account_model;

// Widgets
import 'package:badbook/widgets/friend_preview.dart';
import 'package:badbook/widgets/tab_bar.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  int displayType = 1;
  final List<String> labels = ['Friends', 'Contacts', 'Mutual', 'Incoming', 'Outgoing'];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: displayType - 1);
  }

  static Widget _listViewGroup(List<account_model.Account> group, Future<void> Function() onRefresh) {
    return (
      group.isNotEmpty ?
      Expanded(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: group.length,
            itemBuilder: (context, index) {
              return FriendPreview(account: group[index]);
            },
          ),
        )
      ) : const Center(child: Text("No accounts to display."))
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends")
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          TabBarWidget(
            labels: labels,
            displayType: displayType,
            onTabSelected: (int type) {
              setState(() {
                displayType = type;
                _pageController.animateToPage(
                  type - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  displayType = index + 1;
                });
              },
              children: [
                _listViewGroup(dataService.friends, dataService.getFriends),
                _listViewGroup(dataService.contacts, dataService.getFriends),
                _listViewGroup(dataService.mutual, dataService.getFriends),
                _listViewGroup(dataService.incoming, dataService.getFriends),
                _listViewGroup(dataService.outgoing, dataService.getFriends),
              ],
            ),
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}