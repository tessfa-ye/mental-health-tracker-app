import 'package:flutter/material.dart';
import 'package:mentalhealthtrackerapp/Assessment.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> conclusion;

  ResultPage({required this.conclusion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Your Mental Health Result',
          style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w900),
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(18),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          children: conclusion.isNotEmpty
              ? [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Center(
                          child: Text(
                            conclusion['conclusion']?.replaceAll('_', ' ') ??
                                'Condition not found',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.amber,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          conclusion['definition'] ??
                              'Definition not available',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w400),
                        ),
                      ),
                      if (conclusion['conditions'] != null)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Symptoms:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    List<String>.from(conclusion['conditions'])
                                        .map((condition) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      condition.replaceAll('_', ' '),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ListTile(
                        title: Text(
                          'Treatment',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          conclusion['treatment'] ?? 'Treatment not available',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Assessment(
                                selectedDisease: conclusion['conclusion'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 40.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Check your Level',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
              : [
                  Center(
                    child: Text(
                      'Condition not found',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
