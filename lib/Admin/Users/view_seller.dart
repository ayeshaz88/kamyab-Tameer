import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:kamiyabtameer/Admin/admin_bottom_nav.dart';

class ViewSellerScreen extends StatefulWidget {
  @override
  _ViewSellerScreenState createState() => _ViewSellerScreenState();
}

class _ViewSellerScreenState extends State<ViewSellerScreen> {
  // List to store users fetched from Firestore
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    // Call a function to fetch users when the widget initializes
    fetchUsers();
  }

  // Function to fetch users from Firestore
  Future<void> fetchUsers() async {
    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Query Firestore collection where 'type' field is 'Client'
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('type', isEqualTo: 'Seller')
          .get();

      // Iterate over documents and add them to the users list
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> userData = {
          'id': doc.id, // Document ID
          'email': doc['email'],
          'password': doc['password'],
          'uid': doc['uid'],
          'username': doc['username'],
        };
        users.add(userData);
      });

      // Update the UI with the fetched data
      setState(() {});
    } catch (e) {
      // Handle any errors
      print('Error fetching users: $e');
    }
  }

  // Function to show user details in an alert dialog
  void viewUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User ID: ${user['id']}'),
              Text('Username: ${user['username']}'),
              Text('Email: ${user['email']}'),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete user from Firestore
  Future<void> deleteUser(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('users').doc(userId).delete();
      // Remove the user from the local list
      users.removeWhere((user) => user['id'] == userId);
      setState(() {}); // Update UI
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contractors',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFF183D3D)),
              headingTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              dataRowHeight: 56,
              columnSpacing: 16,
              columns: [
                DataColumn(label: Text('User ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(
                    label: Text('Actions',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold))),
              ],
              rows: List.generate(
                users.length,
                    (index) => DataRow(
                  cells: [
                    DataCell(Text(users[index]['id'].toString())),
                    DataCell(Text(users[index]['username'])),
                    DataCell(Text(users[index]['email'])),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.visibility,
                              color: Color(0xFF183D3D)),
                          onPressed: () {
                            viewUserDetails(users[index]);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete,
                              color: Color(0xFF183D3D)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text(
                                      'Are you sure you want to delete this user?'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        deleteUser(users[index]['id']);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: AdminBottomNavigationBar(),
    );
  }
}