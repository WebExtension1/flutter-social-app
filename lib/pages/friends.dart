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

  @override
  void initState() {
    super.initState();
  }

  static Expanded _listViewGroup(List<account_model.Account> group, String type, Future<void> Function() onRefresh) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          itemCount: group.length,
          itemBuilder: (context, index) {
            return FriendPreview(account: group[index], type: type);
          },
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    Widget buildTabContent(int type) {
      switch (type) {
        case 1:
          return _listViewGroup(dataService.friends, 'Friends', dataService.getFriends);
        case 2:
          return _listViewGroup(dataService.contacts, 'Other', dataService.getFriends);
        case 3:
          return _listViewGroup(dataService.mutual, 'Other', dataService.getFriends);
        case 4:
          return _listViewGroup(dataService.incoming, 'Incoming', dataService.getFriends);
        case 5:
          return _listViewGroup(dataService.outgoing, 'Outgoing', dataService.getFriends);
        default:
          return const SizedBox.shrink();
      }
    }

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
              });
            },
          ),
          const SizedBox(height: 10),
          buildTabContent(displayType),
        ],
      )
    );
  }
}