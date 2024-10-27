import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamiyabtameer/Contractor/contractor_botton_nav.dart';

class ContImgInfoScreen extends StatelessWidget {
  ContImgInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Info Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField(Icons.person, 'Username', 'Enter new username'),
            SizedBox(height: 20.0),
            _buildInputField(Icons.email, 'Email Address', 'Enter new email address'),
            SizedBox(height: 20.0),
            _buildInputField(Icons.date_range, 'Date of Birth', 'Enter new date of birth'),
            SizedBox(height: 20.0),
            _buildInputField(Icons.phone, 'Phone Number', 'Enter new phone number'),
            SizedBox(height: 20.0),
            _buildGenderDropdown(),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () async {
                // Show confirmation dialog when Save Changes button is pressed
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Save Changes'),
                      content: Text('Are you sure you want to make these changes?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // Return false when No is pressed
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true); // Return true when Yes is pressed
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  },
                ).then((confirmed) async {
                  if (confirmed != null && confirmed) {
                    // If user confirmed, save changes
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      try {
                        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                          'username': newUsername,
                          'email': newEmailAddress,
                          'dateOfBirth': newDateOfBirth,
                          'phoneNumber': newPhoneNumber,
                          'gender': newGender,
                        });
                        // Update user's email if it's changed
                        if (newEmailAddress != user.email) {
                          await user.updateEmail(newEmailAddress);
                        }
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Changes saved successfully'),
                        ));

                        newUsername = '';
                        newEmailAddress = '';
                        newDateOfBirth = '';
                        newPhoneNumber = '';
                        newGender = '';

                      } catch (e) {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to save changes: $e'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF1F2544), // Text color
                padding: EdgeInsets.symmetric(vertical: 15.0), // Button padding
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), // Button border radius
                minimumSize: Size(double.infinity, 50), // Set minimum width and height
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ContractorBottomNavigationBar(),
    );
  }

  String newUsername = '';
  String newEmailAddress = '';
  String newDateOfBirth = '';
  String newPhoneNumber = '';
  String newGender = '';

  Widget _buildInputField(IconData icon, String label, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: const Color(0xFF1F2544),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Icon(icon, color: Color(0xFF1F2544)),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    if (label == 'Username') {
                      newUsername = value;
                    } else if (label == 'Email Address') {
                      newEmailAddress = value;
                    } else if (label == 'Date of Birth') {
                      newDateOfBirth = value;
                    } else if (label == 'Phone Number') {
                      newPhoneNumber = value;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Change Gender',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: const Color(0xFF1F2544),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Icon(Icons.person, color: Color(0xFF1F2544)),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  onChanged: (value) {
                    newGender = value!;
                  },
                  decoration: InputDecoration(
                    hintText: 'Select gender',
                    border: InputBorder.none,
                  ),
                  items: <String>['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}