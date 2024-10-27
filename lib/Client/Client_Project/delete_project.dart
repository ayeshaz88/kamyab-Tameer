import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteProjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Project', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1F2544),
      ),
      body: StreamBuilder
        (
        stream: FirebaseFirestore.instance.collection('projects').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var project = snapshot.data!.docs[index];
              return ListTile(
                title: Text(project['name'], style: TextStyle(
                  fontWeight: FontWeight.bold, // Makes the text bold
                  fontSize: 18, // Adjust the font size as needed
                ),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location: ${project['location']}'),

                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, project.reference);
                    // Add your navigation logic here
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
void _showDeleteConfirmationDialog(BuildContext context, DocumentReference projectRef) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              projectRef.delete().then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Project deleted')));
                Navigator.pop(context); // Close the dialog
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete project: $error')));
              });
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}
