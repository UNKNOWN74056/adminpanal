import 'package:admin/clubs/clubs.dart';
import 'package:admin/tournament/turnaments.dart';
import 'package:admin/user/user.dart';

import 'package:flutter/material.dart';

class MyAdminPage extends StatefulWidget {
  const MyAdminPage({
    super.key,
  });

  @override
  State<MyAdminPage> createState() => _MyAdminPageState();
}

class _MyAdminPageState extends State<MyAdminPage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    Users(),
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
    return Scaffold(
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
    );
  }
}
