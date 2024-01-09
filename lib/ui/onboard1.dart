import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/ui/onboard2.dart';
import 'package:sizer/sizer.dart';

class onboard1 extends StatelessWidget {
  const onboard1({super.key});

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
                        image: AssetImage("assets/images/sending.jpg"))),
              ),
              Text(
                "Write a message in your own language",
                style: TextStyle(fontSize: 18.sp, color: Color(0XFF007AFF)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => onboard2()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 25.w,
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
