import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Seller/items/add_items.dart';
import 'package:kamiyabtameer/Seller/items/update_item.dart';
import 'package:kamiyabtameer/Seller/sellerChat/SellerChatWith.dart';
import 'package:kamiyabtameer/Seller/sellerProfile/seller_profile.dart';
import 'package:kamiyabtameer/Seller/seller_bottom_nav.dart';
import 'package:kamiyabtameer/Starting_Screen/login.dart';

import 'items/delete_item.dart';
import 'items/view_item.dart';


class SellerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1F2544),
              ),
              child: Text(
                'Seller',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SellerDashboard()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellerChatWithScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellerProfileScreen()),
                );
              },
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.exit_to_app, color: Color(0xFF1F2544)),
              onTap: () {
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
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
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
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20), // Change top margin size here
          SizedBox(height: 20), // Adjust height between rows here
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LargeButton(label: 'Add Items', color: Color(0xFF6E85B7), icon: Icons.add, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SellerAddItemScreen()));
              }),
              _LargeButton(label: 'Delete Items', color: Color(0xFFF47C7C), icon: Icons.delete, onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteItemScreen()));
              }),
            ],
          ),
          SizedBox(height: 20), // Adjust height between rows here
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LargeButton(label: 'Update Items', color: Color(0xFFBBAB8C), icon: Icons.edit, onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateItemScreen()));
              }),
              _LargeButton(label: 'View Items', color: Color(0xFF9ED5C5), icon: Icons.visibility, onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => ViewItemScreen()));
              }),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SellerBottomNavigationBar(),
    );
  }
}

class _LargeButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _LargeButton({required this.label, required this.color, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        fixedSize: MaterialStateProperty.all<Size>(Size(170, 100)), // Change height and width of these buttons here
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, size: 36, color: Colors.white), // Change icon size here
            ),
          ),
          Center(
            child: Text(label, style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SellerDashboard(),
  ));
}
