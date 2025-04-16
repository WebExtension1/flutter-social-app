import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:untitled/models/account.dart';

class FriendsDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await _initDB('friends.db');
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE accounts (
        id INT PRIMARY KEY,
        username TEXT,
        fname TEXT,
        lname TEXT,
        email TEXT,
        dateJoined TEXT,
        relationship TEXT,
        phoneNumber INT
      )
    ''');
  }

  static Future<void> insertAccounts(List<Account> accounts) async {
    final db = await database;

    // Clear existing accounts before inserting new ones
    await db.delete('accounts');

    for (var account in accounts) {
      List<String> names = account.getRawName;
      await db.insert(
        'accounts',
        {
          'id': account.getAccountID,
          'username': account.getUsername.substring(1),
          'fname': names[0],
          'lname': names[1],
          'email': account.getEmail,
          'dateJoined': account.getRawDateJoined.toIso8601String(),
          'relationship': account.getRelationship,
          'phoneNumber': account.getPhoneNumber
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<Account>> getAccounts() async {
    final db = await database;
    final maps = await db.query('accounts');

    return maps.map((map) => Account(
      accountID: map['id'] as int,
      username: map['username'] as String,
      fname: map['fname'] as String,
      lname: map['lname'] as String,
      email: map['email'] as String,
      dateJoined: DateTime.parse(map['dateJoined'] as String),
      relationship: map['relationship'] as String,
      phoneNumber: map['phoneNumber'] as int,
    )).toList();
  }
}
