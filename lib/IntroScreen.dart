import 'package:mentalassessment/Account/login_or_register_page.dart';
import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final List<Introduction> list = [
    Introduction(
      title: 'Mental Health Tracker',
      subTitle: 'Keeps an eye on your Mental Health 24 X 7',
      imageUrl: 'assets/MentalHealth.png',
      titleTextStyle: tstyle,
      subTitleTextStyle: ststyle,
      imageHeight: 250,
    ),
    Introduction(
      title: 'Accurate results',
      subTitle:
          'Tries its best to deliver the best functionality for accessing mental health',
      imageUrl: 'assets/care.jpg',
      titleTextStyle: tstyle,
      subTitleTextStyle: ststyle,
      imageHeight: 245,
    ),
    Introduction(
      title: 'Are You Ready',
      subTitle: 'Welcome TO Mental Health Tracker Know You can start',
      imageUrl: 'assets/images/mentaldep.jpg',
      titleTextStyle: tstyle,
      subTitleTextStyle: ststyle,
      imageHeight: 250,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IntroScreenOnboarding(
        backgroudColor: Colors.white,
        foregroundColor: const Color(0xFF0165ff),
        introductionList: list,
        onTapSkipButton: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginOrRegisterPage(),
            ), //MaterialPageRoute
          );
        },
        // foregroundColor: Colors.red,
      ),
    );
  }
}

const tstyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const ststyle = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 18, fontStyle: FontStyle.italic);
