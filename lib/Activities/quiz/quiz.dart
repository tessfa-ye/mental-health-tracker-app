import 'package:flutter/material.dart';
import 'package:mentalhealthtrackerapp/Activities/quiz/questions_screen.dart';
import 'package:mentalhealthtrackerapp/Activities/quiz/results_screen.dart';
import 'package:mentalhealthtrackerapp/Activities/quiz/start_screen.dart';

import 'data/questions.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  List<String> selectedAnswers = [];
  var activeScreen = 'start-screen';

  void switchScreen() {
    setState(() {
      activeScreen = 'questions-screen';
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);

    if (selectedAnswers.length == questions.length) {
      setState(() {
        activeScreen = 'results-screen';
      });
    }
  }

  void restartQuiz() {
    setState(() {
      selectedAnswers = [];
      activeScreen = 'questions-screen';
    });
  }

  @override
  Widget build(context) {
    Widget screenWidget = StartScreen(switchScreen);

    if (activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
        onSelectAnswer: chooseAnswer,
      );
    }

    if (activeScreen == 'results-screen') {
      screenWidget = ResultsScreen(
        chosenAnswers: selectedAnswers,
        onRestart: restartQuiz,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        title: Text(" Quizes"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 103, 62, 159),
              Color.fromARGB(255, 62, 165, 144),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: screenWidget,
      ),
    );
  }
}
