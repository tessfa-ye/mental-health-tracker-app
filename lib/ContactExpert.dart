import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactExpertPage extends StatelessWidget {
  const ContactExpertPage({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        title: const Text('Experts'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('experts')
            .where('approved', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final experts = snapshot.data!.docs;
            if (experts.isEmpty) {
              return const Center(child: Text('No approved experts found.'));
            }

            return ListView.builder(
              itemCount: experts.length,
              itemBuilder: (context, index) {
                final expert = experts[index].data() as Map<String, dynamic>;
                final name = expert['name'] ?? '';
                final age = expert['age'] ?? '';
                final email = expert['email'] ?? '';
                final phone = expert['phone'] ?? '';
                final job = expert['job'] ?? '';
                final experience = expert['experience'] ?? '';
                final description = expert['description'] ?? '';
                final profileImageUrl = expert['profileImageUrl'] ?? '';

                return Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : const AssetImage('assets/default_photo.jpg')
                              as ImageProvider,
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age: $age'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _launchUrl('mailto:$email'),
                          child: Row(
                            children: [
                              const Icon(Icons.email, color: Colors.redAccent),
                              const SizedBox(width: 5),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _launchUrl('tel:$phone'),
                          child: Row(
                            children: [
                              const Icon(Icons.call, color: Colors.green),
                              const SizedBox(width: 5),
                              Text(
                                phone,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Job: $job'),
                        const SizedBox(height: 8),
                        Text('Experience: $experience years'),
                        const SizedBox(height: 8),
                        Text('About: $description'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load experts'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
