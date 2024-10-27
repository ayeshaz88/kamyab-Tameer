import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Contractor/Cont_Profile/profile_contractor.dart';
import 'package:kamiyabtameer/Contractor/Cont_job/job.dart';
import 'package:kamiyabtameer/Contractor/Cont_store/cont_store.dart';
import 'package:kamiyabtameer/Contractor/contractor.dart';
import 'package:kamiyabtameer/Contractor/contractorChat/ContractorChatWith.dart';

import '../Client/Client_Chat/ClientChatWith.dart';
import '../Client/Client_Store/store.dart';
import '../screen/cart_screen.dart';
import 'contractorChat/ContractorClientChat.dart';

class ContractorBottomNavigationBar extends StatelessWidget {
  const ContractorBottomNavigationBar({Key? key}) : super(key: key);

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
          label: 'Jobs',
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
              MaterialPageRoute(
                builder: (context) => const ContractorDashboard(),
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobScreen(),
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContStoreScreen(),
              ),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContractorChatWithScreen(),
              ),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContProfileScreen(),
              ),
            );
            break;
          // Handle other items if needed
        }
      },
    );
  }
}
