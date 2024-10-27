import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to stay on the splash screen for 5 seconds
    Timer(const Duration(seconds: 5), () {
      // Navigate to the login page after 5 seconds
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFC1C3D3), // Set background color
        child: Center(
          child: Image.asset(
            'assets/images/kamiyan_tameer_splash.png',
            width: 400, // Adjust width as needed
            height: 400, // Adjust height as needed
          ),
        ),
      ),
    );
  }
}
