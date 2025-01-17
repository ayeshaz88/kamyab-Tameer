
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const id = '/ProductDetailsScreen';
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title:
        Text('Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1F2544),
      ),
    );
  }
}
