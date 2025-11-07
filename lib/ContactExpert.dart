import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactExpertPage extends StatelessWidget {
  const ContactExpertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 60, 172, 185),
        title: const Text(' Experts'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('experts').where('approved', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final experts = snapshot.data!.docs;
            return ListView.builder(
              itemCount: experts.length,
              itemBuilder: (context, index) {
                final expert = experts[index].data() as Map<String, dynamic>;
                final name = expert['name'] as String? ?? '';
                final age = expert['age'] as String? ?? '';
                final email = expert['email'] as String? ?? '';
                final phone = expert['phone'] as String? ?? '';
                final job = expert['job'] as String? ?? '';
                final experience = expert['experience'] as String? ?? '';
                final description = expert['description'] as String? ?? '';
                final profileImageUrl = expert['profileImageUrl'] as String? ?? '';

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : AssetImage('assets/default_photo.jpg') as ImageProvider,
                      radius: 40,
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age: $age'),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => launch('mailto:$email'),
                          child: Row(
                            children: [
                              Icon(Icons.email, color: Colors.redAccent),
                              SizedBox(width: 5),
                              Text(
                                email,
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => launch('tel:$phone'),
                          child: Row(
                            children: [
                              Icon(Icons.call, color: Colors.green),
                              SizedBox(width: 5),
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
                        SizedBox(height: 10),
                        Text('Job: $job'),
                        SizedBox(height: 10),
                        Text('Work Experience: $experience Years'),
                        SizedBox(height: 10),
                        Text('About: $description'),
                        SizedBox(height: 10),
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
