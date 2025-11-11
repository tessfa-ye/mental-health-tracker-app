import 'package:flutter/material.dart';
import 'package:mentalhealthtrackerapp/expert_approve.dart';
import 'package:mentalhealthtrackerapp/pages/users_page.dart'; // Import the UsersPage

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        title: const Text('Admin Page'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildContainer(context, 'Users', const UsersPage(), Colors.blue),
          _buildContainer(context, 'Experts', ExpertApprove(), Colors.green),
        ],
      ),
    );
  }

  Widget _buildContainer(
      BuildContext context, String title, Widget page, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(24.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
