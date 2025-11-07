import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactExpertPage extends StatefulWidget {
  @override
  _ContactExpertPageState createState() => _ContactExpertPageState();
}

class _ContactExpertPageState extends State<ContactExpertPage> {
  Future<void> _sendMessage(String expertId, String message) async {
    try {
      await Firebase.initializeApp();
      CollectionReference experts =
      FirebaseFirestore.instance.collection('experts');
      DocumentReference expertRef = experts.doc(expertId);
      CollectionReference messages = expertRef.collection('messages');
      await messages.add({'message': message});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Object? expertId = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 60, 172, 185),
        title: const Text('Contact Expert')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('experts')
                  .doc(expertId as String?)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final expert = snapshot.data!.data();
                  final name = expert!['name'];
                  final job = expert['job'];

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expert Name: $name',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Expert Job: $job',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load expert details'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Message'),
                    maxLines: 3,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    const message = ''; // Get the entered message
                    _sendMessage(expertId!, message);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}