// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_lengua/ui/chatinfo.dart';
// import 'package:flutter_application_lengua/ui/model/chatmodel.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pull_down_button/pull_down_button.dart';
// import 'package:pull_down_button/pull_down_button.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:sizer/sizer.dart';
// import 'package:translator/translator.dart';

// class ChatPage extends StatefulWidget {
//   final Contact contact;
//   final String currentUserId;
//   final String otherUserId;

//   ChatPage(
//       {required this.contact,
//       required this.currentUserId,
//       required this.otherUserId});

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _textEditingController = TextEditingController();
//   late CollectionReference _messagesCollection;
//   final User? _currentUser = FirebaseAuth.instance.currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _messagesCollection = _firestore.collection('messages2');
//   }

//   Stream<List<QuerySnapshot>> _getMessages() {
//     final senderMessages = _messagesCollection
//         .where('senderId', isEqualTo: _currentUser?.uid)
//         .where('receiverId', isEqualTo: widget.otherUserId)
//         .orderBy('timestamp', descending: true)
//         .snapshots();

//     final receiverMessages = _messagesCollection
//         .where('senderId', isEqualTo: widget.otherUserId)
//         .where('receiverId', isEqualTo: _currentUser?.uid)
//         .orderBy('timestamp', descending: true)
//         .snapshots();

//     return CombineLatestStream.list([senderMessages, receiverMessages])
//         .map((List<QuerySnapshot> snapshots) {
//       return snapshots ?? [];
//     });
//   }

//   List<Map<String, dynamic>> extractMessages(List<QuerySnapshot> snapshots) {
//     List<Map<String, dynamic>> messages = [];

//     for (var snapshot in snapshots) {
//       for (var doc in snapshot.docs) {
//         final data = doc.data() as Map<String, dynamic>;

//         if (data.containsKey('originalText')) {
//           messages.add({
//             'originalText': data['originalText'],
//             'language': data['language'] ?? '',
//             'translatedText': data['translatedText'], // Add this line
//             'senderId': data['senderId'],
//             'timestamp': (data['timestamp'] as Timestamp).toDate(),
//           });
//         } else if (data.containsKey('imageUrl')) {
//           messages.add({
//             'imageUrl': data['imageUrl'],
//             'senderId': data['senderId'],
//             'timestamp': (data['timestamp'] as Timestamp).toDate(),
//           });
//         }
//       }
//     }

//     // Sort messages based on timestamp
//     messages.sort((a, b) =>
//         (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

//     return messages;
//   }

