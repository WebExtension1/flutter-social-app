import 'package:intl/intl.dart';

class Message {
  final int _messageID;
  final String _content;
  final DateTime _sentDate;
  final String _senderEmail;
  final String _receiverEmail;

  Message({
    required int messageID,
    required String content,
    required DateTime sentDate,
    required String senderEmail,
    required String receiverEmail,
  })  : _messageID = messageID,
        _content = content,
        _sentDate = sentDate,
        _senderEmail = senderEmail,
        _receiverEmail = receiverEmail;

  int get getMessageID {
    return _messageID;
  }

  String get getContent {
    return _content;
  }

  String get getSentDate {
    return "${DateFormat('yyyy-MM-dd').format(_sentDate)} at ${DateFormat('hh:mm').format(_sentDate)}";
  }

  String get getSenderEmail {
    return _senderEmail;
  }

  String get getRecipientEmail {
    return _receiverEmail;
  }

  factory Message.fromJson(Map<String, dynamic> data) {
    return Message(
      messageID: int.tryParse(data['messageID'].toString()) ?? 0,
      content: data['content'],
      sentDate: DateTime.parse(data['sentDate']),
      senderEmail: data['senderEmail'],
      receiverEmail: data['receiverEmail'],
    );
  }
}