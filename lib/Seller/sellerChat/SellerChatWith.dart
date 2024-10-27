import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Seller/sellerChat/seller_client_chat.dart';
import 'package:kamiyabtameer/Seller/sellerChat/seller_contractor_chat.dart';
import '../seller_bottom_nav.dart';

class SellerChatWithScreen extends StatelessWidget {
  const SellerChatWithScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select user to Chat',
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

            // _buildSection('Favourites', Icons.favorite, Icons.arrow_forward_ios, context),
            _buildSection('Contractor', Icons.person, Icons.arrow_forward_ios, context),
            _buildSection('Client', Icons.person_2, Icons.arrow_forward_ios, context),
            // _buildSection('Feedback', Icons.feedback, Icons.arrow_forward_ios, context),
            // _buildSection('Language', Icons.language, Icons.arrow_forward_ios, context),
          ],
        ),
      ),
      bottomNavigationBar: SellerBottomNavigationBar(),
    );
  }

  Widget _buildSection(String label, IconData icon, IconData arrowIcon, BuildContext context) {
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
            if (label == 'Contractor') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SellerContractorChatScreen()),
              );
            }
            if (label == 'Client'){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  SellerClientChatScreen()),);
            }
            // if (label == 'Feedback') {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => ContFeedbackScreen()),
            //   );
            // }
            // Navigate to ImageInfoSettingScreen when "Image Info Settings" is clicked
            // Add more conditions for other sections if needed
          },
        ),
        const Divider(),
      ],
    );
  }
}
