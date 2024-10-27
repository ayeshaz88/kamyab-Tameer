import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamiyabtameer/Client/Client_Store/store.dart';
import 'package:kamiyabtameer/Contractor/Cont_store/cont_store.dart';
import '../Starting_Screen/login.dart';
import 'Cont_Profile/profile_contractor.dart';
import 'Cont_job/job.dart';
import 'contractor_botton_nav.dart';

class ContractorDashboard extends StatelessWidget {
  const ContractorDashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    void _toggleFavorite(DocumentSnapshot project) {
      bool isFavorite = project['isFavorite'] ??
          false; // Check if project is already favorite

      // Toggle favorite status
      isFavorite = !isFavorite;

      // Update project's favorite status in Firestore
      FirebaseFirestore.instance.collection('projects').doc(project.id).update({
        'isFavorite': isFavorite,
      });

      // If the project is now favorite, save its details to the favoriteproject collection
      if (isFavorite) {
        FirebaseFirestore.instance
            .collection('favoriteproject')
            .doc(project.id)
            .set({
          'name': project['name'],
          'location': project['location'],
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

    void _sendNotification() {
      Map<String, dynamic> message = {
        'data': {
          'type': 'chat_request',
          'projectId': 'project123', // Example project ID
        },
        'notification': {
          'title': 'Chat Request',
          'body': 'You have a new chat request',
        },
      };
    }

    void _handleMessage(Map<String, dynamic> message) {
      // Handle incoming messages
      // Check if the message is a notification, and navigate to chat screen if necessary
      if (message.containsKey('data')) {
        final data = message['data'];
        if (data['type'] == 'chat_request') {
          // Navigate to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(projectId: data['projectId'])),
          );
        }
      }
    }

    // Subscribe to incoming messages when the widget is created
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    );

    _firebaseMessaging.getToken().then((String? token) {
      print('FCM Token: $token');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming messages when the app is in the foreground
      _handleMessage(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when the user taps on a notification when the app is in the background
      _handleMessage(message.data);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ContractorDashboard',
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
                'Contractor',
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
                      builder: (context) => const ContractorDashboard()),
                );
              },
            ),
            ListTile(
              title: const Text('Jobs'),
              leading: const Icon(Icons.work, color: Color(0xFF1F2544)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JobScreen()),
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
                  MaterialPageRoute(builder: (context) => ContProfileScreen()),
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
                  'Projects',
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
                hintText: 'Search Projects',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
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
            stream:
            FirebaseFirestore.instance.collection('projects').snapshots(),
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
                    var project = snapshot.data!.docs[index];
                    bool isFavorite = project['isFavorite'] ??
                        false; // Check if project is already favorite
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: _buildProjectImage(project['imageUrl']),
                              title: Text(project['name']),
                              subtitle: Text('Budget: ${project['budget']}\$'),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                // Toggle favorite status and update Firestore
                                _toggleFavorite(project);
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
                                    _showProjectDetailsDialog(context, project);
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
                                    _sendNotification();
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
      bottomNavigationBar: ContractorBottomNavigationBar(),
    );
  }

  void _showProjectDetailsDialog(
      BuildContext context, DocumentSnapshot project) {
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

  // Method to build the project image widget
  Widget _buildProjectImage(String? imageUrl) {
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

class ChatScreen extends StatelessWidget {
  final String projectId;

  const ChatScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Chat screen UI implementation
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Center(
        child: Text('Chat Screen for Project ID: $projectId'),
      ),
    );
  }
}
