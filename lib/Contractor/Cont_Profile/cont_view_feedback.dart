import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamiyabtameer/Client/client_bottom_nav.dart';

class ConViewFeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Color(0xFF1F2544),
      ),
      body: FeedbackList(),
      bottomNavigationBar: ClientBottomNavigationBar(),
    );
  }
}

class FeedbackList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Clientfeedback').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final List<DocumentSnapshot> feedbackDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot feedback = feedbackDocs[index];
              return ListTile(
                title: Text(feedback['description']),
                subtitle: Text('Rating: ${feedback['rating']}'),
              );
            },
          );
        }
      },
    );
  }
}

