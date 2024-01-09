import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String text;
  String senderId;
  String receiverId;
  String translatedText;
  DateTime timestamp;

  Message({
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.translatedText,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'translatedText': translatedText,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  static fromDocument(QueryDocumentSnapshot<Object?> doc) {}
}
