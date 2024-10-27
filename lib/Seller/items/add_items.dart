import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/snackbar.dart';
import '../seller_bottom_nav.dart';

class SellerAddItemScreen extends StatefulWidget {
  @override
  _SellerAddItemScreenState createState() => _SellerAddItemScreenState();
}

class _SellerAddItemScreenState extends State<SellerAddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _sellerNameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isloading = false;
  File? _image;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  prefixIcon: Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _sellerNameController,
                decoration: InputDecoration(
                  labelText: 'Seller Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seller name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _image != null
                  ? Image.file(_image!)
                  : ElevatedButton.icon(
                onPressed: _getImageFromGallery,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF1F2544),
                ),
                icon: Icon(Icons.image),
                label: Text('Upload Image'),
              ),
              SizedBox(height: 20),
              isloading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isloading = true;
                    });

                    try {
                      // Upload image to Firebase Storage
                      String imagePath = 'images/${DateTime.now()}.png';
                      TaskSnapshot snapshot = await FirebaseStorage.instance
                          .ref()
                          .child(imagePath)
                          .putFile(_image!);
                      final imageUrl = await snapshot.ref.getDownloadURL();

                      // Store data in Firestore
                      await FirebaseFirestore.instance.collection('items').add({
                        "itemName": _itemNameController.text,
                        "sellerName": _sellerNameController.text,
                        "price": _priceController.text,
                        "description": _descriptionController.text,
                        "imageUrl": imageUrl,
                        // Add more fields as needed
                      });

                      // Show success message
                      showCustomSnackBar(
                        Icons.check_circle,
                        "Item Added",
                        "Item has been successfully added.",
                        Colors.green,
                      );
                    } catch (e) {
                      // Show error message if any
                      showCustomSnackBar(
                        Icons.error_outline,
                        "Error",
                        "An error occurred while adding the item: $e",
                        Colors.red,
                      );
                    }

                    setState(() {
                      isloading = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2544),
                  fixedSize: Size.fromWidth(20), // Adjust the width as needed
                ),
                child: Text(
                  'Add Item',
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
      bottomNavigationBar: SellerBottomNavigationBar(),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SellerAddItemScreen(),
  ));
}
