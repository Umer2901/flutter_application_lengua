import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Chatinfo extends StatelessWidget {
  const Chatinfo({Key? key});

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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        SizedBox(
                          width: 23.w,
                        ),
                        Text(
                          "Contact Info",
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/Rectangle.png"),
                          fit: BoxFit.fill)),
                ),
                ListTile(
                  title: Text("Doreamon",
                      //  / maxLines: 1,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  subtitle: Text("+1 202 555 0181",
                      maxLines: 1,
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                  trailing: Container(
                    width: 50.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 12.sp,
                          backgroundColor: Color(0xff1984F8),
                          child: Center(
                            child: Icon(
                              Icons.chat_bubble,
                              color: Colors.white,
                              size: 11.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        CircleAvatar(
                          radius: 12.sp,
                          backgroundColor: Color(0xff1984F8),
                          child: Center(
                            child: Icon(
                              Icons.chat_bubble,
                              color: Colors.white,
                              size: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 0,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Design adds value faster, than it adds cost",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                Divider(
                  thickness: 0,
                  color: Colors.grey,
                ),
                ListTile(
                  tileColor: Colors.white,
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.photo_album,
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
                            'Media,Links and Docs',
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
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.language,
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
                            'Set Language',
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
