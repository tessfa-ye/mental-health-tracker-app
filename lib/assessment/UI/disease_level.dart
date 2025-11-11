import 'package:flutter/material.dart';

class DiseaseLevel extends StatelessWidget {
  String diseaseType;
  DiseaseLevel({super.key, required this.diseaseType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        title: const Text('Disease Level'),
      ),
      body: Center(
        child: Text(
          'Disease level:  $diseaseType',
          style: const TextStyle(
              fontSize: 30.0, fontWeight: FontWeight.w900, color: Colors.amber),
        ),
      ),
    );
  }
}
