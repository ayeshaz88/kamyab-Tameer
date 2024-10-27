import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Project', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1F2544),
      ),
      body: StreamBuilder(
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
                title: Text(project['name'],
                  style: TextStyle(
                  fontWeight: FontWeight.bold, // Makes the text bold
                  fontSize: 18, // Adjust the font size as needed
                ), ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${project['location']}'),

                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showStatusDialog(context, project.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showStatusDialog(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mark Project Status'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildStatusOption(context, projectId, 'Completed'),
                _buildStatusOption(context, projectId, 'Ongoing'),
                _buildStatusOption(context, projectId, 'Cancelled'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(BuildContext context, String projectId, String status) {
    return ListTile(
      title: Text(status),
      onTap: () {
        // Update project status in Firestore
        FirebaseFirestore.instance.collection('projectStatus').doc(projectId).set({
          'status': status,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Project marked as $status')));
          Navigator.pop(context); // Close the dialog
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to mark project status: $error')));
        });
      },
    );
  }
}
