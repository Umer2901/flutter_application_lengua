import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/my_flutter_app_icons.dart';
import 'package:flutter_application_lengua/ui/call.dart';
import 'package:flutter_application_lengua/ui/chat1.dart';
import 'package:flutter_application_lengua/ui/setting.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    call(),
    chat1(),
    setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Call',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MyFlutterApp.chat,
              color: _selectedIndex == 1 ? Colors.blue : Colors.black,
              size: 25,
            ),
            label: 'Chat',
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MyFlutterApp.setting,
              color: _selectedIndex == 2 ? Colors.blue : Colors.black,
              size: 25,
            ),
            label: 'Setting',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Color(0xffF6F6F6),
        selectedItemColor: Colors.blue,
        iconSize: 30,
        onTap: _onItemTapped,
        elevation: 5,
      ),
    );
  }
}
