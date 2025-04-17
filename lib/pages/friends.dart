import 'package:flutter/material.dart';

// Models
import 'package:untitled/models/account.dart' as account_model;

// Widgets
import 'package:untitled/widgets/friend_preview.dart';
import 'package:untitled/widgets/tab_bar.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:untitled/providers/shared_data.dart';

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

  static Expanded ListViewGroup(List<account_model.Account> group, String type, Future<void> Function() onRefresh) {
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
          return ListViewGroup(dataService.friends, 'Friends', dataService.getFriends);
        case 2:
          return ListViewGroup(dataService.contacts, 'Other', dataService.getFriends);
        case 3:
          return ListViewGroup(dataService.mutual, 'Other', dataService.getFriends);
        case 4:
          return ListViewGroup(dataService.incoming, 'Incoming', dataService.getFriends);
        case 5:
          return ListViewGroup(dataService.outgoing, 'Outgoing', dataService.getFriends);
        default:
          return const SizedBox.shrink();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Friends")
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          TabBarWidget(
            labels: labels,
            displayType: displayType,
            onTabSelected: (int type) {
              setState(() {
                displayType = type;
              });
            },
          ),
          SizedBox(height: 10),
          buildTabContent(displayType),
        ],
      )
    );
  }
}