import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentalhealthtrackerapp/HomeScreen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'main.dart';

class QuizPage extends StatefulWidget {
  QuizPage(this.question, this.x, this.disorder, this.colors, {super.key});
  List<String> question;
  final String disorder;
  final int x;
  final List<Color> colors;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        title: const Text('Quiz Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to previous screen
          },
        ),
      ),
      drawer: const Menu(),
      backgroundColor: Colors.white,
      body: Question(widget.question, widget.x, widget.disorder, widget.colors),
    );
  }
}

class Question extends StatefulWidget {
  const Question(this.question, this.qno, this.disorder, this.colors,
      {super.key});
  final List<String> question;
  final int qno;
  final String disorder;
  final List<Color> colors;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  int i = 0;
  bool over = false;
  int totalScore = 0;
  List<int> answers =
      List.filled(11, -1); // Initialize with -1 indicating no answer

  Future sendEmail(
      String name1, String name2, String message, String email) async {
    final url = Uri.parse(
        'https://https://dashboard.emailjs.com/admin/account/v1.0/email/send');
    const serviceId = 'service_05hcfjg';
    const templateId = 'template_mak408l';
    const userId = 'C7ns8WoNqX9Ns9GvG';
    try {
      final response = await http.post(url,
          headers: {
            'origin': 'http:localhost',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'from_name': name1,
              'to_name': name2,
              'message': message,
              'to_email': email,
            }
          }));
      return response.statusCode;
    } catch (e) {
      print("feedback email response");
    }
  }

  void nextQuestion(int score) {
    setState(() {
      totalScore += score;
      answers[i] = score;
      i++;
      if (i >= widget.qno) {
        over = true;
        String risk = calculateRisk();
        sendEmail(
          patientInfo.name!,
          patientInfo.gender!,
          'Your patient has taken a ${widget.disorder} test. He/she has ${risk} risk of suffering through the disorder. Kindly share your advice on ${patientInfo.email} or contact him personally',
          patientInfo.biography!,
        );
      }
    });
  }

  String calculateRisk() {
    double averageScore = totalScore / widget.qno;
    if (averageScore >= 3.5) {
      return "High";
    } else if (averageScore >= 2.0) {
      return "Moderate";
    } else {
      return "Low";
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: height / 4.5,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.colors),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Text(
                  over == false ? 'Questions' : 'Results',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            Positioned(
              top: height / 10,
              child: Container(
                height: height * 0.35,
                width: width / 1.2,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueGrey, width: 2),
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        over == false
                            ? 'Question no - ${i + 1}'
                            : '------ Conclusion ------',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height / 80),
                      Text(
                        over == false
                            ? widget.question[i]
                            : calculateRisk() == "High"
                                ? "You are at high risk of suffering from ${widget.disorder}"
                                : calculateRisk() == "Moderate"
                                    ? "You have a moderate risk of suffering from ${widget.disorder}"
                                    : "You have a low risk of suffering from ${widget.disorder}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      over == true
                          ? CircularPercentIndicator(
                              radius: 80.0,
                              lineWidth: 13.0,
                              animation: true,
                              animationDuration: 600,
                              percent: calculateRisk() == "High"
                                  ? 0.9
                                  : calculateRisk() == "Moderate"
                                      ? 0.6
                                      : 0.3,
                              center: Text(
                                calculateRisk() == "High"
                                    ? "High Risk"
                                    : calculateRisk() == "Moderate"
                                        ? "Moderate Risk"
                                        : "Low Risk",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: calculateRisk() == "High"
                                  ? Colors.red
                                  : calculateRisk() == "Moderate"
                                      ? Colors.orange
                                      : Colors.green,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.23 * height),
        over == false
            ? Column(
                children: [
                  RadioListTile(
                    title: const Text("Not at all"),
                    value: 0,
                    groupValue: answers[i] == -1 ? null : answers[i],
                    onChanged: (value) {
                      nextQuestion(0);
                    },
                    activeColor: Colors.blue,
                  ),
                  RadioListTile(
                    title: const Text("A little bit"),
                    value: 1,
                    groupValue: answers[i] == -1 ? null : answers[i],
                    onChanged: (value) {
                      nextQuestion(1);
                    },
                    activeColor: Colors.blue,
                  ),
                  RadioListTile(
                    title: const Text("Moderately"),
                    value: 2,
                    groupValue: answers[i] == -1 ? null : answers[i],
                    onChanged: (value) {
                      nextQuestion(2);
                    },
                    activeColor: Colors.blue,
                  ),
                  RadioListTile(
                    title: const Text("Quite a bit"),
                    value: 3,
                    groupValue: answers[i] == -1 ? null : answers[i],
                    onChanged: (value) {
                      nextQuestion(3);
                    },
                    activeColor: Colors.blue,
                  ),
                  RadioListTile(
                    title: const Text("Extremely"),
                    value: 4,
                    groupValue: answers[i] == -1 ? null : answers[i],
                    onChanged: (value) {
                      nextQuestion(4);
                    },
                    activeColor: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: i < widget.qno - 1
                        ? null
                        : () {
                            setState(() {
                              over = true;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          i < widget.qno - 1 ? Colors.grey : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Finish',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            : const SizedBox(
                height: 40,
              ),
        over == true
            ? totalScore >= 4 * widget.qno
                ? const Text(
                    'Please focus on yourself and give yourself some time to meditate and relax.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                : totalScore >= 2 * widget.qno
                    ? const Text(
                        'Keep meditating regularly and eat healthy.\nYou are just a few days away from perfect mental health.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        'Your health seems good enough.\nKeep it up!!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
            : const SizedBox(),
      ],
    );
  }
}
