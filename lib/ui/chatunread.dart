import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/my_flutter_app_icons.dart';
import 'package:flutter_application_lengua/ui/chat2.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class chatunread extends StatefulWidget {
  const chatunread({Key? key});

  @override
  State<chatunread> createState() => _chatunreadState();
}

class _chatunreadState extends State<chatunread> {
  bool isMenuOpen = false;
  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
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
                    backgroundColor: Color(0xff007AFF),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Unread Chats",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  "done",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ))
                            // SizedBox(width: 4.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: ListView.builder(
            itemCount: 20,
            padding: const EdgeInsets.symmetric(vertical: 0),
            itemBuilder: (context, index) {
              return Slidable(
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => ChatPage()),
                    // );
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Doreamon",
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
                                    "Hey! i am Doraemon ",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "2:23 pm",
                                    style: TextStyle(
                                      fontSize: 14,
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
                            backgroundImage: AssetImage(
                              "assets/images/Oval.png",
                            ),
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
      );
    });
  }

  void _showEditDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              // Perform the action for Share
            },
            child: Text("Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              // Perform the action for Save To Gallery
            },
            child: Text("Photo and Video library"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              // Perform the action for Delete
            },
            //isDestructiveAction: true,
            child: Text("Documents"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
