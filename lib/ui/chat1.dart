import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/ui/chat2.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class chat1 extends StatefulWidget {
  const chat1({Key? key});

  @override
  State<chat1> createState() => _chat1State();
}

class _chat1State extends State<chat1> {
  bool isChecked = false;
  List<Contact> _contacts = [];

  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance

  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnit = "ca-app-pub-3940256099942544/6300978111";

  String imageUrl = ''; // Declare imageUrl at the class level

  initBannerAd() {
    bannerAd = BannerAd(
      adUnitId: adUnit,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        },
      ),
    );
    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  Future<void> _getContacts() async {
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      // Fetch contacts
      Iterable<Contact> contacts = await ContactsService.getContacts();

      // Fetch registered users from Firestore
      QuerySnapshot registeredUsersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      Set<String> registeredUserPhoneNumbers = Set<String>.from(
        registeredUsersSnapshot.docs
            .map((doc) => (doc.data() as Map<String, dynamic>)['phone_number'])
            .where((phoneNumber) => phoneNumber != null)
            .cast<String>(),
      );

      // Filter contacts that are both in the phone and registered in the app
      List<Contact> matchedContacts = contacts
          .where((contact) =>
              contact.phones != null &&
              contact.phones!.isNotEmpty &&
              registeredUserPhoneNumbers
                  .contains(contact.phones!.first.value?.replaceAll(' ', '')))
          .toList();

      setState(() {
        _contacts = matchedContacts;
      });
    } else {
      // Handle permission not granted
      // You might want to show a dialog or message to the user
    }
  }

  Future<String?> getOtherUserId(String phoneNumber) async {
    // Normalize the phone number by removing non-numeric characters
    String normalizedPhoneNumber =
        phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    try {
      // Fetch other user's ID from Firestore based on the normalized phone number
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone_number', isEqualTo: '+$normalizedPhoneNumber')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming 'uid' is the field in Firestore that contains the user ID
        return querySnapshot.docs.first.get('uid');
      }
    } catch (error) {
      print('Error fetching other user ID: $error');
    }

    return null; // Return null if user not found or an error occurs
  }

  Future<String?> getUserImageURL(String userId) async {
    try {
      // Fetch user image URL from Firestore based on UID
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.get('profile_image_url');
      }
    } catch (error) {
      print('Error fetching user image URL: $error');
    }

    return null; // Return null if image URL not found or an error occurs
  }

  // Function to show the Snackbar with a ListView of contacts
  void _showContactsListSnackbar() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Container(
          height: 150.0, // Adjust the height as needed
          child: ListView.builder(
            itemCount: _contacts.length,
            itemBuilder: (context, index) {
              final contact = _contacts[index];
              return ListTile(
                title: Text(
                  contact.displayName ?? "No Name",
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: Text(contact.phones?.first.value ?? ""),
                onTap: () {
                  // Handle the contact tap as needed
                  scaffoldMessenger.hideCurrentSnackBar(); // Close the Snackbar
                },
              );
            },
          ),
        ),
        duration: Duration(seconds: 50), // Adjust the duration as needed
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () {
            scaffoldMessenger.hideCurrentSnackBar(); // Close the Snackbar
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Container(
              color: Color(0xff007AFF),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isAdLoaded
                      ? SizedBox(
                          height: bannerAd.size.height.toDouble(),
                          width: bannerAd.size.width.toDouble(),
                          child: AdWidget(ad: bannerAd),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Color(0xff007AFF),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chats",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                  // Navigate to chatunread page
                                },
                                icon: Icon(
                                  isChecked
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Show the menu
                                  showMenu(
                                    color: Colors.blue,
                                    context: context,
                                    position:
                                        RelativeRect.fromLTRB(100, 111, 0, 0),
                                    items: [
                                      PopupMenuItem(
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(Icons.group,
                                                  color: Colors.white),
                                              SizedBox(width: 8),
                                              Text(
                                                'Groups',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        value: 'option1',
                                      ),
                                      PopupMenuItem(
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(Icons.broadcast_on_home,
                                                  color: Colors.white),
                                              SizedBox(width: 8),
                                              Text(
                                                'Broadcast',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        value: 'option2',
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              ElevatedButton(
                onPressed: _getContacts,
                child: Text('Fetch Contacts'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return Slidable(
                      child: GestureDetector(
                        onTap: () async {
                          // Get current user ID
                          String? currentUserId = _auth.currentUser?.uid;

                          // Get other user ID from Firestore based on phone number
                          String? otherUserId = await getOtherUserId(
                              contact.phones!.first.value!);

                          if (otherUserId != null) {
                            // Fetch image URL for the other user
                            imageUrl = await getUserImageURL(otherUserId) ?? '';

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  contact: contact,
                                  currentUserId: currentUserId ?? '',
                                  otherUserId: otherUserId,
                                  otherUserImageUrl: imageUrl,
                                ),
                              ),
                            );
                          } else {
                            // Handle the case where other user ID is not found
                            print('Other user ID not found.');
                          }
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  contact.displayName ?? "No Name",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Hey! I am ${contact.displayName}",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                leading: CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(imageUrl)
                                      as ImageProvider<Object>?,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     _showContactsListSnackbar();
          //   },
          //   child: Icon(Icons.list),
          // ),
        ),
      );
    });
  }
}
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_lengua/ui/chat2.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sizer/sizer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class chat1 extends StatefulWidget {
//   const chat1({Key? key});

//   @override
//   State<chat1> createState() => _chat1State();
// }

// class _chat1State extends State<chat1> {
//   bool isChecked = false;
//   List<Contact> _contacts = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _getContacts() async {
//     var status = await Permission.contacts.request();
//     if (status.isGranted) {
//       // Fetch contacts
//       Iterable<Contact> contacts = await ContactsService.getContacts();

//       // Fetch registered users from Firestore
//       QuerySnapshot registeredUsersSnapshot =
//           await FirebaseFirestore.instance.collection('users').get();

//       Set<String> registeredUserPhoneNumbers = Set<String>.from(
//         registeredUsersSnapshot.docs
//             .map((doc) => (doc.data() as Map<String, dynamic>)['phone_number'])
//             .where((phoneNumber) => phoneNumber != null)
//             .cast<String>(),
//       );

//       // Filter contacts that are both in the phone and registered in the app
//       List<Contact> matchedContacts = contacts
//           .where((contact) =>
//               contact.phones != null &&
//               contact.phones!.isNotEmpty &&
//               registeredUserPhoneNumbers
//                   .contains(contact.phones!.first.value?.replaceAll(' ', '')))
//           .toList();

//       setState(() {
//         _contacts = matchedContacts;
//       });
//     } else {
//       // Handle permission not granted
//       // You might want to show a dialog or message to the user
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, deviceType) {
//       return SafeArea(
//         child: Scaffold(
//           appBar: PreferredSize(
//             preferredSize: Size.fromHeight(110.0),
//             child: Container(
//               color: Color(0xff007AFF),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     height: 8.h,
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       image: DecorationImage(
//                         image: AssetImage("assets/images/ad.jpeg"),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: AppBar(
//                       automaticallyImplyLeading: false,
//                       backgroundColor: Color(0xff007AFF),
//                       title: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Chats",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     isChecked = !isChecked;
//                                   });
//                                   // Navigate to chatunread page
//                                 },
//                                 icon: Icon(
//                                   isChecked
//                                       ? Icons.check_box
//                                       : Icons.check_box_outline_blank,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(
//                                   Icons.menu,
//                                   color: Colors.white,
//                                 ),
//                                 onPressed: () {
//                                   // Show the menu
//                                   showMenu(
//                                     color: Colors.blue,
//                                     context: context,
//                                     position:
//                                         RelativeRect.fromLTRB(100, 111, 0, 0),
//                                     items: [
//                                       PopupMenuItem(
//                                         child: Container(
//                                           child: Row(
//                                             children: [
//                                               Icon(Icons.group,
//                                                   color: Colors.white),
//                                               SizedBox(width: 8),
//                                               Text(
//                                                 'Groups',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         value: 'option1',
//                                       ),
//                                       PopupMenuItem(
//                                         child: Container(
//                                           child: Row(
//                                             children: [
//                                               Icon(Icons.broadcast_on_home,
//                                                   color: Colors.white),
//                                               SizedBox(width: 8),
//                                               Text(
//                                                 'Broadcast',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         value: 'option2',
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           body: Column(
//             children: [
//               ElevatedButton(
//                 onPressed: _getContacts,
//                 child: Text('Fetch Contacts'),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _contacts.length,
//                   itemBuilder: (context, index) {
//                     final contact = _contacts[index];
//                     return Slidable(
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => ChatPage(contact: contact),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           color: Colors.white,
//                           child: Column(
//                             children: [
//                               ListTile(
//                                 title: Text(
//                                   contact.displayName ?? "No Name",
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                     fontSize: 16.sp,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           "Hey! I am ${contact.displayName}",
//                                           maxLines: 1,
//                                           style: TextStyle(
//                                             fontSize: 12.sp,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                         Text(
//                                           "2:23 pm",
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Divider(
//                                       thickness: 1,
//                                       color: Colors.grey,
//                                     ),
//                                   ],
//                                 ),
//                                 leading: CircleAvatar(
//                                   radius: 35,
//                                   backgroundImage:
//                                       AssetImage("assets/images/Oval.png"),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

