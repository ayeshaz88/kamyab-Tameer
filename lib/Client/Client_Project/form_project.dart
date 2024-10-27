import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/snackbar.dart';
import '../client_bottom_nav.dart';

class ProjectFormScreen extends StatefulWidget {
  final String category;

  ProjectFormScreen({
    Key? key,
    required this.category,
    required bool isFavorite,
  }) : super(key: key);

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController budget = TextEditingController();
  TextEditingController des = TextEditingController();
  File? _image;
  bool isloading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    if (_image == null) return "";

    Reference storageReference =
    FirebaseStorage.instance.ref().child("images/${DateTime.now().millisecondsSinceEpoch}");

    UploadTask uploadTask = storageReference.putFile(_image!);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Project',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: ContinuousRectangleBorder(
          borderRadius:
          BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: widget.category,
                  prefixIcon:
                  Icon(Icons.category, color: Color(0xFF1F2544)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  prefixIcon:
                  Icon(Icons.title, color: Color(0xFF1F2544)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: location,
                decoration: InputDecoration(
                  labelText: 'Location',
                  prefixIcon:
                  Icon(Icons.location_on, color: Color(0xFF1F2544)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: budget,
                decoration: InputDecoration(
                  labelText: 'Budget',
                  prefixIcon:
                  Icon(Icons.attach_money, color: Color(0xFF1F2544)),
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upload your image",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 100,
                      height: 25,
                      child: ElevatedButton(
                        child: Text("Upload"),
                        onPressed: _pickImage,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: des,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(height: 24),
              isloading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : ElevatedButton(
                onPressed: () async {
                  if (name.text.isEmpty ||
                      location.text.isEmpty ||
                      budget.text.isEmpty ||
                      _image == null ||
                      des.text.isEmpty) {
                    showCustomSnackBar(
                        Icons.error_outline,
                        "Form Error",
                        "Please fill all fields",
                        Colors.red);
                  } else {
                    setState(() {
                      isloading = true;
                    });

                    String imageUrl = await _uploadImage();

                    String id = FirebaseFirestore.instance
                        .collection('projects')
                        .doc()
                        .id;

                    await FirebaseFirestore.instance
                        .collection('projects')
                        .doc(id)
                        .set({
                      "name": name.text,
                      "category": widget.category,
                      "location": location.text,
                      "budget": budget.text,
                      "des": des.text,
                      'imageUrl': imageUrl,
                      "date": DateTime.now(),
                      "uid": FirebaseAuth.instance.currentUser!.uid,
                      "isFavorite": false, // Add isFavorite field
                    });

                    showCustomSnackBar(
                        Icons.check_circle,
                        "Project Upload",
                        "Project successfully uploaded.",
                        Colors.green);

                    setState(() {
                      isloading = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2544),
                  fixedSize: Size.fromWidth(20),
                ),
                child: Text(
                  'Post Ad',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClientBottomNavigationBar(),
    );
  }
}
