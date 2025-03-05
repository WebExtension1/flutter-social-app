import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/FavItemsNotifier.dart';
import 'package:untitled/widgets/shoppingListScreen.dart';

void main() {
  runApp(const MyShoppingApp());
}

class MyShoppingApp extends StatelessWidget {
  const MyShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavItemsNotifier(),
      child: MaterialApp(
        home: ShoppingListScreen(),
      ),
    );
  }
}
