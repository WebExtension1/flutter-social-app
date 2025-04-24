import 'package:flutter/material.dart';

// Testing
import 'package:flutter_test/flutter_test.dart';

// Models
import 'package:badbook/models/feedback_message.dart';

void main() {
  // Formatted

  test('Error MessageType', () async {
    // Arrange
    final FeedbackMessage message = FeedbackMessage(
      message: 'Error message',
      type: MessageType.error
    );
    final Color expectedColour = Colors.red;

    // Act
    final Color actualColour = message.getColour;

    // Assert
    expect(actualColour, expectedColour);
  });

  test('Success MessageType', () async {
    // Arrange
    final FeedbackMessage message = FeedbackMessage(
      message: 'Success message',
      type: MessageType.success
    );
    final Color expectedColour = Colors.green;

    // Act
    final Color actualColour = message.getColour;

    // Assert
    expect(actualColour, expectedColour);
  });

  // Unformatted

  test('Message return', () async {
    // Arrange
    final FeedbackMessage message = FeedbackMessage(
      message: 'Error message',
      type: MessageType.error
    );
    final String expectedMessage = 'Error message';

    // Act
    final String actualMessage = message.getMessage;

    // Assert
    expect(actualMessage, expectedMessage);
  });
}