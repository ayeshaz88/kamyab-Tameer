import 'package:flutter/material.dart';

class AddToCartScreen extends StatefulWidget {
  final String productName;
  final String price;
  final String imageIndex;

  AddToCartScreen({
    required this.productName,
    required this.price,
    required this.imageIndex,
  });

  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  bool _addedToCart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Cart'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imageIndex as String,
              height: 100, // Adjust as needed
              width: 100, // Adjust as needed
            ),
            SizedBox(height: 20),
            Text(
              widget.productName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.price,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _addedToCart = !_addedToCart;
                });
              },
              child: Text(_addedToCart ? 'Remove from Cart' : 'Add to Cart'),
            ),
            SizedBox(height: 10),
            if (_addedToCart) Text('Item added to cart'),
          ],
        ),
      ),
    );
  }
}