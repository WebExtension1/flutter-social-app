import 'package:badbook/models/account.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

// Firebase
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  late MockFirebaseAuth auth = MockFirebaseAuth();

  setUpAll(() async {
    dotenv.load();
  });

  test('Account register date formatting', () async {
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

  test('Account name formatting', () {
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
}