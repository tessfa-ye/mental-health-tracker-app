import 'package:mentalhealthtrackerapp/HomeScreen.dart';
import 'package:mentalhealthtrackerapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentalhealthtrackerapp/pages/activities_page.dart';
import 'package:mentalhealthtrackerapp/AI_chat/chat_screen.dart';
import 'package:mentalhealthtrackerapp/pages/profilePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class AppBottomNavigation extends StatefulWidget {
  const AppBottomNavigation({super.key});

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const UserData(),
    const ChatScreen(),
    const ActivitiesScreen(),
    Profile(),
  ];

  void getcredentials() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc('${patientInfo.email}')
        .get();
    setState(() {
      patientInfo.name = doc['name'];
      patientInfo.address = doc['friend'];
      patientInfo.biography = doc['friendContact'];
      patientInfo.phoneNo = doc['friendPhone'];
      patientInfo.gender = doc['specialist'];
    });
  }

  @override
  void initState() {
    getcredentials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Choose a soft neutral color for the background
    Color navBarColor = Color.fromARGB(255, 204, 214, 243);
    // subtle light grey
    Color buttonColor = Colors.blueAccent; // soft accent for active icon

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        backgroundColor:
            Colors.transparent, // makes the screen visible behind the curve
        color: navBarColor,
        buttonBackgroundColor: buttonColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.black87),
          Icon(Icons.chat_bubble_outline_outlined,
              size: 30, color: Colors.black87),
          Icon(Icons.local_activity, size: 30, color: Colors.black87),
          Icon(Icons.person, size: 30, color: Colors.black87),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
