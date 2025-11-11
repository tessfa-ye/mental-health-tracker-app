// ignore_for_file: camel_case_types

import 'package:mentalhealthtrackerapp/BottomNavigationBar.dart';
import 'package:mentalhealthtrackerapp/IntroScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mentalhealthtrackerapp/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: Access());
  }
}

class Access extends StatefulWidget {
  @override
  State<Access> createState() => _AccessState();
}

class _AccessState extends State<Access> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (sharedPreferences.getString("mental101") != null) {
        setState(() {
          patientInfo.email = sharedPreferences.getString("mental101")!;
          userAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? AppBottomNavigation() : Intro();
  }
}

class patientInfo {
  static String? name;
  static int? age;
  static String? email;
  static String? phoneNo;
  static String? address;
  static String? gender;
  static String? biography;
  // ignore: non_constant_identifier_names
  static String? profile_link;
}
