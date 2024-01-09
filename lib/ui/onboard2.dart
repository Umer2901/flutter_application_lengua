import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/ui/onboard1.dart';
import 'package:flutter_application_lengua/ui/otp1.dart';
import 'package:flutter_application_lengua/ui/purchase.dart';
import 'package:sizer/sizer.dart';

class onboard2 extends StatelessWidget {
  const onboard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white, // Set your desired background color
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 80.w,
                width: 80.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/receiving.jpg"))),
              ),
              Text(
                "The recipient will get it in their language",
                style: TextStyle(fontSize: 18.sp, color: Color(0XFF007AFF)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PurchasePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 30.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    primary: Color(0XFF007AFF),
                  ),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
