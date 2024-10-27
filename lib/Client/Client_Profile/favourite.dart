import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Jobs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('favoritejob').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var favoriteProject = snapshot.data!.docs[index].data();
              return ListTile(
                title: Text(favoriteProject['name']),
                subtitle: Text('Budget: ${favoriteProject['budget']}\$'),
                trailing: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    _showProjectDetailsDialog(context, favoriteProject);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showProjectDetailsDialog(BuildContext context, Map<String, dynamic> favoriteProject) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Job Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${favoriteProject['name']}'),
                Text('Budget: ${favoriteProject['budget']}'),
                Text('Duration: ${favoriteProject['duration']}'),
                Text('Description: ${favoriteProject['des']}'),
                // Add other details as needed
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}