import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class account extends StatelessWidget {
  const account({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffF6F6F6),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120.0),
            child: Column(
              children: [
                Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                          image: AssetImage("assets/images/ad.jpeg"),
                          fit: BoxFit.fill)),
                ),
                Expanded(
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Color(0xffF6F6F6),
                    title: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          "Settings",
                          style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                        ),
                        SizedBox(
                          width: 17.w,
                        ),
                        Center(child: Text("Account")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  tileColor: Colors.white,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Privacy',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    // Add your onTap functionality here
                  },
                ),
                ListTile(
                  tileColor: Colors.white,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Security',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    // Add your onTap functionality here
                  },
                ),
                ListTile(
                  tileColor: Colors.white,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fingerprint Lock',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    // Add your onTap functionality here
                  },
                ),
                ListTile(
                  tileColor: Colors.white,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pink Lock',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    // Add your onTap functionality here
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                ListTile(
                  tileColor: Colors.white,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Request Account Info',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    // Add your onTap functionality here
                  },
                ),
                ListTile(
                  tileColor: Colors.white,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delete Account',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    // Add your onTap functionality here
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
