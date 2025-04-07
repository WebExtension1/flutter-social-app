import 'package:intl/intl.dart';

class Message {
  final int messageID;
  final String content;
  final DateTime sentDate;
  final String senderEmail;
  final String receiverEmail;

  Message({
    required this.messageID,
    required this.content,
    required this.sentDate,
    required this.senderEmail,
    required this.receiverEmail,
  });

  String get getContent {
    return content;
  }

  String get getSender {
    return senderEmail;
  }

  String get getRecipient {
    return receiverEmail;
  }

  String get getSentDate {
    return "${DateFormat('yyyy-MM-dd').format(sentDate)} at ${DateFormat('hh:mm').format(sentDate)}";
  }

  factory Message.fromJson(Map<String, dynamic> data) {
    print(data);
    return Message(
      messageID: int.tryParse(data['messageID'].toString()) ?? 0,
      content: data['content'],
      sentDate: DateTime.parse(data['sentDate']),
      senderEmail: data['senderEmail'],
      receiverEmail: data['receiverEmail'],
    );
  }
}