import 'package:mentalassessment/assessment/knowledge_base.dart';

class InferenceEngine {
  KnowledgeBase knowledgeBase;

  InferenceEngine({required this.knowledgeBase});

  Map<String, dynamic> infer(List<String> givenFacts) {
    List<Map<String, dynamic>> matchedConditions = [];

    for (var rule in knowledgeBase.rules) {
      int matchCount = _evaluateRule(rule, givenFacts);
      if (matchCount >= 2) {
        matchedConditions.add({
          'conclusion': rule['conclusion'],
          'definition': rule['definition'],
          'treatment': rule['treatment'],
          'conditions': rule['conditions'],
          'matchCount': matchCount,
        });
      }
    }

    if (matchedConditions.isEmpty) {
      return {
        'conclusion': 'No matching condition',
        'definition': '',
        'treatment':
            'Please review the symptoms selected or consult a healthcare professional.',
        'conditions': [],
      };
    } else {
      matchedConditions
          .sort((a, b) => b['matchCount'].compareTo(a['matchCount']));
      return matchedConditions.first;
    }
  }

  int _evaluateRule(Map<String, dynamic> rule, List<String> givenFacts) {
    int matchCount = 0;
    for (var condition in rule['conditions']) {
      if (givenFacts.contains(condition)) {
        matchCount++;
      }
    }
    return matchCount;
  }
}
