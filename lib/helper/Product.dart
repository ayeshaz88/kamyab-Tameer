
import 'package:flutter/material.dart';

import 'Productprovider.dart';

class Products with ChangeNotifier{

  List<Product> _availProducts = [
    Product(
        id: '1001',
        title: '1000',
        description: "1000",
        image: 'assets/images/water-house.png',
        price: 1000),
    Product(
        id: '1002',
        title: '500',
        description: "500",
        image: 'assets/images/construction.png',
        price: 500),
    Product(
        id: '1003',
        title: '299',
        description: "299",
        image: 'assets/images/paint-brush.png',
        price: 299),
    Product(
        id: '1004',
        title: '1004',
        description: "2000",
        image: 'assets/images/broken-cable.png',
        price: 2000),
    Product(
        id: '1005',
        title: '1005',
        description: "1000",
        image: 'assets/images/water-house.png',
        price: 1000),
    Product(
        id: '1002',
        title: '500',
        description: "500",
        image: 'assets/images/construction.png',
        price: 500),
    Product(
        id: '1003',
        title: '299',
        description: "299",
        image: 'assets/images/paint-brush.png',
        price: 299),
    Product(
        id: '1004',
        title: '1004',
        description: "2000",
        image: 'assets/images/broken-cable.png',
        price: 2000,
      ),
  ];

  List<Product>get favoriteProducts{
    return _availProducts.where((product)=> product.isFavorite).toList();
  }

  List<Product> get availProducts => _availProducts;

// void addProduct(value){
//   _availProducts.add(value);
//   notifyListeners();
// }

}