import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamiyabtameer/Client/Client_Store/store.dart';
import 'package:kamiyabtameer/Client/client_bottom_nav.dart';
import 'package:kamiyabtameer/Client/Client_Profile/profile.dart';
import 'package:kamiyabtameer/Client/Client_Project/project.dart';
import 'package:kamiyabtameer/Starting_Screen/login.dart';

import '../screen/cart_screen.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ClientDashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1F2544),
              ),
              child: Text(
                'ClientDashboard Drawer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home, color: Color(0xFF1F2544)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientDashboard()),
                );
              },
            ),
            ListTile(
              title: const Text('Projects'),
              leading: const Icon(Icons.work, color: Color(0xFF1F2544)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectScreen()),
                );
              },
            ),
            ListTile(
              title: const Text("Store"),
              leading: const Icon(Icons.store, color: Color(0xFF1F2544)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StoreScreen()),
                );
              },
            ),
            ListTile(
              title: const Text("Settings"),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.exit_to_app, color: Color(0xFF1F2544)),
              onTap: () {
                // Show logout confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to login page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Jobs',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Jobs',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var jobs = snapshot.data!.docs[index];
                    bool isFavorite = jobs['isFavorite'] ??
                        false; // Check if project is already favorite
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 150, // Adjust the height as needed
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: _buildJobImage(jobs['imageUrl']), // Use a method to build the image widget
                              title: Text(jobs['name']),
                              subtitle: Text('Budget: ${jobs['budget']}\$'),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                _toggleFavorite(
                                    jobs); // Call _toggleFavorite method with the job details
                              },
                              child: Container(
                                margin: EdgeInsets.all(8),
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showProjectDetailsDialog(context, jobs );
                                    // Pass job details to dialog method
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                  child: Text('View'),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    // Request button action
                                    _handleRequest(); // You can call a method to handle the request action
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green,
                                  ),
                                  child: Text('Request'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: ClientBottomNavigationBar(),
    );
  }

  void _handleRequest() {
    // Implement the action to handle the request button press, such as navigating to a screen or performing an action.
    // For example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => RequestScreen()),
    // );
  }

  void _toggleFavorite(DocumentSnapshot project) {
    bool isFavorite =
        project['isFavorite'] ?? false; // Check if project is already favorite

    // Toggle favorite status
    isFavorite = !isFavorite;

    // Update project's favorite status in Firestore
    FirebaseFirestore.instance.collection('jobs').doc(project.id).update({
      'isFavorite': isFavorite,
    });

    // If the project is now favorite, save its details to the favoriteproject collection
    if (isFavorite) {
      FirebaseFirestore.instance.collection('favoritejob').doc(project.id).set({
        'name': project['name'],
        'duration': project['duration'],
        'budget': project['budget'],
        'des': project['des'],
      });
    } else {
      // If the project is no longer favorite, delete its details from the favoriteproject collection
      FirebaseFirestore.instance
          .collection('favoriteproject')
          .doc(project.id)
          .delete();
    }
  }

  void _showProjectDetailsDialog(BuildContext context, DocumentSnapshot job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Job Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Duration: ${job['duration']}'),
                Text('Budget: ${job['budget']}'),
                Text('Description: ${job['des']}'),
                Text('Description: ${job['name']}'),
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

  // Method to build the job image widget
  Widget _buildJobImage(String? imageUrl) {
    return imageUrl != null
        ? Image.network(
      imageUrl,
      width: 50, // Adjust width as needed
      height: 50, // Adjust height as needed
      fit: BoxFit.cover,
    )
        : Container(
      width: 50,
      height: 50,
      color: Colors.grey, // Placeholder color if no image available
    );
  }
}
