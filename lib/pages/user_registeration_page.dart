// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/services.dart';

// class UserRegisterPage extends StatefulWidget {
//   const UserRegisterPage({Key? key}) : super(key: key);

//   @override
//   _UserRegisterPageState createState() => _UserRegisterPageState();
// }

// class _UserRegisterPageState extends State<UserRegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _biographyController = TextEditingController();
//   String? _selectedSex;
//   File? _profileImage;
//   bool _isUploading = false;

//   Future<void> _pickProfileImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _registerExpert() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isUploading = true;
//       });

//       try {
//         CollectionReference users = FirebaseFirestore.instance.collection('users');

//         String? profileImageUrl;
//         if (_profileImage != null) {
//           profileImageUrl = await uploadProfileImage(_profileImage!);
//         }

//         await users.add({
//           'name': _nameController.text,
//           'age': _ageController.text,
//           'email': _emailController.text,
//           'phone': _phoneController.text,
//           'sex': _selectedSex,
//           'country': _countryController.text,
//           'biography': _biographyController.text,
//           'profileImageUrl': profileImageUrl,
//         }).then((value) {
//           print("Expert Added: ${value.id}");
//         }).catchError((error) {
//           print("Failed to add expert: $error");
//         });

//         setState(() {
//           _isUploading = false;
//         });

//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ThankYouPage(profileImageUrl: profileImageUrl)),
//         );
//       } catch (e) {
//         print("Exception: $e");
//         setState(() {
//           _isUploading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Registration failed. Please try again.')),
//         );
//       }
//     }
//   }

//   Future<String> uploadProfileImage(File imageFile) async {
//     try {
//       final String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
//           '.' +
//           imageFile.path.split('.').last;
//       final String storagePath = 'profile_imagesofuser/$fileName';
//       final Reference storageReference = FirebaseStorage.instance.ref().child(storagePath);

//       final UploadTask uploadTask = storageReference.putFile(imageFile);
//       final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//       final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//       return downloadUrl;
//     } catch (error) {
//       print('Profile image upload error: $error');
//       return '';
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _ageController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _countryController.dispose();
//     _biographyController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Fill About Your Slef'),
//         centerTitle: true,
//         backgroundColor: Color.fromARGB(255, 28, 173, 218).withOpacity(0.8),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(labelText: 'Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
//                       return 'Please enter a valid name';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _ageController,
//                   decoration: const InputDecoration(labelText: 'Age'),
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your age';
//                     } else if (int.tryParse(value) == null) {
//                       return 'Please enter a valid age';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(labelText: 'Email'),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _phoneController,
//                   decoration: const InputDecoration(labelText: 'Phone'),
//                   keyboardType: TextInputType.phone,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your phone number';
//                     } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                       return 'Please enter a valid phone number';
//                     }
//                     return null;
//                   },
//                 ),
//                 DropdownButtonFormField<String>(
//                   value: _selectedSex,
//                   items: const [
//                     DropdownMenuItem(
//                       value: 'Male',
//                       child: Text('Male'),
//                     ),
//                     DropdownMenuItem(
//                       value: 'Female',
//                       child: Text('Female'),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedSex = value;
//                     });
//                   },
//                   decoration: const InputDecoration(labelText: 'Sex'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select a sex';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _countryController,
//                   decoration: const InputDecoration(labelText: 'Country'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your country';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _biographyController,
//                   decoration: const InputDecoration(labelText: 'Biography'),
//                   maxLines: 4,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a biography';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: _pickProfileImage,
//                   child: Text('Upload Profile Image'),
//                 ),
//                 SizedBox(height: 8.0),
//                 if (_profileImage != null)
//                   Image.file(_profileImage!, height: 100, width: 100),
//                 const SizedBox(height: 16.0),
//                 _isUploading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                   onPressed: _registerExpert,
//                   child: const Text('Submit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ThankYouPage extends StatelessWidget {
//   final String? profileImageUrl;

//   ThankYouPage({this.profileImageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(' '),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('You Fill Additional Information About Your Self. Thank You!'),
//             if (profileImageUrl != null)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.network(profileImageUrl!),
//               ),
//             ElevatedButton(
//               onPressed: () {
//                 // Exit the app
//                 SystemNavigator.pop();
//               },
//               child: const Text('Finished'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
