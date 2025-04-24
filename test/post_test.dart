// Testing
import 'package:flutter_test/flutter_test.dart';

// Models
import 'package:badbook/models/account.dart';
import 'package:badbook/models/post.dart';

// Firebase
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  late MockFirebaseAuth auth = MockFirebaseAuth();

  setUpAll(() async {
    await dotenv.load();
  });

  // Formatted

  test('Register Date formatting recent', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final String expectedDate = 'just now';

    // Act
    final String actualDate = post.getTimeSinceSent;

    // Assert
    expect(actualDate, expectedDate);
  });

  test('Register Date formatting old', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final String expectedDate = '3 days ago';

    // Act
    final String actualDate = post.getTimeSinceSent;

    // Assert
    expect(actualDate, expectedDate);
  });

  test('Account return', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final Account expectedAccount = Account.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);

    // Act
    final Account actualAccount = post.getAccount;

    // Assert
    expect(actualAccount.getAccountID, expectedAccount.getAccountID);
    expect(actualAccount.getEmail, expectedAccount.getEmail);
    expect(actualAccount.getUsername, expectedAccount.getUsername);
    expect(actualAccount.getName, expectedAccount.getName);
    expect(actualAccount.getPhoneNumber, expectedAccount.getPhoneNumber);
    expect(actualAccount.getTimeSinceJoined, expectedAccount.getTimeSinceJoined);
    expect(actualAccount.getImageUrl, expectedAccount.getImageUrl);
    expect(actualAccount.getRelationship, expectedAccount.getRelationship);
  });

  test('Not interacted formatting', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 0,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final int expectedLiked = 0;
    final int expectedDisliked = 0;

    // Act
    final int actualLiked = post.isLiked;
    final int actualDisliked = post.isDisliked;

    // Assert
    expect(actualLiked, expectedLiked);
    expect(actualDisliked, expectedDisliked);
  });

  test('Liked formatting', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final int expectedLiked = 1;
    final int expectedDisliked = 0;

    // Act
    final int actualLiked = post.isLiked;
    final int actualDisliked = post.isDisliked;

    // Assert
    expect(actualLiked, expectedLiked);
    expect(actualDisliked, expectedDisliked);
  });

  test('Disliked formatting', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 2,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final int expectedLiked = 0;
    final int expectedDisliked = 1;

    // Act
    final int actualLiked = post.isLiked;
    final int actualDisliked = post.isDisliked;

    // Assert
    expect(actualLiked, expectedLiked);
    expect(actualDisliked, expectedDisliked);
  });

  // Unformatted

  test('PostID return', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final int expectedPostID = 1;

    // Act
    final int actualPostID = post.getPostID;

    // Assert
    expect(actualPostID, expectedPostID);
  });

  test('Content return', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final String expectedContent = 'Post content';

    // Act
    final String actualContent = post.getContent;

    // Assert
    expect(actualContent, expectedContent);
  });

  test('Likes return', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final int expectedLikes = 1;

    // Act
    final int actualLikes = post.getLikes;

    // Assert
    expect(actualLikes, expectedLikes);
  });

  test('Dislikes return', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final int expectedDislikes = 2;

    // Act
    final int actualDislikes = post.getDislikes;

    // Assert
    expect(actualDislikes, expectedDislikes);
  });

  test('Comment Count return', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final int expectedCommentCount = 1;

    // Act
    final int actualCommentCount = post.getCommentCount;

    // Assert
    expect(actualCommentCount, expectedCommentCount);
  });

  test('Liked return', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final int expectedLiked = 1;

    // Act
    final int actualLiked = post.getLiked;

    // Assert
    expect(actualLiked, expectedLiked);
  });

  test('Image Url return', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890,
      'imageUrl': 'uploads/profilePictures/1744121975069-292323849.jpg'
    }, auth: auth);
    final String expectedImageUrl = 'uploads/profilePictures/1744121975069-292323849.jpg';

    // Act
    final String? actualImageUrl = post.getImageUrl;

    // Assert
    expect(actualImageUrl, expectedImageUrl);
  });

  test('Image Url return null', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final String? expectedImageUrl = null;

    // Act
    final String? actualImageUrl = post.getImageUrl;

    // Assert
    expect(actualImageUrl, expectedImageUrl);
  });

  test('Location return', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890,
      'location': 'Somewhere'
    }, auth: auth);
    final String expectedLocation = 'Somewhere';

    // Act
    final String? actualLocation = post.getLocation;

    // Assert
    expect(actualLocation, expectedLocation);
  });

  test('Location return null', () async {
    // Arrange
    final Post post = Post.fromJson({
      'postID': 1,
      'content': 'Post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'commentCount': 1,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final String? expectedLocation = null;

    // Act
    final String? actualLocation = post.getLocation;

    // Assert
    expect(actualLocation, expectedLocation);
  });
}