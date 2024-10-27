import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewProjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Projects', style: TextStyle(color: Colors.white)),
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
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    _showProjectDetailsDialog(context, project);
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
void _showProjectDetailsDialog(BuildContext context, DocumentSnapshot project) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Project Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${project['name']}'),
              Text('Location: ${project['location']}'),
              Text('Budget: ${project['budget']}'),
              Text('Description: ${project['des']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
