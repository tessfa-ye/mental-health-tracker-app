import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mentalhealthtrackerapp/assessment/inference_engine.dart';
import 'package:mentalhealthtrackerapp/assessment/knowledge_base.dart';
import 'package:mentalhealthtrackerapp/assessment/UI/result_page.dart';
import 'assessment_status_page.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ExpertSystemApp());
}

class ExpertSystemApp extends StatefulWidget {
  const ExpertSystemApp({Key? key}) : super(key: key);

  @override
  _ExpertSystemAppState createState() => _ExpertSystemAppState();
}

class _ExpertSystemAppState extends State<ExpertSystemApp> {
  late KnowledgeBase knowledgeBase;
  late InferenceEngine inferenceEngine;
  Map<String, dynamic> conclusion = {};
  Map<String, bool?> selectedFacts = {};
  List<String> filteredFacts = [];
  List<String> selectedFactList = [];
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadKnowledgeBase();
    searchController.addListener(_filterFacts);
  }

  void _loadKnowledgeBase() async {
    try {
      // Load knowledge base from assets
      knowledgeBase =
          await KnowledgeBase.loadFromAssets('assets/knowledge_base.json');

      // Initialize inference engine with loaded knowledge base
      inferenceEngine = InferenceEngine(knowledgeBase: knowledgeBase);

      // Update UI with loaded facts
      setState(() {
        filteredFacts = knowledgeBase.facts;
      });
    } catch (e) {
      // Handle any errors that occur during knowledge base loading
      print('Error loading knowledge base: $e');

      // Optionally, show a message or handle the error in UI
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content:
              Text('Failed to load knowledge base. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _runInference(BuildContext context) {
    if (selectedFactList.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please select at least five facts before submitting.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Timer(Duration(seconds: 5), () {
      List<String> factsToInfer = selectedFactList;
      Map<String, dynamic> conclusion = inferenceEngine.infer(factsToInfer);

      // Save assessment data to Firebase
      _saveAssessmentData(conclusion);

      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage(conclusion: conclusion)),
      );
    });
  }

  void _saveAssessmentData(Map<String, dynamic> conclusion) {
    final assessment = {
      'date': DateTime.now(),
      'conclusion': conclusion,
    };

    FirebaseFirestore.instance.collection('assessments').add(assessment);
  }

  void _filterFacts() {
    setState(() {
      String query = searchController.text.toLowerCase();
      filteredFacts = knowledgeBase.facts
          .where((fact) =>
              fact.toLowerCase().contains(query) &&
              !selectedFactList.contains(fact))
          .toList();
    });
  }

  void _selectFact(String fact) {
    setState(() {
      if (!selectedFactList.contains(fact)) {
        selectedFactList.add(fact);
        filteredFacts.remove(fact);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  void _removeSelectedFact(String fact) {
    setState(() {
      selectedFactList.remove(fact);
      _filterFacts(); // Re-filter facts to include the removed fact
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
          foregroundColor: Colors.black87,
          elevation: 1,
          title: const Text('Check Your Mentality',
              style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AssessmentStatusPage()),
                );
              },
            ),
          ],
        ),
        body: knowledgeBase == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (selectedFactList.length < 5)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Please select at least five symptoms before submitting.',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.grey[200],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (selectedFactList.isNotEmpty)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            child: Row(
                              children: selectedFactList.map((fact) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.blueAccent.withOpacity(0.3),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(fact.replaceAll('_', ' ')),
                                          IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              _removeSelectedFact(fact);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const LinearProgressIndicator(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  if (!isLoading)
                    Expanded(
                      child: ListView(
                        children: filteredFacts.map((fact) {
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text(fact.replaceAll('_', ' ')),
                              onTap: () {
                                _selectFact(fact);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: selectedFactList.length >= 5 && !isLoading
                        ? () => _runInference(context)
                        : null,
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          selectedFactList.length >= 5 && !isLoading
                              ? Colors.white
                              : Colors.grey,
                      backgroundColor:
                          selectedFactList.length >= 5 && !isLoading
                              ? Colors.blue
                              : Colors.grey,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
