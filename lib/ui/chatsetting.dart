import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class chatsetting extends StatelessWidget {
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
                          width: 18.w,
                        ),
                        Center(child: Text("Chats")),
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
                            'Change Wallpaper',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
                        ],
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
                            'Chat Backup',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
                        ],
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
                            'Text Size',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
                        ],
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
                            'Archeive all Chats',
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
                            'Clear all Chats',
                            style: TextStyle(color: Colors.red),
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
                            'Delete all Chats',
                            style: TextStyle(color: Colors.red),
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
