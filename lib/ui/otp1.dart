import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/ui/otp2.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class otp1 extends StatelessWidget {
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff007AFF),
        title: Center(
          child: Text(
            "Phone number",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please confirm your country code and enter your phone number ",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7, right: 7),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 7.h,
                        width: 29.w,
                        child: TextField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(hintText: "Phone Number"),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await initiatePhoneAuthentication(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 20.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: Color(0XFF007AFF),
                    ),
                    child: Center(
                      child: Text(
                        "Send",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initiatePhoneAuthentication(BuildContext context) async {
    try {
      String phoneNumber = _phoneNumberController.text.trim();
      String formattedPhoneNumber = '+' + phoneNumber;

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          await saveUserDataToFirestore(formattedPhoneNumber);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => otp2(
                verificationId: verificationId,
                phoneNumber: formattedPhoneNumber,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveUserDataToFirestore(String phoneNumber) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Check if a document with the user's UID already exists
      var userDoc = await users.doc(uid).get();

      if (!userDoc.exists) {
        // Document does not exist, create a new one
        await users.doc(uid).set({
          'uid': uid,
          'phone_number': phoneNumber,
        });
      }
    }
  }
}
// class otp1 extends StatelessWidget {
//   TextEditingController _phoneNumberController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, deviceType) {
//       return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Color(0xff007AFF),
//           title: Center(
//             child: Text(
//               "Phone number",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Please confirm your country code and enter your phone number ",
//                   style: TextStyle(fontSize: 12.sp),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Divider(
//                   thickness: 1,
//                   color: Colors.grey,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 7, right: 7),
//                   child: IntrinsicHeight(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: 7.h,
//                           width: 29.w,
//                           child: InternationalPhoneNumberInput(
//                             onInputChanged: (PhoneNumber number) {
//                               // Handle changes to the phone number input
//                               print(number
//                                   .phoneNumber); // Access the complete phone number
//                             },
//                             onInputValidated: (bool value) {
//                               // Validation logic, if needed
//                             },
//                             selectorConfig: SelectorConfig(
//                               selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//                             ),
//                             initialValue: PhoneNumber(
//                                 isoCode: 'US'), // Set your default country code
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             height: 4.h,
//                             child: TextField(
//                               controller:
//                                   _phoneNumberController, // Link the controller
//                               keyboardType: TextInputType.phone,
//                               decoration:
//                                   InputDecoration(hintText: "Phone Number"),
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 4.h,
//                 ),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         // Call function to initiate phone authentication
//                         await initiatePhoneAuthentication(
//                           context,
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(
//                           vertical: 2.h,
//                           horizontal: 20.w,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.sp),
//                         ),
//                         primary: Color(0XFF007AFF),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Send",
//                           style:
//                               TextStyle(fontSize: 12.sp, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 1.h,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Future<void> initiatePhoneAuthentication(BuildContext context) async {
//     try {
//       // Request to send OTP to the provided phone number
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: _getCompletePhoneNumber(),
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // Auto-retrieval completed (e.g., sign in with phone number auto-retrieved)
//           await FirebaseAuth.instance.signInWithCredential(credential);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           // Handle verification failed
//           print(e.message);
//         },
//         codeSent: (String verificationId, int? resendToken) async {
//           // Save user data to Firestore
//           await saveUserDataToFirestore(_getCompletePhoneNumber());

//           // Navigate to the OTP screen
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => otp2(
//                 verificationId: verificationId,
//                 phoneNumber: _getCompletePhoneNumber(),
//               ),
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           // Handle timeout
//         },
//       );
//     } catch (e) {
//       // Handle errors during phone authentication
//       print(e.toString());
//     }
//   }

//   Future<void> saveUserDataToFirestore(String phoneNumber) async {
//     // Get a reference to the Firestore collection
//     CollectionReference users = FirebaseFirestore.instance.collection('users');

//     // Save user data to Firestore
//     await users.add({
//       'phone_number': phoneNumber,
//       // Add other user data if needed
//     });
//   }

//   String _getCompletePhoneNumber() {
//     String phoneNumber = _phoneNumberController.text.trim();
//     String formattedPhoneNumber =
//         '+' + phoneNumber; // Assuming the user enters a valid country code

//     return formattedPhoneNumber;
//   }
// }
