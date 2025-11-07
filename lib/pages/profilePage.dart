import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalassessment/main.dart'; // Correct import for patientInfo and Homescreen

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color myColor = Colors.red;
  bool canEdit = false;
  TextEditingController age = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController biography = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          '.' +
          imageFile.path.split('.').last;
      final String storagePath = 'user_profile_images/$fileName';
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(storagePath);

      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Profile image upload error: $error');
      return '';
    }
  }

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
            .update({'profile_link': downloadUrl});

        setState(() {
          patientInfo.profile_link = downloadUrl;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    address.text = patientInfo.address!;
    gender.text = patientInfo.gender!;
    biography.text = patientInfo.biography!;
    phone.text = patientInfo.phoneNo!;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    return Scaffold(
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
                    height: height / 5.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/abc.gif'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: height / 15,
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
                          child: patientInfo.profile_link == null
                              ? Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 60,
                                )
                              : null,
                          backgroundImage: patientInfo.profile_link != null
                              ? NetworkImage(patientInfo.profile_link!)
                              : null,
                          backgroundColor: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 14.5),
              Container(
                child: Text(
                  patientInfo.name!,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: canEdit
                    ? [
                        TextsField("Age", "Enter your Age", age, true),
                        TextsField("Gender", "Enter your gender", gender, true),
                        TextsField(
                            "Your Phone", "Enter your Phone", phone, true),
                        TextsField(
                            "Biography", "Enter biography", biography, true),
                      ]
                    : [
                        TextsField("age", '', age, false),
                        TextsField("email", '', gender, false),
                        TextsField(" Phone", "", phone, false),
                        TextsField("address", "", address, false),
                        TextsField("Specialist Name", '', biography, false),
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
                        setState(() {
                          canEdit = !canEdit;
                        });
                        if (canEdit == false) {
                          if (age.text.isEmpty) {
                            showSnackBar('Please Enter your age');
                          } else if (phone.text.isEmpty) {
                            showSnackBar("Please Enter your phone");
                          } else {
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(patientInfo.email)
                                .update({
                              'age': age.text,
                              'gender': gender.text,
                              'phone': phone.text,
                              'address': address.text,
                              'biography': biography.text,
                            });
                            patientInfo.address = address.text;
                            patientInfo.phoneNo = phone.text;
                            patientInfo.gender = gender.text;
                            patientInfo.biography = biography.text;
                          }
                        }
                      },
                      child: Text(
                        canEdit != true ? 'Edit Profile' : 'Save',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(text),
    ));
  }
}

class TextsField extends StatelessWidget {
  TextsField(this.fieldname, this.hint, this.controller, this.editingEnabled);
  final String fieldname;
  final String hint;
  final TextEditingController controller;
  final bool editingEnabled;

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
            style: editingEnabled
                ? TextStyle(color: Colors.grey[900], fontSize: 15)
                : TextStyle(
                    color: Colors.grey[900],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
          ),
          SizedBox(height: height / 136),
          SizedBox(
            height: height / 12.5,
            width: width / 1.12,
            child: editingEnabled
                ? TextField(
                    readOnly: !editingEnabled,
                    controller: controller,
                    onChanged: (value) {},
                    cursorColor: Colors.redAccent.withOpacity(0.8),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: hint,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.redAccent.withOpacity(0.8),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
