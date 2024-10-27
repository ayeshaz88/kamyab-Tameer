import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Admin/Users/all_users.dart';
import 'package:kamiyabtameer/Admin/admin.dart';

class AdminBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: const Color(0xFFFFFFFF),
        selectedItemColor: const Color(0xFF1F2544),
        unselectedItemColor: const Color(0xFF1F2544),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Users',
        ),
      ],
      onTap: (index) {
        // Handle item click
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllUsersScreen()),
            );
            break;
        // Handle other items if needed
        }
      },
    );
  }
}
