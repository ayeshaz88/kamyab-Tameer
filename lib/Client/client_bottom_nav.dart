import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Contractor/Cont_store/cont_store.dart';
import 'Client_Chat/ClientChatWith.dart';
import 'Client_Profile/profile.dart';
import 'Client_Project/project.dart';
import 'Client_Store/ClientStore.dart';
import 'Client_Store/store.dart';
import 'client.dart';



class ClientBottomNavigationBar extends StatelessWidget {
  const ClientBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1F2544),
      selectedItemColor: const Color(0xFF1F2544),
      unselectedItemColor: const Color(0xFF1F2544),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'Project',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Store',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        // Handle item click
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClientDashboard()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ClientStoreScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ClientChatWithScreen()),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
            break;
          // Handle other items if needed
        }
      },
    );
  }
}
