import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthtrackerapp/HomeScreen.dart';
import 'package:mentalhealthtrackerapp/main.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool canEdit = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController biography = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// 🔹 Load user data from Firestore
  Future<void> loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.email)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          setState(() {
            name.text = data['name'] ?? '';
            age.text = data['age'] ?? '';
            phone.text = data['phone'] ?? '';
            address.text = data['address'] ?? '';
            gender.text = data['gender'] ?? '';
            biography.text = data['biography'] ?? '';

            // update local global object
            patientInfo.name = data['name'];
            patientInfo.address = data['address'];
            patientInfo.phoneNo = data['phone'];
            patientInfo.gender = data['gender'];
            patientInfo.biography = data['biography'];
            patientInfo.profile_link = data['photoUrl'];
            patientInfo.email = user.email;
          });
        }
      }
    } catch (e) {
      print("Error loading profile data: $e");
    }
  }

  /// 🔹 Pick and upload profile image
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      String downloadUrl = await uploadProfileImage(_imageFile!);
      if (downloadUrl.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(patientInfo.email)
            .update({'photoUrl': downloadUrl});

        setState(() {
          patientInfo.profile_link = downloadUrl;
        });
      }
    }
  }

  /// 🔹 Upload profile image to Firebase Storage
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return '';

      final String filePath = 'user_profile_images/${user.uid}.jpg';
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(filePath);

      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Profile image upload error: $error');
      return '';
    }
  }

  /// 🔹 Update user data in Firestore
  Future<void> saveUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(patientInfo.email)
          .update({
        'name': name.text,
        'age': age.text,
        'gender': gender.text,
        'phone': phone.text,
        'address': address.text,
        'biography': biography.text,
      });

      // update local global object
      patientInfo.name = name.text;
      patientInfo.address = address.text;
      patientInfo.phoneNo = phone.text;
      patientInfo.gender = gender.text;
      patientInfo.biography = biography.text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully")),
      );

      await loadUserData(); // refresh
    } catch (e) {
      showSnackBar("Error saving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        title: Text('My Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 0.98 * width,
                    height: height / 7.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/abc.gif'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: height / 55,
                    child: CircleAvatar(
                      radius: height / 11,
                      backgroundColor: Colors.white,
                      child: GestureDetector(
                        onTap: () async {
                          if (canEdit) {
                            await pickImage();
                          }
                        },
                        child: CircleAvatar(
                          radius: height / 12,
                          backgroundColor: Colors.blueGrey,
                          backgroundImage: patientInfo.profile_link != null
                              ? NetworkImage(patientInfo.profile_link!)
                              : null,
                          child: patientInfo.profile_link == null
                              ? Icon(Icons.person,
                                  color: Colors.white, size: 60)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 14.5),
              Text(
                name.text.isNotEmpty ? name.text : patientInfo.name ?? "",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: canEdit
                    ? [
                        TextsField("Name", "Enter your name", name, true),
                        TextsField("Age", "Enter your age", age, true),
                        TextsField("Gender", "Enter your gender", gender, true),
                        TextsField("Phone", "Enter your phone", phone, true),
                        TextsField(
                            "Address", "Enter your address", address, true),
                        TextsField(
                            "Biography", "Enter biography", biography, true),
                      ]
                    : [
                        TextsField("Name", '', name, false),
                        TextsField("Age", '', age, false),
                        TextsField("Gender", '', gender, false),
                        TextsField("Phone", '', phone, false),
                        TextsField("Address", '', address, false),
                        TextsField("Biography", '', biography, false),
                      ],
              ),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: SizedBox(
                  height: height / 13.5,
                  width: width / 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () async {
                        if (canEdit) {
                          await saveUserData();
                        }
                        setState(() {
                          canEdit = !canEdit;
                        });
                      },
                      child: Text(
                        canEdit ? 'Save' : 'Edit Profile',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(text)),
    );
  }
}

/// 🔹 Reusable TextField widget
class TextsField extends StatelessWidget {
  final String fieldname;
  final String hint;
  final TextEditingController controller;
  final bool editingEnabled;

  const TextsField(
      this.fieldname, this.hint, this.controller, this.editingEnabled);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;

    return Container(
      padding: EdgeInsets.only(
        right: width / 14,
        left: width / 14,
        top: height / 68,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldname,
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 15,
              fontWeight: editingEnabled ? FontWeight.normal : FontWeight.bold,
              fontStyle: editingEnabled ? FontStyle.normal : FontStyle.italic,
            ),
          ),
          SizedBox(height: height / 136),
          SizedBox(
            height: height / 12.5,
            width: width / 1.12,
            child: editingEnabled
                ? TextField(
                    controller: controller,
                    cursorColor: Colors.redAccent.withOpacity(0.8),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: hint,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.redAccent.withOpacity(0.8),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.redAccent.withOpacity(0.8),
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(
                      vertical: height / 40,
                      horizontal: width / 40,
                    ),
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      controller.text,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
          ),
          SizedBox(height: height / 70),
        ],
      ),
    );
  }
}
