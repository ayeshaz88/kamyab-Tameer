import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Seller/sellerProfile/seller_img_info.dart';
import 'package:kamiyabtameer/Seller/sellerProfile/seller_notification.dart';
import 'package:kamiyabtameer/Seller/sellerProfile/seller_privacy.dart';
import 'package:image_picker/image_picker.dart';

import '../../Client/Client_Profile/image_info_setting.dart';
import '../../Starting_Screen/login.dart';
import '../seller_bottom_nav.dart';
// Import the NotificationScreen file // Import the ImageInfoSettingScreen file

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({Key? key}) : super(key: key);
  Future<void> _updateProfilePicture(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String imagePath = pickedFile.path;
      await updateProfilePicture(imagePath);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Profile picture updated')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No image selected')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfilePhotoSection(context),
            _buildSection('Notifications', Icons.notifications,
                Icons.arrow_forward_ios, context),
            _buildSection(
                'Privacy', Icons.lock, Icons.arrow_forward_ios, context),
            _buildSection(
                'Logout', Icons.exit_to_app, Icons.arrow_forward_ios, context),
          ],
        ),
      ),
      bottomNavigationBar: SellerBottomNavigationBar(),
    );
  }

  Widget _buildProfilePhotoSection(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Text('No user data found');
        }

        // Retrieve profile picture URL from Firestore data
        String? profilePictureUrl =
            (snapshot.data!.data() as Map<String, dynamic>?)?['profilePicture'];
        return GestureDetector(
          onTap: () {
            _updateProfilePicture(context);
          },
          child: Column(
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  image: profilePictureUrl != null
                      ? DecorationImage(
                          image: NetworkImage(profilePictureUrl),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage('assets/images/girl_avatar.png'),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageInfoSettingScreen()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'User Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      '|',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'ayesha@gmail.com', // Replace with user's email
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Icon(
                      Icons.edit,
                      color: Color(0xFF1F2544),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(
      String label, IconData icon, IconData arrowIcon, BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2544),
                ),
              ),
              const Spacer(),
              Icon(
                arrowIcon,
                color: const Color(0xFF1F2544),
                size: 16.0,
              ),
            ],
          ),
          leading: Icon(
            icon,
            color: const Color(0xFF1F2544),
          ),
          onTap: () {
            // Navigate to NotificationScreen when "Notifications" is clicked
            // if (label == 'Favourites') {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const ContFavouriteScreen()),
            //   );
            // }
            if (label == 'Notifications') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SellerNotificationScreen()),
              );
            }
            if (label == 'Privacy') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SellerPrivacyScreen()),
              );
            }
            // if (label == 'Feedback') {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => ContFeedbackScreen()),
            //   );
            // }
            if (label == 'Logout') {
              // Show logout confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            }
            // Navigate to ImageInfoSettingScreen when "Image Info Settings" is clicked
            if (label == 'Image Info Settings') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageInfoSettingScreen()),
              );
            }
            // Add more conditions for other sections if needed
          },
        ),
        const Divider(),
      ],
    );
  }
}

// Function to update profile picture
Future<void> updateProfilePicture(String imagePath) async {
  // Get current user
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Upload image to Firebase Storage
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profilePictures/${user.uid}');
    UploadTask uploadTask = storageReference.putFile(File(imagePath));

    // Wait for the upload to complete
    await uploadTask.whenComplete(() async {
      // Get download URL
      String downloadURL = await storageReference.getDownloadURL();

      // Update profile picture URL in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'profilePicture': downloadURL,
      });
    });
  }
}
