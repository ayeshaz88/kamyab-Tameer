import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Item', style: TextStyle(color: Colors.white)),
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
                    // Add more fields as needed
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showUpdateItemDialog(context, item.reference);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUpdateItemDialog(BuildContext context, DocumentReference itemRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController itemNameController = TextEditingController();
        TextEditingController sellerNameController = TextEditingController();

        return AlertDialog(
          title: Text('Update Item'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: itemNameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: sellerNameController,
                  decoration: InputDecoration(labelText: 'Seller Name'),
                ),
                // Add more fields as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                String updatedItemName = itemNameController.text.trim();
                String updatedSellerName = sellerNameController.text.trim();

                if (updatedItemName.isNotEmpty || updatedSellerName.isNotEmpty) {
                  Map<String, dynamic> dataToUpdate = {};

                  if (updatedItemName.isNotEmpty) {
                    dataToUpdate['itemName'] = updatedItemName;
                  }
                  if (updatedSellerName.isNotEmpty) {
                    dataToUpdate['sellerName'] = updatedSellerName;
                  }

                  // Update item data in Firestore
                  itemRef.update(dataToUpdate).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item updated')));
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update item: $error')));
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
