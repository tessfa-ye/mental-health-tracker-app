// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalhealthtrackerapp/Account/login_page.dart';

import '../pages/hero_page.dart';
import '../pages/wellcomescreen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.onTap});
  final Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = "", password = "", username = "";

  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passToggle = true;

  // Function to sign up user
  Future<void> signUserUp() async {
    try {
      // Show a loading indicator
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );

      // Store additional user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': namecontroller.text,
        'email': emailcontroller.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Successfully registered!')));

      // Close loading indicator
      Navigator.pop(context);

      // Navigate to home page or wherever you want to go after registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Close loading indicator
      Navigator.pop(context);
      // Handle FirebaseAuthException
      if (e.code == 'invalid-email') {
        _showErrorDialog('Invalid email. Please try again.');
      } else if (e.code == 'weak-password') {
        _showErrorDialog('Password is too weak. Please try again.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorDialog('Email already registered. Please login.');
      }
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.7,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color(0xFFff5c30),
                    Color.fromARGB(112, 50, 165, 203),
                  ])),
              child: const HeroPage(),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.7),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                // logo
                margin: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 300.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.3,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 235, 235),
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15.0,
                              ),
                              const Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),

                              TextFormField(
                                controller: namecontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Your Name";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: "Name",
                                  prefixIcon: Icon(Icons.person_outlined),
                                ),
                              ),

                              const SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: emailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Your E-mail";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType
                                    .emailAddress, // Specify keyboard type for email
                                decoration: const InputDecoration(
                                  hintText: "Email",
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),

                              const SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: passwordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Your Password";
                                  }
                                  return null;
                                },
                                obscureText: passToggle,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon:
                                      const Icon(Icons.lock_open_outlined),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passToggle = !passToggle;
                                      });
                                    },
                                    child: Icon(
                                      passToggle
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 35),
                              // sign up button
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      email = emailcontroller.text;
                                      password = passwordcontroller.text;
                                      username = namecontroller.text;
                                    });
                                  }
                                  signUserUp();
                                },
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffff5722),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                        child: Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
