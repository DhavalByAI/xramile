import 'package:flutter/material.dart';

import '../google map/google_map_screen.dart';
import '../notifications/notifications_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const GoogleMapScreen(),
    const NotificationScreen(),
  ];
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          PageStorage(bucket: _pageStorageBucket, child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
