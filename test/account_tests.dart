import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/account.dart';

void main() {
  test('Account register date formatting', () {
    // Arrange
    final Account account = Account(
      accountID: 1,
      email: 'test@email.com',
      username: 'testuser',
      fname: 'test',
      lname: 'user',
      dateJoined: DateTime.parse('2025-04-09 09:26:12'),
      relationship: 'other',
      phoneNumber: 01234567890
    );
    final String expectedDate = '2025-04-09 at 09:26';

    // Act
    final String actualDate = account.getJoinDate;

    // Assert
    expect(actualDate, expectedDate);
  });

  test('Account name formatting', () {
    // Arrange
    final Account account = Account(
        accountID: 1,
        email: 'test@email.com',
        username: 'testuser',
        fname: 'test',
        lname: 'user',
        dateJoined: DateTime.parse('2025-04-09 09:26:12'),
        relationship: 'other',
        phoneNumber: 01234567890
    );
    final String expectedName = 'test user';

    // Act
    final String actualName = account.getName;

    // Assert
    expect(actualName, expectedName);
  });
}