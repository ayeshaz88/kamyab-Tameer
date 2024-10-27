import 'package:flutter/material.dart';

import '../client_bottom_nav.dart';


class ViewOldProjectScreen extends StatelessWidget {
  const ViewOldProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual logic to fetch old projects
    List<String> oldProjects = []; // Populate with actual data if available

    return Scaffold(
      appBar: AppBar(
        title: const Text('Old Projects', style: TextStyle(color: Colors.white,), // Professional color scheme
      ),
              backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(
            color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: oldProjects.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Empty-amico.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16.0),
                    const Text("No Old project is yet.",
                        style: TextStyle(
                            fontSize: 18.0, color: Color(0xFF1F2544))),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: oldProjects.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(oldProjects[index]),
                  // Add additional project details or actions as needed
                ),
              ),
      ),
      
      bottomNavigationBar: ClientBottomNavigationBar(),
    );
  }
}
