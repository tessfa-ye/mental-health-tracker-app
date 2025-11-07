import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class KnowledgeBase {
  List<String> facts;
  List<Map<String, dynamic>> rules;

  KnowledgeBase({required this.facts, required this.rules});

  static Future<KnowledgeBase> loadFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString);
    return KnowledgeBase(
      facts: List<String>.from(jsonData['facts']),
      rules: List<Map<String, dynamic>>.from(jsonData['rules']),
    );
  }
}
