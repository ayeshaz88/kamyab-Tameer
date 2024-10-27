// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kamiyabtameer/screen/product_list.dart';
import 'package:provider/provider.dart';
import '../helper/Product.dart';
import '../helper/Productprovider.dart';
import '../model/cart_model.dart';

class MainShoppingScreen extends StatefulWidget {
  static const id = '/MainShoppingScreen';

  MainShoppingScreen({Key? key}) : super(key: key);

  @override
  State<MainShoppingScreen> createState() => _MainShoppingScreenState();
}

class _MainShoppingScreenState extends State<MainShoppingScreen> {
  bool showFav = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('E-Commerce Store', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF1F2544),

          actions: [
            PopupMenuButton(
              onSelected: (int selectedVal) {
                if (selectedVal == 0) {
                  setState(() {
                    showFav = true;
                  });
                }
                if (selectedVal == 1) {
                  setState(() {
                    showFav = false;
                  });
                }
              },
              icon: Icon(Icons.more_vert, color: Colors.white,),
              itemBuilder: (_) {
                return [
                  PopupMenuItem(child: Text('filter by favorite'), value: 0),
                  PopupMenuItem(child: Text('remove filters'), value: 1),
                ];
              },
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                  }, icon: Icon(Icons.shopping_cart_checkout, color: Colors.white,))
          ],
        ),
        body: ProductsGrid(
          isFav: showFav,
        ),
      ),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
    required this.isFav,
  }) : super(key: key);

  final bool isFav;

  @override
  Widget build(BuildContext context) {
    final productDate = Provider.of<Products>(context);
    final availProducts =
    isFav ? productDate.favoriteProducts : productDate.availProducts;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: availProducts.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider<Product>.value(
          value: availProducts[index],
          //create: (BuildContext context) => availProducts[index],
          child: GridProductItem(
            // id: availProducts[index].id,
            // title: availProducts[index].title,
            // image: availProducts[index].image,
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 30,
      ),
    );
  }
}