import 'package:flutter/material.dart';
import 'package:untitled/models/itemData.dart';
import 'package:untitled/widgets/shoppingItem.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({Key? key, required this.shoppingList}) : super(key: key);

  final List<theItem> shoppingList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:shoppingList.length,
      itemBuilder: (context, index)=>
          ShoppingItemScreen(item:shoppingList[index],),);

  }
}