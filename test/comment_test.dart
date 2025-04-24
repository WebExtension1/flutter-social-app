// Testing
import 'package:flutter_test/flutter_test.dart';

// Models
import 'package:badbook/models/comment.dart';
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
    final Comment comment = Comment.fromJson({
      'commentID': 1,
      'commentContent': 'Test content',
      'sentDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
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
    final String actualDate = comment.getTimeSinceSent;

    // Assert
    expect(actualDate, expectedDate);
  });

  test('Register Date formatting old', () async {
    // Arrange
    final Comment comment = Comment.fromJson({
      'commentID': 1,
      'commentContent': 'Test content',
      'sentDate': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
      'likes': 1,
      'dislikes': 2,
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
    final String actualDate = comment.getTimeSinceSent;

    // Assert
    expect(actualDate, expectedDate);
  });

  test('Account formatting', () async {
    // Arrange
    final Comment comment = Comment.fromJson({
      'commentID': 1,
      'commentContent': 'Test content',
      'sentDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
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
    final expectedAccount = Account.fromJson({
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
    final Account actualAccount = comment.getAccount;

    // Assert

    // Comparing each individual value as identical instances aren't the same unless they are exact copies
    // All of these passing means that every single element internally matches so achieves the same thing
    expect(actualAccount.getAccountID, expectedAccount.getAccountID);
    expect(actualAccount.getEmail, expectedAccount.getEmail);
    expect(actualAccount.getUsername, expectedAccount.getUsername);
    expect(actualAccount.getName, expectedAccount.getName);
    expect(actualAccount.getPhoneNumber, expectedAccount.getPhoneNumber);
    expect(actualAccount.getTimeSinceJoined, expectedAccount.getTimeSinceJoined);
    expect(actualAccount.getImageUrl, expectedAccount.getImageUrl);
    expect(actualAccount.getRelationship, expectedAccount.getRelationship);
  });

  test('Post formatting', () async {
    // Arrange
    final Comment comment = Comment.fromJson({
      'commentID': 1,
      'commentContent': 'Test content',
      'sentDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890,
      'accountImageUrl': null,
      'postID': 1,
      'postContent': 'Test post content',
      'postDate': DateTime.now().toIso8601String(),
      'postLikes': 2,
      'postDislikes': 3,
      'commentCount': 1,
      'postLiked': 2,
      'location': 'Somewhere'
    }, auth: auth);
    final Post expectedPost = Post.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890,
      'accountImageUrl': null,
      'postID': 1,
      'postContent': 'Test post content',
      'postDate': DateTime.now().toIso8601String(),
      'likes': 2,
      'dislikes': 3,
      'commentCount': 1,
      'liked': 2,
      'location': 'Somewhere'
    }, auth: auth);

    // Act
    final Post actualPost = comment.getPost!;

    // Assert
    expect(expectedPost.getPostID, actualPost.getPostID);
    expect(expectedPost.getContent, actualPost.getContent);
    expect(expectedPost.getTimeSinceSent, actualPost.getTimeSinceSent);
    expect(expectedPost.getLikes, actualPost.getLikes);
    expect(expectedPost.getDislikes, actualPost.getDislikes);
    expect(expectedPost.getCommentCount, actualPost.getCommentCount);
    expect(expectedPost.getLiked, actualPost.getLiked);
    expect(expectedPost.getImageUrl, actualPost.getImageUrl);
    expect(expectedPost.getLocation, actualPost.getLocation);
  });

  test('Post formatting null', () async {
    // Arrange
    final Comment comment = Comment.fromJson({
      'commentID': 1,
      'commentContent': 'Test content',
      'sentDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
      'liked': 1,
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890,
      'accountImageUrl': null,
    }, auth: auth);
    final Post? expectedPost = null;

    // Act
    final Post? actualPost = comment.getPost;

    // Assert
    expect(expectedPost, actualPost);
  });

  // Unformatted

  test('CommentID return', () async {
    // Arrange
    final Comment comment = Comment.fromJson({
      'commentID': 1,
      'commentContent': 'Test content',
      'sentDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
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
    final int expectedCommentID = 1;

    // Act
    final int actualCommentID = comment.getCommentID;

    // Assert
    expect(actualCommentID, expectedCommentID);
  });

  test('Content return', () async {
    // Arrange
    final Comment comment = Comment.fromJson({
      'commentID': 1,
      'commentContent': 'Test content',
      'sentDate': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
      'likes': 1,
      'dislikes': 2,
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
    final String expectedContent = 'Test content';

    // Act
    final String actualContent = comment.getContent;

    // Assert
    expect(actualContent, expectedContent);
  });

  test('Likes return', () async {
    // Arrange
    final Comment comment = Comment.fromJson({
      'commentID': 1,
      'commentContent': 'Test content',
      'sentDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
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
    final int actualLikes = comment.getLikes;

    // Assert
    expect(actualLikes, expectedLikes);
  });

  test('Likes return', () async {
    // Arrange
    final Comment comment = Comment.fromJson({
      'commentID': 1,
      'commentContent': 'Test content',
      'sentDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
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
    final int actualDislikes = comment.getDislikes;

    // Assert
    expect(actualDislikes, expectedDislikes);
  });

  test('Likes return', () async {
    // Arrange
    final Comment comment = Comment.fromJson({
      'commentID': 1,
      'commentContent': 'Test content',
      'sentDate': DateTime.now().toIso8601String(),
      'likes': 1,
      'dislikes': 2,
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
    final int actualLiked = comment.getLiked;

    // Assert
    expect(actualLiked, expectedLiked);
  });
}