import 'package:flutter/material.dart';
import 'package:mentalhealthtrackerapp/HomeScreen.dart';
import 'package:mentalhealthtrackerapp/components/custom_list_tile.dart';
import 'package:mentalhealthtrackerapp/Activities/breathing_screen.dart';
import 'package:mentalhealthtrackerapp/Activities/meditation_screen.dart';
import 'package:mentalhealthtrackerapp/Activities/quiz/quiz.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Some Activities '),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
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
