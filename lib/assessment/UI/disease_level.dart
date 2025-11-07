import 'package:flutter/material.dart';

class DiseaseLevel extends StatelessWidget {
  String diseaseType;
  DiseaseLevel({super.key, required this.diseaseType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 138, 171),
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
