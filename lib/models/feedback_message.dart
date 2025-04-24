import 'package:flutter/material.dart';

enum MessageType { success, error }

class FeedbackMessage {
  final String _message;
  final MessageType _type;

  FeedbackMessage({
    required message,
    required type
  }) : _type = type,
       _message = message;

  String get getMessage => _message;

  Color get getColour {
    if (_type == MessageType.success) {
      return Colors.green;
    }
    return Colors.red;
  }
}