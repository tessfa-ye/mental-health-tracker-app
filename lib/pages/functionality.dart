import 'package:flutter/material.dart';

import '../ContactExpert.dart';
import '../assessment/UI/assessment_status_page.dart';
import '../assessment/UI/expert_system.dart';
import 'suggestionPage.dart';

class Functionality extends StatefulWidget {
  const Functionality({super.key});

  @override
  State<Functionality> createState() => _functionalityState();
}

// ignore: camel_case_types
class _functionalityState extends State<Functionality> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mental Health',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Mental health is a state of mental well-being that enables people to cope with the stresses of life, realize their abilities, learn well and work well, and contribute to their community. It is an integral component of health and well-being that underpins our individual and collective abilities to make decisions, build relationships and shape the world we live in. Mental health is a basic human right. And it is crucial to personal, community and socio-economic development.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  GridItem(
                    title: 'Self Assessment',
                    icon: Icons.assessment,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExpertSystemApp()),
                      );
                    },
                  ),
                  GridItem(
                    title: 'Contact Experts',
                    icon: Icons.contact_phone,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ContactExpertPage()),
                      );
                    },
                  ),
                  GridItem(
                    title: 'View Status',
                    icon: Icons.visibility,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  AssessmentStatusPage()),
                      );
                    },
                  ),
                  GridItem(
                    title: 'Get Suggestions',
                    icon: Icons.lightbulb,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  GetSuggestionsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const GridItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
