import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Client/Client_Project/project.dart';
import 'package:kamiyabtameer/Starting_Screen/forget.dart';
import 'package:kamiyabtameer/Starting_Screen/login.dart';
import 'package:kamiyabtameer/Starting_Screen/register.dart';
import 'package:kamiyabtameer/Starting_Screen/splash.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      transitionDuration: const Duration(milliseconds: 500),
      defaultTransition: Transition.fadeIn,
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginPage(),
        ),
        GetPage(
          name: '/project',
          page: () => const ProjectScreen(),
        ),
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
        ),
        GetPage(
          name: '/forgot_password',
          page: () => ForgetPassword(),
        ),
      ],
      theme: ThemeData(
        primaryColor: const Color(0xFF1F2544),
        primarySwatch: const MaterialColor(
          0xFF1F2544,
          <int, Color>{
            50: Color(0xFFE3E4EB),
            100: Color(0xFFC1C3D3),
            200: Color(0xFF9FA1BB),
            300: Color(0xFF7D7F9F),
            400: Color(0xFF5B5E87),
            500: Color(0xFF1F2544),
            600: Color(0xFF1B2040),
            700: Color(0xFF171C36),
            800: Color(0xFF13182C),
            900: Color(0xFF0F1422),
          },
        ),
      ),
    );
  }
}
