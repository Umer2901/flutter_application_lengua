// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_lengua/ui/model/chatmodel.dart';

// class FirebaseService {
//   final CollectionReference _chatCollection =
//       FirebaseFirestore.instance.collection('chatMessages');

//   Future<void> sendMessage(ChatMessage message) async {
//     await _chatCollection.add(message.toMap());
//   }

//   Stream<List<ChatMessage>> getChatMessages(
//       String currentUserId, String otherUserId) {
//     return _chatCollection
//         .where('senderId', whereIn: [currentUserId, otherUserId])
//         .where('receiverId', whereIn: [currentUserId, otherUserId])
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.map((doc) {
//             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//             return ChatMessage(
//               text: data['text'],
//               senderId: data['senderId'],
//               receiverId: data['receiverId'],
//               timestamp: (data['timestamp'] as Timestamp).toDate(),
//             );
//           }).toList();
//         });
//   }
// }
