import 'package:badbook/models/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Formatted

  test('Register Date formatting recent', () async {
    // Arrange
    final Message message = Message(
      messageID: 1,
      content: 'Message content',
      sentDate: DateTime.now(),
      senderEmail: 'sender@email.com',
      receiverEmail: 'receiver@email.com'
    );
    final String expectedDate = 'just now';

    // Act
    final String actualDate = message.getTimeSinceSent;

    // Assert
    expect(actualDate, expectedDate);
  });

  test('Register Date formatting old', () async {
    // Arrange
    final Message message = Message(
      messageID: 1,
      content: 'Message content',
      sentDate: DateTime.now().subtract(Duration(days: 3)),
      senderEmail: 'sender@email.com',
      receiverEmail: 'receiver@email.com'
    );
    final String expectedDate = '3 days ago';

    // Act
    final String actualDate = message.getTimeSinceSent;

    // Assert
    expect(actualDate, expectedDate);
  });

  // Unformatted

  test('MessageID return', () async {
    // Arrange
    final Message message = Message(
      messageID: 1,
      content: 'Message content',
      sentDate: DateTime.parse('2025-04-09 09:26:12'),
      senderEmail: 'sender@email.com',
      receiverEmail: 'receiver@email.com'
    );
    final int expectedMessageID = 1;

    // Act
    final int actualMessageID = message.getMessageID;

    // Assert
    expect(actualMessageID, expectedMessageID);
  });

  test('Content return', () async {
    // Arrange
    final Message message = Message(
      messageID: 1,
      content: 'Message content',
      sentDate: DateTime.parse('2025-04-09 09:26:12'),
      senderEmail: 'sender@email.com',
      receiverEmail: 'receiver@email.com'
    );
    final String expectedContent = 'Message content';

    // Act
    final String actualContent = message.getContent;

    // Assert
    expect(actualContent, expectedContent);
  });

  test('Sender return', () async {
    // Arrange
    final Message message = Message(
      messageID: 1,
      content: 'Message content',
      sentDate: DateTime.parse('2025-04-09 09:26:12'),
      senderEmail: 'sender@email.com',
      receiverEmail: 'receiver@email.com'
    );
    final String expectedEmail = 'sender@email.com';

    // Act
    final String actualEmail = message.getSenderEmail;

    // Assert
    expect(actualEmail, expectedEmail);
  });

  test('Receiver return', () async {
    // Arrange
    final Message message = Message(
      messageID: 1,
      content: 'Message content',
      sentDate: DateTime.parse('2025-04-09 09:26:12'),
      senderEmail: 'sender@email.com',
      receiverEmail: 'receiver@email.com'
    );
    final String expectedEmail = 'receiver@email.com';

    // Act
    final String actualEmail = message.getRecipientEmail;

    // Assert
    expect(actualEmail, expectedEmail);
  });
}