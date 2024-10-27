// import 'package:flutter/material.dart';
// import 'package:kamiyabtameer/ClientChatWith.dart';
// import 'package:kamiyabtameer/client.dart';
// import 'package:kamiyabtameer/profile.dart';
// import 'package:kamiyabtameer/store.dart';
// import 'add_project.dart';
// // import 'delete_project.dart';
// // import 'update_project.dart';
// import 'view_project.dart';

// class ProjectScreen extends StatelessWidget {
//   const ProjectScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Projects',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color(0xFF1F2544),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: 2,
//           crossAxisSpacing: 16.0,
//           mainAxisSpacing: 16.0,
//           children: [
//             itemDashboard('Add', Icons.add, Colors.blueAccent, () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => AddProjectScreen()));
//             }),
//             itemDashboard('Delete', Icons.delete, Colors.red, () {
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteProjectScreen()));
//             }),
//             itemDashboard('Update', Icons.edit, Colors.deepPurpleAccent, () {
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProjectScreen()));
//             }),
//             itemDashboard('View', Icons.visibility, Colors.teal, () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const ViewProjectScreen()));
//             }),
//           ],
//         ),
//       ),
// bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: const Color(0xFF1F2544),
//         selectedItemColor: const Color(0xFF1F2544),
//         unselectedItemColor: const Color(0xFF1F2544),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.work),
//             label: 'Project',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.store),
//             label: 'Store',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'Chat',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//         onTap: (index) {
//           // Handle item click
//           switch (index) {
//             case 0:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ClientDashboard()),
//               );
//               break;
//             case 1:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ProjectScreen()),
//               );
//               break;
//             case 2:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const StoreScreen()),
//               );
//               break;
//             case 3:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ChatScreen()),
//               );
//               break;
//             case 4:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ProfileScreen()),
//               );
//               break;
//             // Handle other items if needed
//           }
//         },
//       ),
//     );
//   }

//   Widget itemDashboard(
//       String title, IconData icon, Color color, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         elevation: 5.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 80.0,
//               height: 80.0,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: color,
//               ),
//               child: Center(
//                 child: Icon(
//                   icon,
//                   color: Colors.white,
//                   size: 40.0,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16.0,
//                 // fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../client_bottom_nav.dart';
import 'add_project.dart';
import 'view_project.dart';
import 'delete_project.dart';
import 'update_project.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Projects',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            itemDashboard('Add', Icons.add, Colors.blueAccent, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProjectScreen()));
            }),
            itemDashboard('Delete', Icons.delete, Colors.red, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeleteProjectScreen()));
            }),
            itemDashboard('Update', Icons.edit, Colors.deepPurpleAccent, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProjectScreen()));
            }),
            itemDashboard('View', Icons.visibility, Colors.teal, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewProjectScreen()));
            }),
          ],
        ),
      ),
      bottomNavigationBar: ClientBottomNavigationBar(),
    );
  }

  Widget itemDashboard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
