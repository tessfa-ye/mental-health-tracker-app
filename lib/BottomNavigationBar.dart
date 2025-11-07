import 'package:mentalassessment/HomeScreen.dart';
import 'package:mentalassessment/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentalassessment/pages/activities_page.dart';
import 'package:mentalassessment/opneAI/chat_screen.dart';
import 'package:mentalassessment/pages/profilePage.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const UserData(),
    ChatScreen(),
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
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_outlined),
            label: 'Chat',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            label: 'Activities',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.blueAccent,
          ),
        ],
        selectedItemColor: Colors.redAccent.withOpacity(0.8),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
