import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Seller/seller.dart';
import 'package:kamiyabtameer/Seller/sellerChat/SellerChatWith.dart';
import 'package:kamiyabtameer/Seller/sellerChat/seller_contractor_chat.dart';
import 'package:kamiyabtameer/Seller/sellerProfile/seller_profile.dart';


class SellerBottomNavigationBar extends StatelessWidget {
  const SellerBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF1F2544),
      unselectedItemColor: const Color(0xFF1F2544),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.store),
        //   label: 'Store',
        // ),
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
                builder: (context) => SellerDashboard(),
              ),
            );
            break;
        // case 1:
        //   // Handle Store navigation
        //   break;
          case 1:
          // Handle Chat navigation
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SellerChatWithScreen(),
              ),
            );
            break;
          case 2:
          // Handle Settings navigation
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SellerProfileScreen(),
              ),
            );
            break;
        // Handle other items if needed
        }
      },
    );
  }
}
