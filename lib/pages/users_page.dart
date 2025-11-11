import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!.docs;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Sex')),
                  DataColumn(label: Text('Age')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Country')),
                ],
                rows: users.map((userDoc) {
                  final user = userDoc.data() as Map<String, dynamic>;
                  final name = user['name'] as String? ?? '';
                  final sex = user['sex'] as String? ?? '';
                  final age = user['age'] as String? ?? '';
                  final phoneNumber = user['phone'] as String? ?? '';
                  final country = user['country'] as String? ?? '';

                  return DataRow(cells: [
                    DataCell(Text(name)),
                    DataCell(Text(sex)),
                    DataCell(Text(age)),
                    DataCell(Text(phoneNumber)),
                    DataCell(Text(country)),
                  ]);
                }).toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load users'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
