import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:image_picker/image_picker.dart';
import '../../widgets/snackbar.dart';
import '../contractor_botton_nav.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({Key? key}) : super(key: key);

  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Painting';
  TextEditingController _projectNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _budgetController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File? _image;
  bool isloading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path); // Assign the picked image as a File object
      });
    }
  }

  Future<String> _uploadImage() async {
    if (_image == null) return ""; // Return empty string if no image selected

    // Create a reference to the Firebase Storage path where you want to upload the image
    Reference storageReference = FirebaseStorage.instance.ref().child("images/${DateTime.now().millisecondsSinceEpoch}");

    // Upload the image to Firebase Storage
    UploadTask uploadTask = storageReference.putFile(_image!);

    // Wait for the upload to complete and return the download URL
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Dropdown for category selection
                _buildDropdown('Category', _selectedCategory, _categories,
                        (value) {
                      setState(() {
                        _selectedCategory = value.toString();
                      });
                    }),
                // TextFields for project name, location, budget, and description
                _buildTextField('Project Name', _projectNameController),
                _buildTextField('Location', _locationController),
                _buildTextField('Budget', _budgetController),
                _buildTextField('Description', _descriptionController),
                if (_descriptionController.text.isNotEmpty) // Show upload image button if description is not empty
                  SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload Image'),
                ),
                // Submit button
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isloading = true;
                      });

                      String imageUrl = await _uploadImage(); // Upload image and get download URL

                      String id = FirebaseFirestore.instance
                          .collection('jobs')
                          .doc()
                          .id;
                      await FirebaseFirestore.instance
                          .collection('jobs')
                          .doc(id)
                          .set({
                        "name": _projectNameController.text,
                        "budget": _budgetController.text,
                        "duration": _locationController.text,
                        "des": _descriptionController.text,
                        "date": DateTime.now(),
                        "uid": FirebaseAuth.instance.currentUser!.uid,
                        "imageUrl": imageUrl, // Add imageUrl to Firestore
                        "isFavorite": false, // Add isFavorite field with initial value false
                      });

                      showCustomSnackBar(Icons.check_circle, "Job Upload",
                          "Job successfully uploaded.", Colors.green);

                      setState(() {
                        isloading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2544),
                  ),
                  child: const Text('Post Job',
                      style: TextStyle(color: Colors.white)),
                ),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ContractorBottomNavigationBar(),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        icon: const Icon(Icons.category),
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        icon: _getIcon(label),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Icon _getIcon(String label) {
    switch (label) {
      case 'Project Name':
        return const Icon(Icons.article);
      case 'Location':
        return const Icon(Icons.location_on);
      case 'Budget':
        return const Icon(Icons.attach_money);
      case 'Description':
        return const Icon(Icons.description);
      default:
        return const Icon(Icons.error);
    }
  }

  static const List<String> _categories = [
    'Painting',
    'Carpentry',
    'Plumbing',
    'Electrical',
    'Roofing',
    'Flooring',
    'Renovation',
    'Landscaping',
  ];
}
