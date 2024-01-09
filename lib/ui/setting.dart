import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/ui/account.dart';
import 'package:flutter_application_lengua/ui/chatsetting.dart';
import 'package:flutter_application_lengua/ui/home.dart';
import 'package:flutter_application_lengua/ui/otp1.dart';
import 'package:sizer/sizer.dart';

class setting extends StatelessWidget {
  const setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffF6F6F6),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(115.0),
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
                    title: Center(
                      child: Text("Settings"),
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
                  title: Text("Doreamon",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Digital goodies designer - Pixsellz",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 10.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      "assets/images/Oval.png",
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 13.sp,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                ListTile(
                  tileColor: Colors.white,
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.key,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Account',
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => account()));
                  },
                ),
                ListTile(
                  tileColor: Colors.white,
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.chat,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chat',
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => chatsetting()));
                  },
                ),
                ListTile(
                  tileColor: Colors.white,
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.notification_add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notification',
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
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Logout',
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => otp1()));
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                ListTile(
                  tileColor: Colors.white,
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.info,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Default Language',
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
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Set Default',
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
