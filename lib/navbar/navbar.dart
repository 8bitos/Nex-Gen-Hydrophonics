import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onTap;
  final int currentIndex;

  // ignore: prefer_const_constructors_in_immutables
  BottomNavBar({super.key, required this.onTap, required this.currentIndex});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: widget.currentIndex,
      items: const [
        CurvedNavigationBarItem(
          child: Icon(Icons.home),
          label: 'Home',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(0, 0, 94, 255),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      onTap: widget.onTap,
      letIndexChange: (index) => true,
    );
  }
}
