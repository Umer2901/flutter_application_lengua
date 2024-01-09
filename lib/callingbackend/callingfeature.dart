// import 'package:flutter/material.dart';
// import 'package:flutter_application_lengua/callingbackend/constant.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class MyCall extends StatelessWidget {
//   const MyCall({Key? key, required this.callID}) : super(key: key);
//   final String callID;

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID: MyConst
//           .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//       appSign: MyConst
//           .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//       userID: MyLogin.userId,
//       userName: MyLogin.name,
//       callID: callID,
//       // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//         ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_lengua/callingbackend/constant.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MyCall extends StatelessWidget {
  const MyCall({Key? key, required this.callID}) : super(key: key);

  final String callID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      // Fetch user name from Firestore based on the current user's ID
      future: _getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String userName = snapshot.data ??
              'Unknown User'; // Use a default value if the user name is not available
          return ZegoUIKitPrebuiltCall(
            appID: MyConst.appId,
            appSign: MyConst.appSign,
            userID: FirebaseAuth.instance.currentUser?.uid ?? '',
            userName: userName,
            callID: callID,
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
              ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
          );
        }
      },
    );
  }

  Future<String> _getUserName() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (userDoc.exists) {
        return userDoc['name'];
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return 'Unknown User';
    }
  }
}
