import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/ui/home.dart';
import 'package:flutter_application_lengua/ui/userprofile.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:sizer/sizer.dart';

class otp2 extends StatelessWidget {
  final String verificationId;
  final String phoneNumber;

  const otp2({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pin = ''; // Declare pin variable outside the widget build method

    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff007AFF),
          title: Center(
            child: Text(
              "Enter Code",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "We’ve sent an SMS with an activation\n code to your phone $phoneNumber",
                  style: TextStyle(fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 3.h,
                ),
                PinInputTextField(
                  pinLength: 6,
                  decoration: BoxLooseDecoration(
                    strokeWidth: 1,
                    strokeColorBuilder: PinListenColorBuilder(
                      Colors.black, // Default border color
                      Colors.black, // Border color when focused
                    ),
                  ),
                  controller: TextEditingController(),
                  autoFocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmit: (enteredPin) {
                    pin =
                        enteredPin; // Assign the entered pin to the outer variable
                  },
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Implement code for resending OTP
                      },
                      child: Text("Send code again"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // Implement any additional logic if needed before navigation
                          // ...

                          // Create PhoneAuthCredential using the entered OTP and verification ID
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: pin,
                          );

                          // Sign in with the credential
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithCredential(credential);

                          // Save user UID in Firestore
                          //  await saveUidInFirestore(userCredential.user!.uid);

                          // Navigate to the home page
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => UserProfile()),
                          );
                        } catch (e) {
                          // Handle verification failure
                          print(e.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: 20.w,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        primary: Color(0XFF007AFF),
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.white),
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
    });
  }

  // Future<void> saveUidInFirestore(String uid) async {
  //   try {
  //     FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //     // Replace 'users' with your Firestore collection name
  //     CollectionReference users = _firestore.collection('users');

  //     // Replace 'phone' with the document field you want to use to identify users
  //     DocumentReference userRef = users.doc(phoneNumber);

  //     // Save the UID in Firestore
  //     await userRef.set({
  //       'uid': uid,
  //       // Add other user data as needed
  //     });
  //   } catch (e) {
  //     print("Error saving UID in Firestore: $e");
  //   }
  // }
}
