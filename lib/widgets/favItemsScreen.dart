import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/itemData.dart';
import 'package:untitled/providers/favItemsNotifier.dart';

class FavItemsScreen extends StatelessWidget {
  const FavItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<FavItemsNotifier>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My Favourite Shopping Items"),
        ),
        body: Consumer(
          builder: (context, value, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: myProvider.getMyFavItemsList.length,
                    itemBuilder: (context, index) {
                      theItem item = myProvider.getMyFavItemsList[index];
                      return ListTile(
                        title: Text(item.itemName),
                        trailing: Icon(Icons.favorite),
                        leading: Text(item.itemCost.toStringAsFixed(2)),
                      );
                    }
                  )
                ),
                SizedBox(
                  height: 2,
                  width: MediaQuery.sizeOf(context).width,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: (){},
                      child: Text("£" + myProvider.favItemTotalCost.toStringAsFixed(2)
                      )
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        myProvider.clearMyFavItemsList();
                      },
                      child: Text("Clear List")
                    )
                  ],
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
