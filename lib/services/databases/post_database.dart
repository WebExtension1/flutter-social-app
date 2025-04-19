import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:badbook/models/post.dart';
import 'package:badbook/models/account.dart';

class PostDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await _initDB('posts.db');
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INT PRIMARY KEY,
        content TEXT,
        accountUsername TEXT,
        accountFName TEXT,
        accountLName TEXT,
        postDate TEXT,
        likes INT,
        dislikes INT,
        commentCount INT,
        liked INT,
        imageUrl String,
        location String
      )
    ''');
  }

  static Future<void> insertPosts(List<Post> posts) async {
    final db = await database;

    // Clear existing posts before inserting new ones
    await db.delete('posts');

    for (var post in posts) {
      Account account = post.getAccount;
      List<String> names = account.getRawName;
      await db.insert(
        'posts',
        {
          'id': post.getPostID,
          'content': post.getContent,
          'accountUsername': account.getUsername,
          'accountFName': names[0],
          'accountLName': names[1],
          'postDate': account.getRawDateJoined.toIso8601String(),
          'likes': post.getLikes,
          'dislikes': post.getDislikes,
          'commentCount': post.getCommentCount,
          'liked': post.getLiked,
          'imageUrl': post.getImageUrl ?? '',
          'location': post.getLocation ?? ''
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<Post>> getFeed() async {
    final db = await database;
    final maps = await db.query('posts');

    return maps.map((map) => Post(
      postID: map['id'] as int,
      content: map['content'] as String,
      account: Account(
        accountID: 1,
        email: 'loading',
        username: map['accountUsername'] as String,
        fname: map['accountFName'] as String,
        lname: map['accountLName'] as String,
        dateJoined: DateTime.parse('2010-10-10T10:10:10'),
        phoneNumber: 11111111111,
        relationship: 'other'
      ),
      postDate: DateTime.parse(map['postDate'] as String),
      likes: map['likes'] as int,
      dislikes: map['dislikes'] as int,
      commentCount: map['commentCount'] as int,
      liked: map['liked'] as int
    )).toList();
  }
}
