import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Items', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1F2544),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
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
              var item = snapshot.data!.docs[index];
              return ListTile(
                title: Text(
                  item['itemName'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seller Name: ${item['sellerName']}'),
                    Text('Price: ${item['price']}'),
                    // Add more fields as needed
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    _showItemDetailsDialog(context, item);
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

void _showItemDetailsDialog(BuildContext context, DocumentSnapshot item) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Item Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Item Name: ${item['itemName']}'),
              Text('Seller Name: ${item['sellerName']}'),
              Text('Price: ${item['price']}'),
              Text('Description: ${item['description']}'),
              // Add more fields as needed
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
