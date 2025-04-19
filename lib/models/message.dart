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

  int get getMessageID => _messageID;
  String get getContent => _content;

  String get getTimeSinceSent {
    final now = DateTime.now();
    final difference = now.difference(_sentDate);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

  String get getSenderEmail => _senderEmail;
  String get getRecipientEmail => _receiverEmail;

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