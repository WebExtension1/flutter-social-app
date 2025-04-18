import 'package:flutter/material.dart';

enum MessageType { success, error, none }

class FeedbackMessage {
  final String message;
  final MessageType type;

  FeedbackMessage({required this.message, required this.type});

  Color get getColour {
    if (type == MessageType.success) {
      return Colors.green;
    }
    return Colors.red;
  }
}