//   List<ChatMessage> _messages = [];
//   String _currentMessage = '';
//   String _selectedLanguage = 'en'; // Default language is English
//   String _selectedLanguageName = 'English'; // Default language name

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, deviceType) {
//       return SafeArea(
//         child: Scaffold(
//           appBar: PreferredSize(
//             preferredSize: const Size.fromHeight(120.0),
//             child: Column(
//               children: [
//                 Container(
//                   height: 8.h,
//                   decoration: const BoxDecoration(
//                       color: Colors.green,
//                       image: DecorationImage(
//                           image: AssetImage("assets/images/ad.jpeg"),
//                           fit: BoxFit.fill)),
//                 ),
//                 Expanded(
//                   child: AppBar(
//                     backgroundColor: const Color(0xffF6F6F6),
//                     leading: IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     actions: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.call,
//                           color: Colors.blue,
//                         ),
//                         onPressed: () {},
//                       ),
//                       _buildLanguageDropdown(),
//                       Container(
//                         width: 60,
//                         child: Text(
//                           _selectedLanguageName,
//                           style: TextStyle(fontSize: 14.0, color: Colors.blue),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                     title: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => const Chatinfo()));
//                       },
//                       child: Row(
//                         children: [
//                           const CircleAvatar(
//                             backgroundImage:
//                                 AssetImage('assets/images/Oval.png'),
//                           ),
//                           const SizedBox(width: 8.0),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(widget.contact.displayName ?? "No Name"),
//                               InkWell(
//                                 onTap: () {
//                                   // Handle tap on contact info
//                                 },
//                                 child: const Text(
//                                   'Tap here for info',
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.grey),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           body: Container(
//             decoration: const BoxDecoration(
//               color: Color.fromARGB(179, 236, 236, 236),
//             ),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: StreamBuilder<List<QuerySnapshot>>(
//                     stream: _getMessages(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       }

//                       final messages = extractMessages(snapshot.data ?? []);

//                       if (messages.isEmpty) {
//                         return Center(child: Text('No messages yet.'));
//                       }

//                       return ListView.builder(
//                         reverse: true,
//                         itemCount: messages.length,
//                         itemBuilder: (context, index) {
//                           final message = messages[index];
//                           final senderId = message['senderId'];
//                           final isCurrentUser = senderId == _currentUser!.uid;

//                           return Align(
//                             alignment: isCurrentUser
//                                 ? Alignment.centerRight
//                                 : Alignment.centerLeft,
//                             child: Container(
//                               margin: EdgeInsets.symmetric(
//                                   vertical: 4, horizontal: 8),
//                               decoration: BoxDecoration(
//                                 // color: Color.fromARGB(179, 236, 236, 236),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               padding: EdgeInsets.all(8),
//                               child: ChatMessage(
//                                 originalText: message['originalText'] ?? '',
//                                 translatedText: message['translatedText'] ??
//                                     '', // Add your logic for translated text
//                                 isSentByMe: isCurrentUser,
//                                 timestamp: (message['timestamp'] is int)
//                                     ? DateTime.fromMillisecondsSinceEpoch(
//                                         message['timestamp'] as int)
//                                     : message['timestamp'] as DateTime? ??
//                                         DateTime.now(),
//                                 language: message['language'] ??
//                                     '', // Add your logic for language
//                                 isOriginal: message['isOriginal'] ??
//                                     true, // Add your logic for isOriginal
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 _buildInputField(),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildLanguageDropdown() {
//     return PopupMenuButton<String>(
//       onSelected: (String value) {
//         setState(() {
//           _selectedLanguage = value;
//           _selectedLanguageName = _getLanguageName(value);
//         });
//       },
//       icon: const Icon(
//         Icons.more_vert,
//         color: Colors.blue, // <-- Set icon color to blue
//       ),
//       itemBuilder: (BuildContext context) {
//         return <PopupMenuEntry<String>>[
//           const PopupMenuItem<String>(
//             value: 'af',
//             child: Text('Afrikaans', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'sq',
//             child: Text('Albanian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'am',
//             child: Text('Amharic', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ar',
//             child: Text('Arabic', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'hy',
//             child: Text('Armenian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'az',
//             child: Text('Azerbaijani', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'eu',
//             child: Text('Basque', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'be',
//             child: Text('Belarusian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'bn',
//             child: Text('Bengali', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'bs',
//             child: Text('Bosnian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'bg',
//             child: Text('Bulgarian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ca',
//             child: Text('Catalan', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ceb',
//             child: Text('Cebuano', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ny',
//             child: Text('Chichewa', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'zh-CN',
//             child: Text('Chinese (Simplified)',
//                 style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'zh-TW',
//             child: Text('Chinese (Traditional)',
//                 style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'co',
//             child: Text('Corsican', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'hr',
//             child: Text('Croatian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'cs',
//             child: Text('Czech', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'da',
//             child: Text('Danish', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'nl',
//             child: Text('Dutch', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'en',
//             child: Text('English', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'eo',
//             child: Text('Esperanto', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'et',
//             child: Text('Estonian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'tl',
//             child: Text('Filipino', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'fi',
//             child: Text('Finnish', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'fr',
//             child: Text('French', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'fy',
//             child: Text('Frisian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'gl',
//             child: Text('Galician', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ka',
//             child: Text('Georgian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'de',
//             child: Text('German', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'el',
//             child: Text('Greek', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'gu',
//             child: Text('Gujarati', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ht',
//             child:
//                 Text('Haitian Creole', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ha',
//             child: Text('Hausa', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'haw',
//             child: Text('Hawaiian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'iw',
//             child: Text('Hebrew', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'hi',
//             child: Text('Hindi', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'hmn',
//             child: Text('Hmong', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'hu',
//             child: Text('Hungarian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'is',
//             child: Text('Icelandic', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ig',
//             child: Text('Igbo', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'id',
//             child: Text('Indonesian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ga',
//             child: Text('Irish', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'it',
//             child: Text('Italian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ja',
//             child: Text('Japanese', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'jw',
//             child: Text('Javanese', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'kn',
//             child: Text('Kannada', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'kk',
//             child: Text('Kazakh', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'km',
//             child: Text('Khmer', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ko',
//             child: Text('Korean', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ku',
//             child: Text('Kurdish (Kurmanji)',
//                 style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ky',
//             child: Text('Kyrgyz', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'lo',
//             child: Text('Lao', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'la',
//             child: Text('Latin', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'lv',
//             child: Text('Latvian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'lt',
//             child: Text('Lithuanian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'lb',
//             child: Text('Luxembourgish', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'mk',
//             child: Text('Macedonian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'mg',
//             child: Text('Malagasy', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ms',
//             child: Text('Malay', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ml',
//             child: Text('Malayalam', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'mt',
//             child: Text('Maltese', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'mi',
//             child: Text('Maori', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'mr',
//             child: Text('Marathi', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'mn',
//             child: Text('Mongolian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'my',
//             child: Text('Burmese', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ne',
//             child: Text('Nepali', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'no',
//             child: Text('Norwegian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'or',
//             child: Text('Odia', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ps',
//             child: Text('Pashto', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'fa',
//             child: Text('Persian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'pl',
//             child: Text('Polish', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'pt',
//             child: Text('Portuguese', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'pa',
//             child: Text('Punjabi', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ro',
//             child: Text('Romanian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ru',
//             child: Text('Russian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'sm',
//             child: Text('Samoan', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'gd',
//             child: Text('Scots Gaelic', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'sr',
//             child: Text('Serbian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'st',
//             child: Text('Sesotho', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'sn',
//             child: Text('Sesotho', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'sd',
//             child: Text('Sindhi', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'si',
//             child: Text('Sinhala', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'sk',
//             child: Text('Slovak', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'sl',
//             child: Text('Slovenian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'so',
//             child: Text('Somali', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'es',
//             child: Text('Spanish', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'su',
//             child: Text('Sundanese', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'sw',
//             child: Text('Swahili', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'sv',
//             child: Text('Swedish', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'tg',
//             child: Text('Tajik', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ta',
//             child: Text('Tamil', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'te',
//             child: Text('Telugu', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'th',
//             child: Text('Thai', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'tr',
//             child: Text('Turkish', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'uk',
//             child: Text('Ukrainian', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ur',
//             child: Text('Urdu', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'ug',
//             child: Text('Uyghur', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'uz',
//             child: Text('Uzbek', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'vi',
//             child: Text('Vietnamese', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'cy',
//             child: Text('Welsh', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'xh',
//             child: Text('Xhosa', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'yi',
//             child: Text('Yiddish', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'yo',
//             child: Text('Yoruba', style: TextStyle(color: Colors.white)),
//           ),
//           const PopupMenuItem<String>(
//             value: 'zu',
//             child: Text('Zulu', style: TextStyle(color: Colors.white)),
//           ),
//         ];
//       },
//       color: Colors.blue,
//     );
//   }

//   Widget _buildInputField() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: Colors.grey.shade300)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
//             ),
//             child: Text(_currentMessage),
//           ),
//           Container(
//             color: const Color(0xffF6F6F6),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(
//                     Icons.add,
//                     color: Colors.blue,
//                   ),
//                   onPressed: () {
//                     _showPopupMenu(context);
//                   },
//                 ),
//                 Expanded(
//                   child: SizedBox(
//                     height: 35,
//                     child: Container(
//                       // Adjust margin as needed
//                       child: TextField(
//                         textAlignVertical: TextAlignVertical.center,
//                         controller: _messageController,
//                         onChanged: (text) async {
//                           String translatedText =
//                               await _translateText(text, _selectedLanguage);
//                           setState(() {
//                             _currentMessage = translatedText;
//                           });
//                         },
//                         decoration: InputDecoration(
//                           hintText: 'Type a message...',
//                           contentPadding: const EdgeInsets.symmetric(
//                               vertical: 0,
//                               horizontal: 10), // Center the text vertically
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.send,
//                     color: Colors.blue,
//                   ),
//                   onPressed: () {
//                     _sendMessage(widget.contact);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getLanguageName(String languageCode) {
//     // Map of language codes to names
//     Map<String, String> languageNames = {
//       'af': 'Afrikaans',
//       'sq': 'Albanian',
//       'am': 'Amharic',
//       'ar': 'Arabic',
//       'hy': 'Armenian',
//       'az': 'Azerbaijani',
//       'eu': 'Basque',
//       'be': 'Belarusian',
//       'bn': 'Bengali',
//       'bs': 'Bosnian',
//       'bg': 'Bulgarian',
//       'ca': 'Catalan',
//       'ceb': 'Cebuano',
//       'ny': 'Chichewa',
//       'zh-CN': 'Chinese CN',
//       'zh-TW': 'Chinese TW',
//       'co': 'Corsican',
//       'hr': 'Croatian',
//       'cs': 'Czech',
//       'da': 'Danish',
//       'nl': 'Dutch',
//       'en': 'English',
//       'eo': 'Esperanto',
//       'et': 'Estonian',
//       'tl': 'Filipino',
//       'fi': 'Finnish',
//       'fr': 'French',
//       'fy': 'Frisian',
//       'gl': 'Galician',
//       'ka': 'Georgian',
//       'de': 'German',
//       'el': 'Greek',
//       'gu': 'Gujarati',
//       'ht': 'Haitian Creole',
//       'ha': 'Hausa',
//       'haw': 'Hawaiian',
//       'iw': 'Hebrew',
//       'hi': 'Hindi',
//       'hmn': 'Hmong',
//       'hu': 'Hungarian',
//       'is': 'Icelandic',
//       'ig': 'Igbo',
//       'id': 'Indonesian',
//       'ga': 'Irish',
//       'it': 'Italian',
//       'ja': 'Japanese',
//       'jw': 'Javanese',
//       'kn': 'Kannada',
//       'kk': 'Kazakh',
//       'km': 'Khmer',
//       'ko': 'Korean',
//       'ku': 'Kurdish (Kurmanji)',
//       'ky': 'Kyrgyz',
//       'lo': 'Lao',
//       'la': 'Latin',
//       'lv': 'Latvian',
//       'lt': 'Lithuanian',
//       'lb': 'Luxembourgish',
//       'mk': 'Macedonian',
//       'mg': 'Malagasy',
//       'ms': 'Malay',
//       'ml': 'Malayalam',
//       'mt': 'Maltese',
//       'mi': 'Maori',
//       'mr': 'Marathi',
//       'mn': 'Mongolian',
//       'my': 'Burmese',
//       'ne': 'Nepali',
//       'no': 'Norwegian',
//       'or': 'Odia',
//       'ps': 'Pashto',
//       'fa': 'Persian',
//       'pl': 'Polish',
//       'pt': 'Portuguese',
//       'pa': 'Punjabi',
//       'ro': 'Romanian',
//       'ru': 'Russian',
//       'sm': 'Samoan',
//       'gd': 'Scots Gaelic',
//       'sr': 'Serbian',
//       'st': 'Sesotho',
//       'sn': 'Sesotho',
//       'sd': 'Sindhi',
//       'si': 'Sinhala',
//       'sk': 'Slovak',
//       'sl': 'Slovenian',
//       'so': 'Somali',
//       'es': 'Spanish',
//       'su': 'Sundanese',
//       'sw': 'Swahili',
//       'sv': 'Swedish',
//       'tg': 'Tajik',
//       'ta': 'Tamil',
//       'te': 'Telugu',
//       'th': 'Thai',
//       'tr': 'Turkish',
//       'uk': 'Ukrainian',
//       'ur': 'Urdu',
//       'ug': 'Uyghur',
//       'uz': 'Uzbek',
//       'vi': 'Vietnamese',
//       'cy': 'Welsh',
//       'xh': 'Xhosa',
//       'yi': 'Yiddish',
//       'yo': 'Yoruba',
//       'zu': 'Zulu',
//       // Add more language code to name mappings here...
//     };

//     return languageNames[languageCode] ?? 'Unknown Language';
//   }

//   void _sendMessage(Contact contact) async {
//     String originalMessage = _messageController.text.trim();
//     String translatedMessage =
//         await _translateText(originalMessage, _selectedLanguage);

//     if (originalMessage.isNotEmpty) {
//       String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
//       String receiverPhoneNumber =
//           contact.phones!.first.value?.replaceAll(' ', '') ?? '';

//       _firestore
//           .collection('users')
//           .where('phone_number', isEqualTo: receiverPhoneNumber)
//           .get()
//           .then((querySnapshot) async {
//         if (querySnapshot.docs.isNotEmpty) {
//           String receiverUid = querySnapshot.docs.first['uid'];
//           DateTime currentTimestamp = DateTime.now();

//           await _firestore.collection('messages2').add({
//             'senderId': _currentUser?.uid,
//             'receiverId': widget.otherUserId,
//             'originalText': originalMessage,
//             'translatedText': translatedMessage,
//             'isSentByMe': true,
//             'timestamp': Timestamp.fromDate(currentTimestamp),
//             'language': _selectedLanguage,
//             'isOriginal': true,
//           });

//           _messageController.clear();
//           _currentMessage = '';
//         } else {
//           // Handle the case where the receiver's UID is not found
//           // You may want to show an error message to the user
//         }
//       });
//     }
//   }

//   void _showPopupMenu(BuildContext context) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (BuildContext context) => CupertinoActionSheet(
//         actions: [
//           CupertinoActionSheetAction(
//             onPressed: () {
//               Navigator.of(context).pop();
//               // Perform the action for Share
//             },
//             child: const Text("Camera"),
//           ),
//           CupertinoActionSheetAction(
//             onPressed: () {
//               Navigator.of(context).pop();
//               // Perform the action for Save To Gallery
//             },
//             child: const Text("Photo and Video library"),
//           ),
//           CupertinoActionSheetAction(
//             onPressed: () {
//               Navigator.of(context).pop();
//               // Perform the action for Delete
//             },
//             //isDestructiveAction: true,
//             child: const Text("Documents"),
//           ),
//         ],
//         cancelButton: CupertinoActionSheetAction(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text(
//             "Cancel",
//             style: TextStyle(color: Colors.red),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<String> _translateText(String text, String targetLanguage) async {
//     final translator = GoogleTranslator();
//     Translation translation =
//         await translator.translate(text, to: targetLanguage);
//     return translation.text;
//   }
// }

// class ChatMessage extends StatefulWidget {
//   final String originalText;
//   final String? translatedText;
//   final bool isSentByMe;
//   final DateTime timestamp;
//   final String? language;
//   final bool isOriginal;

//   ChatMessage({
//     required this.originalText,
//     this.translatedText,
//     required this.isSentByMe,
//     required this.timestamp,
//     this.language,
//     required this.isOriginal,
//   });

//   @override
//   _ChatMessageState createState() => _ChatMessageState();

//   Map<String, dynamic> toMap() {
//     return {
//       'originalText': originalText,
//       'translatedText': translatedText,
//       'isSentByMe': isSentByMe,
//       'timestamp':
//           Timestamp.fromDate(timestamp), // Convert DateTime to Timestamp
//       'language': language,
//       'isOriginal': isOriginal,
//     };
//   }
// }

// class _ChatMessageState extends State<ChatMessage> {
//   bool showOriginal = true;
//   DateTime? lastDisplayedDate;

//   @override
//   Widget build(BuildContext context) {
//     String formattedTime = _formatTime(widget.timestamp);
//     String formattedDate = _formatDate(widget.timestamp);

//     String displayText = showOriginal
//         ? widget.originalText
//         : widget.translatedText ?? ''; // Null check

//     bool displayDateHeader = _shouldDisplayDateHeader();

//     if (displayDateHeader) {
//       lastDisplayedDate = widget.timestamp;
//     }

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           showOriginal = !showOriginal;
//         });
//       },
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (displayDateHeader)
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: const Color(0xffDDDDE9),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8.0, right: 8),
//                     child: Text(
//                       '$formattedDate, ${_getDayOfWeek(widget.timestamp)}',
//                       style: const TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           Row(
//             mainAxisAlignment: widget.isSentByMe
//                 ? MainAxisAlignment.end
//                 : MainAxisAlignment.start,
//             children: [
//               Container(
//                 margin: const EdgeInsets.all(8.0),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12.0,
//                   vertical: 8.0,
//                 ),
//                 decoration: BoxDecoration(
//                   color: widget.isSentByMe ? Colors.blue : Colors.white,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width / 2,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       displayText,
//                       style: TextStyle(
//                         color: widget.isSentByMe ? Colors.white : Colors.black,
//                       ),
//                     ),
//                     if (formattedTime.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 8.0,
//                           right: 8.0,
//                           bottom: 4.0,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               formattedTime,
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12.0,
//                               ),
//                             ),
//                             if (widget.language != null)
//                               Text(
//                                 'See ${widget.language}',
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 10.0,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   bool _shouldDisplayDateHeader() {
//     return lastDisplayedDate == null ||
//         !_isSameDate(lastDisplayedDate!, widget.timestamp);
//   }

//   String _formatTime(DateTime time) {
//     return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
//   }

//   String _formatDate(DateTime date) {
//     return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
//   }

//   String _getDayOfWeek(DateTime date) {
//     List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//     return daysOfWeek[date.weekday - 1];
//   }

//   bool _isSameDate(DateTime date1, DateTime date2) {
//     return date1.year == date2.year &&
//         date1.month == date2.month &&
//         date1.day == date2.day;
//   }
// }
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/callingbackend/callingfeature.dart';
import 'package:flutter_application_lengua/ui/chatinfo.dart';
import 'package:flutter_application_lengua/ui/model/chatmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';
import 'package:translator/translator.dart';

class ChatPage extends StatefulWidget {
  final Contact contact;
  final String currentUserId;
  final String otherUserId;

  ChatPage(
      {required this.contact,
      required this.currentUserId,
      required this.otherUserId,
      String? otherUserImageUrl});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _textEditingController = TextEditingController();
  late CollectionReference _messagesCollection;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _messagesCollection = _firestore.collection('messages2');
  }

  Stream<List<QuerySnapshot>> _getMessages() {
    final senderMessages = _messagesCollection
        .where('senderId', isEqualTo: _currentUser?.uid)
        .where('receiverId', isEqualTo: widget.otherUserId)
        .orderBy('timestamp', descending: true)
        .snapshots();

    final receiverMessages = _messagesCollection
        .where('senderId', isEqualTo: widget.otherUserId)
        .where('receiverId', isEqualTo: _currentUser?.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();

    return CombineLatestStream.list([senderMessages, receiverMessages])
        .map((List<QuerySnapshot> snapshots) {
      return snapshots ?? [];
    });
  }

  List<Map<String, dynamic>> extractMessages(List<QuerySnapshot> snapshots) {
    List<Map<String, dynamic>> messages = [];

    for (var snapshot in snapshots) {
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('originalText')) {
          messages.add({
            'originalText': data['originalText'],
            'language': data['language'] ?? '',
            'translatedText': data['translatedText'], // Add this line
            'senderId': data['senderId'],
            'timestamp': (data['timestamp'] as Timestamp).toDate(),
          });
        } else if (data.containsKey('imageUrl')) {
          messages.add({
            'imageUrl': data['imageUrl'],
            'senderId': data['senderId'],
            'timestamp': (data['timestamp'] as Timestamp).toDate(),
          });
        }
      }
    }

    // Sort messages based on timestamp
    messages.sort((a, b) =>
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    return messages;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Perform the image upload and message sending
      _uploadImageAndSendMessage(imageFile);
    }
  }

  Future<String> _getReceiverUid(String receiverPhoneNumber) async {
    String receiverUid = '';

    await _firestore
        .collection('users')
        .where('phone_number', isEqualTo: receiverPhoneNumber)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        receiverUid = querySnapshot.docs.first['uid'];
      }
    });

    return receiverUid;
  }

  Future<void> _uploadImageAndSendMessage(File imageFile) async {
    String currentUserId = _currentUser?.uid ?? '';
    String receiverPhoneNumber =
        widget.contact.phones!.first.value?.replaceAll(' ', '') ?? '';
    String receiverUid = await _getReceiverUid(receiverPhoneNumber);

    if (receiverUid.isNotEmpty) {
      String imagePath =
          'images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(imagePath);
      UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();
        DateTime currentTimestamp = DateTime.now();

        await _firestore.collection('messages2').add({
          'senderId': currentUserId,
          'receiverId': receiverUid,
          'imageUrl': imageUrl,
          'timestamp': Timestamp.fromDate(currentTimestamp),
        });

        _messageController.clear();
        _currentMessage = '';
      });
    } else {
      // Handle the case where the receiver's UID is not found
      // You may want to show an error message to the user
    }
  }

  List<ChatMessage> _messages = [];
  String _currentMessage = '';
  String _selectedLanguage = 'en'; // Default language is English
  String _selectedLanguageName = 'English'; // Default language name

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120.0),
            child: Column(
              children: [
                Container(
                  height: 8.h,
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                          image: AssetImage("assets/images/ad.jpeg"),
                          fit: BoxFit.fill)),
                ),
                Expanded(
                  child: AppBar(
                    backgroundColor: const Color(0xffF6F6F6),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.call,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          String receiverUid = await _getReceiverUid(widget
                                  .contact.phones?.first.value
                                  ?.replaceAll(' ', '') ??
                              '');
                          if (receiverUid.isNotEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => MyCall(
                                        callID: receiverUid,
                                      )),
                            );
                          } else {
                            // Handle the case where the receiver's UID is not found
                            // You may want to show an error message to the user
                          }
                        },
                      ),
                      _buildLanguageDropdown(),
                      Container(
                        width: 60,
                        child: Text(
                          _selectedLanguageName,
                          style: TextStyle(fontSize: 14.0, color: Colors.blue),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    title: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Chatinfo()));
                      },
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/Oval.png'),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.contact.displayName ?? "No Name"),
                              InkWell(
                                onTap: () {
                                  // Handle tap on contact info
                                },
                                child: const Text(
                                  'Tap here for info',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(179, 236, 236, 236),
            ),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<QuerySnapshot>>(
                    stream: _getMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final messages = extractMessages(snapshot.data ?? []);

                      if (messages.isEmpty) {
                        return Center(child: Text('No messages yet.'));
                      }

                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final senderId = message['senderId'];
                          final isCurrentUser = senderId == _currentUser!.uid;

                          return Align(
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(8),
                              child: ChatMessage(
                                originalText: message['originalText'] ?? '',
                                translatedText: message['translatedText'] ??
                                    '', // Add your logic for translated text
                                isSentByMe: isCurrentUser,
                                timestamp: (message['timestamp'] is int)
                                    ? DateTime.fromMillisecondsSinceEpoch(
                                        message['timestamp'] as int)
                                    : message['timestamp'] as DateTime? ??
                                        DateTime.now(),
                                language: message['language'] ??
                                    '', // Add your logic for language
                                isOriginal: message['isOriginal'] ??
                                    true, // Add your logic for isOriginal
                                imageUrl: message[
                                    'imageUrl'], // Add imageUrl to the ChatMessage
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildInputField(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLanguageDropdown() {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          _selectedLanguage = value;
          _selectedLanguageName = _getLanguageName(value);
        });
      },
      icon: const Icon(
        Icons.more_vert,
        color: Colors.blue, // <-- Set icon color to blue
      ),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'af',
            child: Text('Afrikaans', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'sq',
            child: Text('Albanian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'am',
            child: Text('Amharic', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ar',
            child: Text('Arabic', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'hy',
            child: Text('Armenian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'az',
            child: Text('Azerbaijani', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'eu',
            child: Text('Basque', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'be',
            child: Text('Belarusian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'bn',
            child: Text('Bengali', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'bs',
            child: Text('Bosnian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'bg',
            child: Text('Bulgarian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ca',
            child: Text('Catalan', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ceb',
            child: Text('Cebuano', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ny',
            child: Text('Chichewa', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'zh-CN',
            child: Text('Chinese (Simplified)',
                style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'zh-TW',
            child: Text('Chinese (Traditional)',
                style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'co',
            child: Text('Corsican', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'hr',
            child: Text('Croatian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'cs',
            child: Text('Czech', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'da',
            child: Text('Danish', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'nl',
            child: Text('Dutch', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'en',
            child: Text('English', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'eo',
            child: Text('Esperanto', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'et',
            child: Text('Estonian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'tl',
            child: Text('Filipino', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'fi',
            child: Text('Finnish', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'fr',
            child: Text('French', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'fy',
            child: Text('Frisian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'gl',
            child: Text('Galician', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ka',
            child: Text('Georgian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'de',
            child: Text('German', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'el',
            child: Text('Greek', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'gu',
            child: Text('Gujarati', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ht',
            child:
                Text('Haitian Creole', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ha',
            child: Text('Hausa', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'haw',
            child: Text('Hawaiian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'iw',
            child: Text('Hebrew', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'hi',
            child: Text('Hindi', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'hmn',
            child: Text('Hmong', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'hu',
            child: Text('Hungarian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'is',
            child: Text('Icelandic', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ig',
            child: Text('Igbo', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'id',
            child: Text('Indonesian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ga',
            child: Text('Irish', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'it',
            child: Text('Italian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ja',
            child: Text('Japanese', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'jw',
            child: Text('Javanese', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'kn',
            child: Text('Kannada', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'kk',
            child: Text('Kazakh', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'km',
            child: Text('Khmer', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ko',
            child: Text('Korean', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ku',
            child: Text('Kurdish (Kurmanji)',
                style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ky',
            child: Text('Kyrgyz', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'lo',
            child: Text('Lao', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'la',
            child: Text('Latin', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'lv',
            child: Text('Latvian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'lt',
            child: Text('Lithuanian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'lb',
            child: Text('Luxembourgish', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'mk',
            child: Text('Macedonian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'mg',
            child: Text('Malagasy', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ms',
            child: Text('Malay', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ml',
            child: Text('Malayalam', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'mt',
            child: Text('Maltese', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'mi',
            child: Text('Maori', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'mr',
            child: Text('Marathi', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'mn',
            child: Text('Mongolian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'my',
            child: Text('Burmese', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ne',
            child: Text('Nepali', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'no',
            child: Text('Norwegian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'or',
            child: Text('Odia', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ps',
            child: Text('Pashto', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'fa',
            child: Text('Persian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'pl',
            child: Text('Polish', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'pt',
            child: Text('Portuguese', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'pa',
            child: Text('Punjabi', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ro',
            child: Text('Romanian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ru',
            child: Text('Russian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'sm',
            child: Text('Samoan', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'gd',
            child: Text('Scots Gaelic', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'sr',
            child: Text('Serbian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'st',
            child: Text('Sesotho', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'sn',
            child: Text('Sesotho', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'sd',
            child: Text('Sindhi', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'si',
            child: Text('Sinhala', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'sk',
            child: Text('Slovak', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'sl',
            child: Text('Slovenian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'so',
            child: Text('Somali', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'es',
            child: Text('Spanish', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'su',
            child: Text('Sundanese', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'sw',
            child: Text('Swahili', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'sv',
            child: Text('Swedish', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'tg',
            child: Text('Tajik', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ta',
            child: Text('Tamil', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'te',
            child: Text('Telugu', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'th',
            child: Text('Thai', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'tr',
            child: Text('Turkish', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'uk',
            child: Text('Ukrainian', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ur',
            child: Text('Urdu', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'ug',
            child: Text('Uyghur', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'uz',
            child: Text('Uzbek', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'vi',
            child: Text('Vietnamese', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'cy',
            child: Text('Welsh', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'xh',
            child: Text('Xhosa', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'yi',
            child: Text('Yiddish', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'yo',
            child: Text('Yoruba', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem<String>(
            value: 'zu',
            child: Text('Zulu', style: TextStyle(color: Colors.white)),
          ),
        ];
      },
      color: Colors.blue,
    );
  }

  Widget _buildInputField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Text(_currentMessage),
          ),
          Container(
            color: const Color(0xffF6F6F6),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    _showPopupMenu(context);
                  },
                ),
                Expanded(
                  child: SizedBox(
                    height: 35,
                    child: Container(
                      // Adjust margin as needed
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: _messageController,
                        onChanged: (text) async {
                          String translatedText =
                              await _translateText(text, _selectedLanguage);
                          setState(() {
                            _currentMessage = translatedText;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10), // Center the text vertically
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    _sendMessage(widget.contact);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    // Map of language codes to names
    Map<String, String> languageNames = {
      'af': 'Afrikaans',
      'sq': 'Albanian',
      'am': 'Amharic',
      'ar': 'Arabic',
      'hy': 'Armenian',
      'az': 'Azerbaijani',
      'eu': 'Basque',
      'be': 'Belarusian',
      'bn': 'Bengali',
      'bs': 'Bosnian',
      'bg': 'Bulgarian',
      'ca': 'Catalan',
      'ceb': 'Cebuano',
      'ny': 'Chichewa',
      'zh-CN': 'Chinese CN',
      'zh-TW': 'Chinese TW',
      'co': 'Corsican',
      'hr': 'Croatian',
      'cs': 'Czech',
      'da': 'Danish',
      'nl': 'Dutch',
      'en': 'English',
      'eo': 'Esperanto',
      'et': 'Estonian',
      'tl': 'Filipino',
      'fi': 'Finnish',
      'fr': 'French',
      'fy': 'Frisian',
      'gl': 'Galician',
      'ka': 'Georgian',
      'de': 'German',
      'el': 'Greek',
      'gu': 'Gujarati',
      'ht': 'Haitian Creole',
      'ha': 'Hausa',
      'haw': 'Hawaiian',
      'iw': 'Hebrew',
      'hi': 'Hindi',
      'hmn': 'Hmong',
      'hu': 'Hungarian',
      'is': 'Icelandic',
      'ig': 'Igbo',
      'id': 'Indonesian',
      'ga': 'Irish',
      'it': 'Italian',
      'ja': 'Japanese',
      'jw': 'Javanese',
      'kn': 'Kannada',
      'kk': 'Kazakh',
      'km': 'Khmer',
      'ko': 'Korean',
      'ku': 'Kurdish (Kurmanji)',
      'ky': 'Kyrgyz',
      'lo': 'Lao',
      'la': 'Latin',
      'lv': 'Latvian',
      'lt': 'Lithuanian',
      'lb': 'Luxembourgish',
      'mk': 'Macedonian',
      'mg': 'Malagasy',
      'ms': 'Malay',
      'ml': 'Malayalam',
      'mt': 'Maltese',
      'mi': 'Maori',
      'mr': 'Marathi',
      'mn': 'Mongolian',
      'my': 'Burmese',
      'ne': 'Nepali',
      'no': 'Norwegian',
      'or': 'Odia',
      'ps': 'Pashto',
      'fa': 'Persian',
      'pl': 'Polish',
      'pt': 'Portuguese',
      'pa': 'Punjabi',
      'ro': 'Romanian',
      'ru': 'Russian',
      'sm': 'Samoan',
      'gd': 'Scots Gaelic',
      'sr': 'Serbian',
      'st': 'Sesotho',
      'sn': 'Sesotho',
      'sd': 'Sindhi',
      'si': 'Sinhala',
      'sk': 'Slovak',
      'sl': 'Slovenian',
      'so': 'Somali',
      'es': 'Spanish',
      'su': 'Sundanese',
      'sw': 'Swahili',
      'sv': 'Swedish',
      'tg': 'Tajik',
      'ta': 'Tamil',
      'te': 'Telugu',
      'th': 'Thai',
      'tr': 'Turkish',
      'uk': 'Ukrainian',
      'ur': 'Urdu',
      'ug': 'Uyghur',
      'uz': 'Uzbek',
      'vi': 'Vietnamese',
      'cy': 'Welsh',
      'xh': 'Xhosa',
      'yi': 'Yiddish',
      'yo': 'Yoruba',
      'zu': 'Zulu',
      // Add more language code to name mappings here...
    };

    return languageNames[languageCode] ?? 'Unknown Language';
  }

  void _sendMessage(Contact contact) async {
    String originalMessage = _messageController.text.trim();
    String translatedMessage =
        await _translateText(originalMessage, _selectedLanguage);

    if (originalMessage.isNotEmpty) {
      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      String receiverPhoneNumber =
          contact.phones!.first.value?.replaceAll(' ', '') ?? '';

      _firestore
          .collection('users')
          .where('phone_number', isEqualTo: receiverPhoneNumber)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          String receiverUid = querySnapshot.docs.first['uid'];
          DateTime currentTimestamp = DateTime.now();

          await _firestore.collection('messages2').add({
            'senderId': _currentUser?.uid,
            'receiverId': widget.otherUserId,
            'originalText': originalMessage,
            'translatedText': translatedMessage,
            'isSentByMe': true,
            'timestamp': Timestamp.fromDate(currentTimestamp),
            'language': _selectedLanguage,
            'isOriginal': true,
          });

          _messageController.clear();
          _currentMessage = '';
        } else {
          // Handle the case where the receiver's UID is not found
          // You may want to show an error message to the user
        }
      });
    }
  }

  void _showPopupMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: _pickImage,
            child: const Text("Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              // Perform the action for Save To Gallery
            },
            child: const Text("Photo and Video library"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              // Perform the action for Delete
            },
            //isDestructiveAction: true,
            child: const Text("Documents"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Future<String> _translateText(String text, String targetLanguage) async {
    final translator = GoogleTranslator();
    Translation translation =
        await translator.translate(text, to: targetLanguage);
    return translation.text;
  }
}

class ChatMessage extends StatefulWidget {
  final String? originalText;
  final String? translatedText;
  final bool isSentByMe;
  final DateTime timestamp;
  final String? language;
  final bool isOriginal;
  final String? imageUrl;

  ChatMessage({
    this.originalText,
    this.translatedText,
    required this.isSentByMe,
    required this.timestamp,
    this.language,
    required this.isOriginal,
    this.imageUrl,
  });

  @override
  _ChatMessageState createState() => _ChatMessageState();

  Map<String, dynamic> toMap() {
    return {
      'originalText': originalText,
      'translatedText': translatedText,
      'isSentByMe': isSentByMe,
      'timestamp': Timestamp.fromDate(timestamp),
      'language': language,
      'isOriginal': isOriginal,
      'imageUrl': imageUrl,
    };
  }
}

class _ChatMessageState extends State<ChatMessage> {
  bool showOriginal = true;
  DateTime? lastDisplayedDate;

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTime(widget.timestamp);
    String formattedDate = _formatDate(widget.timestamp);

    String displayText =
        showOriginal ? widget.originalText ?? '' : widget.translatedText ?? '';

    bool displayDateHeader = _shouldDisplayDateHeader();

    if (displayDateHeader) {
      lastDisplayedDate = widget.timestamp;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showOriginal = !showOriginal;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (displayDateHeader)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xffDDDDE9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Text(
                      '$formattedDate, ${_getDayOfWeek(widget.timestamp)}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: widget.isSentByMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: widget.isSentByMe ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.originalText != null)
                      Text(
                        displayText,
                        style: TextStyle(
                          color:
                              widget.isSentByMe ? Colors.white : Colors.black,
                        ),
                      ),
                    if (widget.imageUrl !=
                        null) // Check if it's an image message
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.network(
                          widget.imageUrl!,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (formattedTime.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                            if (widget.language != null)
                              Text(
                                'See ${widget.language}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _shouldDisplayDateHeader() {
    return lastDisplayedDate == null ||
        !_isSameDate(lastDisplayedDate!, widget.timestamp);
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return daysOfWeek[date.weekday - 1];
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
