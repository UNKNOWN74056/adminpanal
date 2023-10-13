import 'package:admin/view/clubs/clubs.dart';
import 'package:admin/view/tournament/turnaments.dart';
import 'package:admin/view//user/user.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAdminPage extends StatefulWidget {
  const MyAdminPage({super.key});

  @override
  State<MyAdminPage> createState() => _MyAdminPageState();
}

class _MyAdminPageState extends State<MyAdminPage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Users(),
    const clubs(),
    const turnaments()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green, // Set selected item color to green
          unselectedItemColor: Colors.black,
          currentIndex: _selectedIndex,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer),
              label: 'Clubs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_baseball),
              label: 'Tournaments',
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
