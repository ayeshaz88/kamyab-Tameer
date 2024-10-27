import 'package:flutter/material.dart';

import '../client_bottom_nav.dart';
import 'add_feedback.dart';
import 'view_feedback.dart';

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white)
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection('View Feedback', Icons.view_agenda, Icons.arrow_forward_ios, context),
            SizedBox(height: 20),
            _buildSection('Add Feedback', Icons.add_comment, Icons.arrow_forward_ios, context),
          ],
        ),
      ),
      bottomNavigationBar: ClientBottomNavigationBar(),
    );
  }

  Widget _buildSection(String title, IconData iconData, IconData arrowIcon, BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == 'View Feedback') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewFeedbackScreen()),
          );
        } else if (title == 'Add Feedback') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFeedbackScreen()),
          );
        }
      },
      child: Row(
        children: [
          Icon(
            iconData,
            color: Color(0xFF1F2544),
            size: 36,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2544),
              ),
            ),
          ),
          Icon(
            arrowIcon,
            color: Color(0xFF1F2544),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FeedbackScreen(),
  ));
}
