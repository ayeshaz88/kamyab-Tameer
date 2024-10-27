import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Admin/Users/view_contractor.dart';
import 'package:kamiyabtameer/Admin/Users/view_seller.dart';
import 'package:kamiyabtameer/Admin/Users/view_client.dart';
import 'package:kamiyabtameer/Admin/admin_bottom_nav.dart';
import 'package:kamiyabtameer/Starting_Screen/login.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Panel",
          style: TextStyle(color: Color.fromARGB(255, 239, 240, 241)),
        ),
        backgroundColor: Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage(),),
                )
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewClientScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF3A98B9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(20),
              ),
              child: SizedBox(
                width: buttonWidth,
                height: 125,
                child: Row(
                  children: [
                    Text(
                      "CLIENTS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Container(
                      width: 125,
                      height: 125,
                      child: Image.asset(
                        'assets/images/user_new-removebg-preview.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewContractorScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFFADC4CE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(20),
              ),
              child: SizedBox(
                width: buttonWidth,
                height: 125,
                child: Row(
                  children: [
                    Text(
                      "CONTRACTORS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Container(
                      width: 125,
                      height: 125,
                      child: Image.asset(
                        'assets/images/contractor_new-removebg-preview.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewSellerScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF183D3D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(20),
              ),
              child: SizedBox(
                width: buttonWidth,
                height: 125,
                child: Row(
                  children: [
                    Text(
                      "SELLER",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Container(
                      width: 125,
                      height: 125,
                      child: Image.asset(
                        'assets/images/seller_hardware.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminBottomNavigationBar(), // Include the AdminBottomNavigationBar here
    );
  }
}
