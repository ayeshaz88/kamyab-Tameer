import 'package:flutter/material.dart';
import 'package:kamiyabtameer/PaymentPage.dart';

class ContStoreScreen extends StatefulWidget {
  @override
  _ContStoreScreenState createState() => _ContStoreScreenState();
}

class _ContStoreScreenState extends State<ContStoreScreen> {
  List<bool> isAddedToCartList = List.generate(13, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1F2544),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Constructor Store',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    isAddedToCartList: isAddedToCartList,
                    images: [
                      'assets/images/water-house.png',
                      'assets/images/construction.png',
                      'assets/images/paint-brush.png',
                      'assets/images/broken-cable.png',
                      'assets/images/beam_11757426.png',
                      'assets/images/bricks_7141031.png',
                      'assets/images/bricks_7899455.png',
                      'assets/images/carriage-wheel_10708477.png',
                      'assets/images/cement_3769425.png',
                      'assets/images/cement_7627964.png',
                      'assets/images/hardwood_12326975.png',
                      'assets/images/stone_15787249.png',
                      'assets/images/technology_12917150.png',
                    ],
                    names: [
                      'Water House',
                      'Construction',
                      'Paint Brush',
                      'Broken Cable',
                      'Beam',
                      'Bricks',
                      'Bricks',
                      'Carriage Wheel',
                      'Cement',
                      'Cement',
                      'Hardwood',
                      'Stone',
                      'Technology',
                    ],
                    prices: [
                      '\$20',
                      '\$30',
                      '\$10',
                      '\$15',
                      '\$25',
                      '\$5',
                      '\$5',
                      '\$35',
                      '\$8',
                      '\$8',
                      '\$12',
                      '\$18',
                      '\$40',
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildListItem(
            image: 'assets/images/water-house.png',
            name: 'Water House',
            price: '\$20',
            index: 0,
          ),
          _buildListItem(
            image: 'assets/images/construction.png',
            name: 'Construction',
            price: '\$30',
            index: 1,
          ),
          _buildListItem(
            image: 'assets/images/paint-brush.png',
            name: 'Paint Brush',
            price: '\$10',
            index: 2,
          ),
          _buildListItem(
            image: 'assets/images/broken-cable.png',
            name: 'Broken Cable',
            price: '\$15',
            index: 3,
          ),
          _buildListItem(
            image: 'assets/images/beam_11757426.png',
            name: 'Beam',
            price: '\$25',
            index: 4,
          ),
          _buildListItem(
            image: 'assets/images/bricks_7141031.png',
            name: 'Bricks',
            price: '\$5',
            index: 5,
          ),
          _buildListItem(
            image: 'assets/images/bricks_7899455.png',
            name: 'Bricks',
            price: '\$5',
            index: 6,
          ),
          _buildListItem(
            image: 'assets/images/carriage-wheel_10708477.png',
            name: 'Carriage Wheel',
            price: '\$35',
            index: 7,
          ),
          _buildListItem(
            image: 'assets/images/cement_3769425.png',
            name: 'Cement',
            price: '\$8',
            index: 8,
          ),
          _buildListItem(
            image: 'assets/images/cement_7627964.png',
            name: 'Cement',
            price: '\$8',
            index: 9,
          ),
          _buildListItem(
            image: 'assets/images/hardwood_12326975.png',
            name: 'Hardwood',
            price: '\$12',
            index: 10,
          ),
          _buildListItem(
            image: 'assets/images/stone_15787249.png',
            name: 'Stone',
            price: '\$18',
            index: 11,
          ),
          _buildListItem(
            image: 'assets/images/technology_12917150.png',
            name: 'Technology',
            price: '\$40',
            index: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
      {required String image,
      required String name,
      required String price,
      required int index}) {
    return Card(
      child: ListTile(
        leading: Image.asset(image),
        title: Text('Name: $name'),
        subtitle: Text('Price: $price'),
        onTap: () {
          // Add onTap logic here
        },
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart,
              color:
                  isAddedToCartList[index] ? Colors.green : Colors.grey[400]),
          onPressed: () {
            setState(() {
              isAddedToCartList[index] = !isAddedToCartList[index];
            });
          },
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  final List<bool> isAddedToCartList;
  final List<String> images;
  final List<String> names;
  final List<String> prices;

  CartScreen({
    required this.isAddedToCartList,
    required this.images,
    required this.names,
    required this.prices,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    quantities = List.generate(widget.isAddedToCartList.length, (index) => 1);
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = 0;
    for (int i = 0; i < widget.isAddedToCartList.length; i++) {
      if (widget.isAddedToCartList[i]) {
        totalPrice += int.parse(widget.prices[i].substring(1)) * quantities[i];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.isAddedToCartList.length,
              itemBuilder: (context, index) {
                if (widget.isAddedToCartList[index]) {
                  return ListTile(
                    leading:
                        Image.asset(widget.images[index]), // Display item image
                    title: Text(widget.names[index]), // Display item name
                    subtitle: Text(
                        'Price: ${widget.prices[index]}'), // Display item price
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantities[index] > 1) {
                                quantities[index]--;
                              }
                            });
                          },
                        ),
                        Text(quantities[index]
                            .toString()), // Display item quantity
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantities[index]++;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox
                      .shrink(); // If item not added to cart, return an empty widget
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(),
                  ),
                );
              },
              child: Text('Order Now'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total Price: \$${totalPrice.toString()}'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContStoreScreen(),
  ));
}
