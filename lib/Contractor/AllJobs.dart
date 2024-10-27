import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllJobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder
        (
        stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
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
                title: Text(project['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Duration: ${project['duration']}'),
                    Text('Budget: ${project['budget']}'),
                    Text('Description: ${project['des']}'),
                  ],
                ),

              );
            },
          );
        },
      ),
    );
  }
}