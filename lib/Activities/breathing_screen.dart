import 'package:flutter/material.dart';
import 'package:mentalhealthtrackerapp/components/lottie_widget.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  bool isStarted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        title: const Text(' Breathing'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30.0,
          ),
          isStarted
              ? const LottieWidget(path: 'assets/animations/breathing.json')
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isStarted = true;
                      });
                    },
                    child: const Text('Start'),
                  ),
                ),
          isStarted
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isStarted = false;
                    });
                  },
                  child: const Text('Stop'))
              : const SizedBox(),
        ],
      ),
    );
  }
}
