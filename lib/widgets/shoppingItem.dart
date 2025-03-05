import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/itemData.dart';
import 'package:untitled/providers/favItemsNotifier.dart';

class ShoppingItemScreen extends StatelessWidget {
  const ShoppingItemScreen({Key? key, required this.item}) : super(key: key);

  final theItem item;

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<FavItemsNotifier>(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20
        ),
        child: Column(
          children: [
            Text(item.itemName),
            SizedBox(
              height:4
            ),
            Row(
              children:[
                Text(item.itemCost.toStringAsFixed(2)),
                Spacer(),
                Row(
                  children: [
                    Icon(deptIcons[item.itemDept]),
                    SizedBox(
                      width: 8,
                    ),
                    Text(item.getFormattedDate),
                    Checkbox(
                      value: myProvider.getMyFavItemsList.contains(item),
                      onChanged: (value) {
                        if (value == true)
                          myProvider.addFavItemToList(item);
                        else
                          myProvider.removeFavItemFromList(item);
                      }
                    )
                  ],
                )
              ]
            )


          ],
        ),
      ),

    );
  }
}
