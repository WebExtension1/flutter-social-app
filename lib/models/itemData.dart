import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

enum Departments {fruit_veg, bakery, dairy, meat, household, confectionary}


const deptIcons ={
  Departments.fruit_veg : Icons.account_tree,
  Departments.bakery: Icons.breakfast_dining,
  Departments.dairy: Icons.local_drink,
  Departments.meat: Icons.set_meal,
  Departments.household: Icons.house,
  Departments.confectionary: Icons.cake
};

final myuuID = Uuid();
final formattedDate = DateFormat.yMd();

class theItem {

  final String itemId;
  final String itemName;
  final double itemCost;
  final DateTime datePurchased;
  final Departments itemDept;

  theItem({required this.itemName, required this.itemCost, required this.itemDept, required this.datePurchased}):itemId=myuuID.v4();

  String get getFormattedDate {
    return formattedDate.format(datePurchased);
  }

}