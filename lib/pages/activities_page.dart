import 'package:flutter/material.dart';
import 'package:mentalassessment/HomeScreen.dart';
import 'package:mentalassessment/components/custom_list_tile.dart';
import 'package:mentalassessment/Activities/breathing_screen.dart';
import 'package:mentalassessment/Activities/meditation_screen.dart';
import 'package:mentalassessment/Activities/quiz/quiz.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Some Activities '),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 60, 172, 185),
      ),
      drawer: const Menu(),
      body: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        children: const [
          CustomListTile(
            path: 'assets/animations/meditation-timer.json',
            title: 'Meditation',
            subtitle: 'Finding Peace Within deep way',
            screen: MeditationScreen(),
          ),
          CustomListTile(
            path: 'assets/animations/breathing-icon.json',
            title: 'Breathing',
            subtitle: 'Breath carefully to check your breathing system',
            screen: BreathingScreen(),
          ),
          CustomListTile(
              path: 'assets/animations/quiz.json',
              title: 'Questions for self refreshment',
              subtitle: '',
              screen: Quiz())
        ],
      ),
    );
  }
}
