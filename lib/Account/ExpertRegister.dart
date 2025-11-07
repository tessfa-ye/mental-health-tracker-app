import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _workExperienceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedJob;
  FilePickerResult? _cvFile;
  File? _profileImage;
  bool _isUploading = false;
  String? _cvFileName;

  Future<void> _pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerExpert() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      try {
        CollectionReference experts = FirebaseFirestore.instance.collection('experts');

        String? cvDownloadUrl;
        if (_cvFile != null && _cvFile!.files.isNotEmpty) {
          final File cvFile = File(_cvFile!.files.first.path!);
          cvDownloadUrl = await uploadCV(cvFile);
        }

        String? profileImageUrl;
        if (_profileImage != null) {
          profileImageUrl = await uploadProfileImage(_profileImage!);
        }

        await experts.add({
          'name': _nameController.text,
          'age': _ageController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'job': _selectedJob,
          'experience': _workExperienceController.text,
          'description': _descriptionController.text,
          'cvDownloadUrl': cvDownloadUrl,
          'profileImageUrl': profileImageUrl,
        }).then((value) {
          print("Expert Added: ${value.id}");
        }).catchError((error) {
          print("Failed to add expert: $error");
        });

        setState(() {
          _isUploading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThankYouPage(profileImageUrl: profileImageUrl)),
        );
      } catch (e) {
        print("Exception: $e");
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }

  Future<String> uploadCV(File cvFile) async {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          '.' +
          _cvFile!.files.first.extension!;
      final String storagePath = 'cv_uploads/$fileName';
      final Reference storageReference = FirebaseStorage.instance.ref().child(storagePath);

      final UploadTask uploadTask = storageReference.putFile(cvFile);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('CV upload error: $error');
      return '';
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          '.' +
          imageFile.path.split('.').last;
      final String storagePath = 'profile_images/$fileName';
      final Reference storageReference = FirebaseStorage.instance.ref().child(storagePath);

      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Profile image upload error: $error');
      return '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _workExperienceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experts Registration'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 60, 172, 185),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    } else if (int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedJob,
                  items: const [
                    DropdownMenuItem(
                      value: 'Psychologists',
                      child: Text('Psychologists'),
                    ),
                    DropdownMenuItem(
                      value: 'Psychiatrists',
                      child: Text('Psychiatrists'),
                    ),
                    DropdownMenuItem(
                      value: 'Mental Health Nurses',
                      child: Text('Mental Health Nurses'),
                    ),
                    DropdownMenuItem(
                      value: 'Social Workers',
                      child: Text('Social Workers'),
                    ),
                    DropdownMenuItem(
                      value: 'Peer Workers',
                      child: Text('Peer Workers'),
                    ),
                    DropdownMenuItem(
                      value: 'Occupational Therapists',
                      child: Text('Occupational Therapists'),
                    ),
                    DropdownMenuItem(
                      value: 'Mental Health Recovery',
                      child: Text('Mental Health Recovery'),
                    ),
                    DropdownMenuItem(
                      value: 'Rehabilitation Workers',
                      child: Text('Rehabilitation Workers'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedJob = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Job'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a job';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _workExperienceController,
                  decoration: const InputDecoration(labelText: 'Work Experience'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your work experience';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _pickProfileImage,
                  child: Text('Upload Profile Image'),
                ),
                SizedBox(height: 8.0),
                if (_profileImage != null)
                  Image.file(_profileImage!, height: 100, width: 100),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_isUploading) {
                      return;
                    }
                    final pickedFile = await FilePicker.platform.pickFiles();
                    setState(() {
                      _cvFile = pickedFile;
                      _cvFileName = pickedFile?.files.first.name;
                    });
                  },
                  child: const Text('Upload CV'),
                ),
                SizedBox(height: 16.0),
                if (_cvFileName != null) Text('Selected CV: $_cvFileName'),
                const SizedBox(height: 16.0),
                _isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _registerExpert,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThankYouPage extends StatelessWidget {
  final String? profileImageUrl;

  ThankYouPage({this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thank You'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Registration Successful!'),
            if (profileImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                // child: Image.network(profileImageUrl!),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                exit(0);
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
