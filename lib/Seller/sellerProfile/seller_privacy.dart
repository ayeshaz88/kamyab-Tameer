import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamiyabtameer/Starting_Screen/register.dart';


class SellerPrivacyScreen extends StatefulWidget {
  @override
  _SellerPrivacyScreenState createState() =>
      _SellerPrivacyScreenState();
}

class _SellerPrivacyScreenState
    extends State<SellerPrivacyScreen> {
  String newPassword = '';
  String newPhoneNumber = '';

  void _showConfirmationDialog(String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to $action?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform action here
                if (action == 'delete your account') {
                  _deleteAccount();
                }
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Delete user document from Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
        // Delete user account from Firebase Authentication
        await user.delete();
        // Navigate back to the registration screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RegisterPage()),
              (Route<dynamic> route) => false,
        );
      } catch (e) {
        // Handle error
        print('Error deleting account: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to save these changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    // Change password
                    if (newPassword.isNotEmpty) {
                      await user.updatePassword(newPassword);
                    }
                    // Update phone number
                    if (newPhoneNumber.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({'phoneNumber': newPhoneNumber});
                    }
                    Navigator.of(context).pop(); // Pop the confirmation dialog
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Changes saved successfully'),
                      ),
                    );
                  } catch (e) {
                    // Handle error
                    print('Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to save changes: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1F2544),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputFieldWithIcon(
              label: 'Change Password:',
              hintText: 'Enter new password',
              onChanged: (value) {
                newPassword = value;
              },
              icon: Icons.lock,
            ),
            SizedBox(height: 16.0),
            _buildInputFieldWithIcon(
              label: 'Change Phone Number:',
              hintText: 'Enter new phone number',
              onChanged: (value) {
                newPhoneNumber = value;
              },
              icon: Icons.phone,
            ),
            SizedBox(height: 40.0),
            Center(
              child: ElevatedButton(
                onPressed: () => _showConfirmationDialog('delete your account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1F2544),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () => _saveChanges(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1F2544),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFieldWithIcon({
    required String label,
    required String hintText,
    required void Function(String) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Icon(
              icon,
              color: Color(0xFF1F2544),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: hintText,
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}