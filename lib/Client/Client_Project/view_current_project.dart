import 'package:flutter/material.dart';

import '../client_bottom_nav.dart';

class ViewCurrentProjectScreen extends StatelessWidget {
  const ViewCurrentProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> currentProjects = []; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Projects', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(
            color: Colors.white), // Professional color scheme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: currentProjects.isEmpty
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
                    const Text("No current project yet.",
                        style: TextStyle(
                            fontSize: 18.0, color: Color(0xFF1F2544))),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: currentProjects.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(currentProjects[index]),
                  // Add additional project details or actions as needed
                ),
              ),
      ),
      
      bottomNavigationBar: ClientBottomNavigationBar(),
    );
  }
}
