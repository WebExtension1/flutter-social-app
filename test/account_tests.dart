import 'package:badbook/models/account.dart';
import 'package:flutter_test/flutter_test.dart';

// Firebase
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  late MockFirebaseAuth auth = MockFirebaseAuth();
  late String apiUrl;

  setUpAll(() async {
    await dotenv.load();
    apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  });

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
    final String actualName = account.getUsername;

    // Assert
    expect(actualName, expectedUsername);
  });

  test('Account exists', () async {
    // Arrange
    await http.post(
      Uri.parse('$apiUrl/account/create'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': 'test@email.com', 'phoneNumber': 01234567890, 'username': 'testuser', 'fname': 'test', 'lname': 'user'}),
    );

    final Account expectedData = Account.fromJson({
      'accountID': 2,
      'email': 'test@email.com',
      'username': 'testuser',
      'fname': 'test',
      'lname': 'user',
      'dateJoined': DateTime.now().toIso8601String(),
      'relationship': 'other',
      'phoneNumber': 01234567890
    }, auth: auth);

    // Act
    final response = await http.post(
      Uri.parse('$apiUrl/account/details'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': 'test@email.com'}),
    );
    final Account actualData = Account.fromJson(jsonDecode(response.body), auth: auth);

    // Clean
    await http.post(
      Uri.parse('$apiUrl/account/delete'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': 'test@email.com'}),
    );

    // Assert
    expect(actualData.getEmail, expectedData.getEmail);
    expect(actualData.getUsername, expectedData.getUsername);
    expect(actualData.getName, expectedData.getName);
    expect(actualData.getRawName, expectedData.getRawName);
    expect(actualData.getRelationship, expectedData.getRelationship);
    expect(actualData.getPhoneNumber, expectedData.getPhoneNumber);
  });
}