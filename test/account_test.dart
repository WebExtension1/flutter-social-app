// Testing
import 'package:flutter_test/flutter_test.dart';

// Models
import 'package:badbook/models/account.dart';

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
    final Account account = Account.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': DateTime.now().toIso8601String(),
      'relationship': 'other',
      'phoneNumber': 01234567890,
    }, auth: auth);
    final String expectedDate = 'just now';

    // Act
    final String actualDate = account.getTimeSinceJoined;

    // Assert
    expect(actualDate, expectedDate);
  });

  test('Register Date formatting old', () {
    // Arrange
    final account = Account.fromJson({
      'accountID': 1,
      'email': 'email@test.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final String expectedDate = '3 days ago';

    // Act
    final String actualDate = account.getTimeSinceJoined;

    // Assert
    expect(actualDate, expectedDate);
  });

  test('Name formatting', () {
    // Arrange
    final Account account = Account.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final String expectedName = 'test user';

    // Act
    final String actualName = account.getName;

    // Assert
    expect(actualName, expectedName);
  });

  test('Raw name formatting', () {
    // Arrange
    final Account account = Account.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final List<String> expectedNames = ['test', 'user'];

    // Act
    final List<String> actualNames = account.getRawName;

    // Assert
    expect(actualNames, expectedNames);
  });

  test('Username formatting', () {
    // Arrange
    final Account account = Account.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final String expectedUsername = '@testuser';

    // Act
    final String actualUsername = account.getUsername;

    // Assert
    expect(actualUsername, expectedUsername);
  });

  // Unformatted

  test('AccountID return', () {
    // Arrange
    final Account account = Account.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final int expectedAccountID = 1;

    // Act
    final int actualAccountID = account.getAccountID;

    // Assert
    expect(actualAccountID, expectedAccountID);
  });

  test('Email return', () {
    // Arrange
    final Account account = Account.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final String expectedEmail = 'test@email.com';

    // Act
    final String actualEmail = account.getEmail;

    // Assert
    expect(actualEmail, expectedEmail);
  });

  test('Phone Number return', () {
    // Arrange
    final Account account = Account.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final int expectedPhoneNumber = 01234567890;

    // Act
    final int actualPhoneNumber = account.getPhoneNumber;

    // Assert
    expect(actualPhoneNumber, expectedPhoneNumber);
  });

  test('Raw Register Date return', () {
    // Arrange
    final Account account = Account.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final DateTime expectedRegisterDate = DateTime.parse('2025-04-09 09:26:12');

    // Act
    final DateTime actualRegisterDate = account.getRawDateJoined;

    // Assert
    expect(actualRegisterDate, expectedRegisterDate);
  });

  test('Relationship return', () {
    // Arrange
    final Account account = Account.fromJson({
      'accountID': 1,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': '2025-04-09 09:26:12',
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);
    final String expectedRelationship = 'other';

    // Act
    final String actualRelationship = account.getRelationship;

    // Assert
    expect(actualRelationship, expectedRelationship);
  });

  test('ImageUrl return', () {
    // Arrange
    final Account account = Account.fromJson({
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
    final String? actualImageUrl = account.getImageUrl;

    // Assert
    expect(actualImageUrl, expectedImageUrl);
  });

  test('ImageUrl return null', () {
    // Arrange
    final Account account = Account.fromJson({
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
    final String? actualImageUrl = account.getImageUrl;

    // Assert
    expect(actualImageUrl, expectedImageUrl);
  });
}