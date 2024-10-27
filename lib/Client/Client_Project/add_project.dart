import 'package:flutter/material.dart';
import '../client_bottom_nav.dart';
import 'form_project.dart';

class AddProjectScreen extends StatelessWidget {
  final List<String> constructionProjects = [
    'Painting',
    'Carpentry',
    'Plumbing',
    'Electrical',
    'Roofing',
    'Flooring',
    'Renovation',
    'Landscaping',
  ];

  final List<String> constructionProjectImages = [
    'assets/images/painter.jpg',
    'assets/images/carpenter.jpg',
    'assets/images/plumber.jpg',
    'assets/images/electritian.jpg',
    'assets/images/roofing.jpg',
    'assets/images/tiles.jpg',
    'assets/images/renovationn.jpg',
    'assets/images/landscaping.jpg',
  ];

  AddProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          itemCount: constructionProjects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            return itemDashboard(
              constructionProjects[index],
              constructionProjectImages[index],
              () {
                print('Tapped on ${constructionProjects[index]}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectFormScreen(
                      category: constructionProjects[index],
                      isFavorite: false, // Set isFavorite to false
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: ClientBottomNavigationBar(),
    );
  }

  Widget itemDashboard(String title, String imagePath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Colors.black.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
