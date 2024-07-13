import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tim1/pages/dashboard.dart';
import 'package:tim1/pages/fitur/kamera.dart';
import 'package:tim1/pages/fitur/kapasitas.dart';
import 'package:tim1/pages/fitur/suhu.dart';
import 'package:tim1/pages/fitur/tanaman.dart';
import 'package:tim1/pages/profile.dart';

import '../navbar/navbar.dart'; // Import the navbar.dart file

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _currentIndex = 0;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomePageContent(),
      const Dashboard(),
      ProfilePage(
          onLogout: signUserOut,
          email: user.email ?? 'No Email'), // Pass the email here
    ]);
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(192, 22, 182, 43),
              ),
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                _onNavBarTap(1); // Navigate to Dashboard page
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                _onNavBarTap(2); // Navigate to Profile page
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                signUserOut(); // Log out user
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(192, 22, 182, 43),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        onTap: _onNavBarTap,
        currentIndex: _currentIndex,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridItems = [
      {"text": 'Kapasitas', "icon": Icons.storage, "page": Kapasitas()},
      {"text": 'Suhu', "icon": Icons.thermostat, "page": const Suhu()},
      {"text": 'Kamera', "icon": Icons.camera_alt, "page": const Kamera()},
      {"text": 'Tanaman', "icon": Icons.grass, "page": const TanamanScreen()},
    ];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            ClockWidget(), // Add this to display the clock and date
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: gridItems.map((item) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => item["page"] as Widget,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.withOpacity(0.7),
                                Colors.blue.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              item["icon"],
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item["text"] ?? "",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late String _timeString;
  late String _dateString;

  @override
  void initState() {
    super.initState();
    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatTime(now);
    final String formattedDate = _formatDate(now);
    setState(() {
      _timeString = formattedTime;
      _dateString = formattedDate;
    });
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH\nmm').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, y').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _timeString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _dateString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Welcome',
            // ${user.displayName ?? user.email!.split('@')[0]}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const Text(
            'To Next-Gen Hydroponics App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
